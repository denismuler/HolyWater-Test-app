//
//  RecommendedViewController.swift
//  HolyWater-Test
//
//  Created by Georgie Muler on 23.02.2024.
//

import Foundation
import UIKit
import CollectionViewPagingLayout
import RxSwift

class RecommendedViewController: UIViewController {
    // MARK: - IBOutlets
    
    @IBOutlet private weak var youWillAlsoLikeCollectionView: UICollectionView!
    @IBOutlet private weak var carouselCollectionView: UICollectionView!
    @IBOutlet private weak var readNowButton: UIButton!
    @IBOutlet private weak var roundView: UIView!
    @IBOutlet private weak var bookName: UILabel!
    @IBOutlet private weak var authorName: UILabel!
    @IBOutlet private weak var readersCount: UILabel!
    @IBOutlet private weak var likesCount: UILabel!
    @IBOutlet private weak var quotesCount: UILabel!
    @IBOutlet private weak var genrelbl: UILabel!
    @IBOutlet private weak var summarylbl: UILabel!
    @IBOutlet private weak var youWillLikeHeight: NSLayoutConstraint!
    
    var previousCellIndex: Int?
    // MARK: - Properties
    private let viewModel = RecommendedViewModel()
    private var carouselModel: [Carousel] = []
    private var recommendedModel: [Book] = []
    private let disposeBag = DisposeBag()
    var currentCellIndex: Int?
    
    private var isViewShowedFirstly: Bool = false
    private let layout = CollectionViewPagingLayout()
    
    
    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchData()
        setupCollectionView()
        setupBackButton()
        setupNavBarAppearance()
        backOnSwipe()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        carouselCollectionView.isUserInteractionEnabled = false
        layout.setCurrentPage(currentCellIndex ?? 0, animated: true) {
            self.updateBookInfo(with: self.carouselModel[self.currentCellIndex ?? 0])
            self.previousCellIndex = self.currentCellIndex
            self.isViewShowedFirstly = true
            self.carouselCollectionView.isUserInteractionEnabled = true
        }
    }
    
    // MARK: - Private methods
    private func setupUI() {
        readNowButton.layer.cornerRadius = 24
        roundView.roundCorner(with: 20, align: .upper)
        youWillLikeHeight.constant = Defaults.collectionViewSize
    }
    
    private func fetchData() {
        viewModel.fetchData().subscribe(onNext: { [weak self] books in
            self?.carouselModel = books
            guard let firstBook = books.first else { return }
            self?.updateBookInfo(with: firstBook)
        }, onError: { error in
            print("Error fetching data: \(error)")
        })
        .disposed(by: disposeBag)
        
        viewModel.fetchLikedBooksData().subscribe(onNext: { [weak self] books in
            self?.recommendedModel = books
        }, onError: { error in
            print("Error fetching data: \(error)")
        })
        .disposed(by: disposeBag)
    }
    
    private func setupCollectionView() {
        layout.numberOfVisibleItems = 4
        carouselCollectionView.collectionViewLayout = layout
        carouselCollectionView.isPagingEnabled = true
        carouselCollectionView.register(CarouselTestCollectionViewCell.nib, forCellWithReuseIdentifier: CarouselTestCollectionViewCell.identifier)
        carouselCollectionView.dataSource = self
        carouselCollectionView.delegate = self
        
        
        youWillAlsoLikeCollectionView.register(BookCollectionViewCell.nib, forCellWithReuseIdentifier: BookCollectionViewCell.identifier)
        youWillAlsoLikeCollectionView.dataSource = self
        youWillAlsoLikeCollectionView.delegate = self
    }
    
    private func setupBackButton() {
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "im_back_arrow"), for: .normal)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        let customBackButton = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = customBackButton
    }
    
    private func setupNavBarAppearance() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backgroundColor = UIColor.clear
        navigationController?.view.backgroundColor = UIColor.clear
        navigationController?.navigationBar.tintColor = .clear
    }
    
    
    private func updateBookInfo(with book: Carousel) {
        UIView.animate(withDuration: 0.2, animations: {
            self.bookName.alpha = 0.0
            self.authorName.alpha = 0.0
            self.readersCount.alpha = 0.0
            self.likesCount.alpha = 0.0
            self.quotesCount.alpha = 0.0
            self.genrelbl.alpha = 0.0
            self.summarylbl.alpha = 0.0
        }) { _ in
            self.bookName.text = book.name
            self.authorName.text = book.author
            self.readersCount.text = book.views
            self.likesCount.text = book.likes
            self.quotesCount.text = book.quotes
            self.genrelbl.text = book.genre
            self.summarylbl.text = book.summary
            
            UIView.animate(withDuration: 0.2, animations: {
                self.bookName.alpha = 1.0
                self.authorName.alpha = 1.0
                self.readersCount.alpha = 1.0
                self.likesCount.alpha = 1.0
                self.quotesCount.alpha = 1.0
                self.genrelbl.alpha = 1.0
                self.summarylbl.alpha = 1.0
            })
        }
    }
    
    @objc private func didTapBackButton(sender: AnyObject) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Extensions
// MARK: - UICollectionViewDelegate & DataSource
extension RecommendedViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == youWillAlsoLikeCollectionView {
            recommendedModel.count
        } else {
            carouselModel.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == carouselCollectionView {
            let carCell = carouselCollectionView.dequeueReusableCell(withReuseIdentifier: CarouselTestCollectionViewCell.identifier, for: indexPath) as! CarouselTestCollectionViewCell
            let carousel = carouselModel[indexPath.row]
            carCell.configure(image: carousel.coverUrl, book: carousel.name, author: carousel.author)
            return carCell
        } else {
            let alsoCell = youWillAlsoLikeCollectionView.dequeueReusableCell(withReuseIdentifier: BookCollectionViewCell.identifier, for: indexPath) as! BookCollectionViewCell
            let alsoLike = recommendedModel[indexPath.row]
            alsoCell.configure(label: alsoLike.name, image: alsoLike.coverUrl, labelColor: "c_lbl_summary")
            return alsoCell
        }
    }
}
// MARK: - ScrollViewDidScroll
extension RecommendedViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isViewShowedFirstly {
            if scrollView == carouselCollectionView {
                let currentIndex = Int(scrollView.contentOffset.x / scrollView.bounds.width)
                if currentIndex != previousCellIndex {
                    currentCellIndex = currentIndex
                    guard let currentCellIndex else { return }
                    let carousel = carouselModel[currentCellIndex]
                    updateBookInfo(with: carousel)
                    previousCellIndex = currentIndex
                }
            }
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension RecommendedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        return CGSize(width: screenWidth / 3 - 8, height: Defaults.collectionViewSize)
    }
}
