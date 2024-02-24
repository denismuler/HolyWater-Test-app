//
//  LibraryScreenViewController.swift
//  HolyWater-Test
//
//  Created by Georgie Muler on 21.02.2024.
//

import UIKit
import RxSwift
import RxDataSources
import InfiniteCarouselCollectionView

enum Defaults {
    static let width = UIScreen.main.bounds.width
    static let collectionViewSize = ((width / 3 - 8) / 0.8 ) + 48
}

class LibraryViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet private weak var newArrivalsCollectionView: UICollectionView!
    @IBOutlet private weak var romanceCollectionView: UICollectionView!
    @IBOutlet private weak var fantasyCollectionView: UICollectionView!
    @IBOutlet private weak var scienceCollectionView: UICollectionView!
    @IBOutlet private weak var bannerCollectionView: CarouselCollectionView!
    
    @IBOutlet private weak var pageControl: UIPageControl!
    
    @IBOutlet private weak var newArrivalsHeight: NSLayoutConstraint!
    @IBOutlet private weak var romanceHeight: NSLayoutConstraint!
    @IBOutlet private weak var fantasyHeight: NSLayoutConstraint!
    @IBOutlet private weak var scienceHeight: NSLayoutConstraint!
    
    // MARK: - Private properties
    private let viewModel = BooksViewModel()
    private let disposeBag = DisposeBag()
    
    private var booksModel  : [Book] = []
    private var romanceBooks: [Book] = []
    private var fantasyBooks: [Book] = []
    private var scienceBooks: [Book] = []
    private var bannerSlides: [Banner] = []
    
    private var currentCellIndex = 0
    
    // MARK: - VC lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        setupUI()
        setupCollectionView()
        setupBackButton()
        setupNavBarAppearance()
    }
    
    // MARK: - Private methods
    private func setupUI() {
        pageControl.numberOfPages = bannerSlides.count
        pageControl.isUserInteractionEnabled = false
        newArrivalsHeight.constant = Defaults.collectionViewSize
        romanceHeight.constant = Defaults.collectionViewSize
        fantasyHeight.constant = Defaults.collectionViewSize
        scienceHeight.constant = Defaults.collectionViewSize
    }
    
    private func setupBackButton() {
        navigationItem.hidesBackButton = true
        
        let backButton = UIBarButtonItem(image: nil,  style: .plain, target: self, action: #selector(didLibraryButton(sender:)))
        backButton.tintColor = UIColor(named: "c_acent_pink")
        backButton.title = "Library"
        
        let font = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font]
        backButton.setTitleTextAttributes(attributes, for: .normal)
        
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func setupNavBarAppearance() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backgroundColor = UIColor.clear
        navigationController?.view.backgroundColor = UIColor.clear
        navigationController?.navigationBar.tintColor = .clear
    }
    
    private func fetchData() {
        viewModel.fetchData().subscribe(onNext: { [weak self] books, banners in
            self?.booksModel = books
            self?.bannerSlides = banners
            self?.organizeBooksIntoGenres(books)
        }, onError: { error in
            print("Error fetching data: \(error)")
        })
        .disposed(by: disposeBag)
    }
    
    private func organizeBooksIntoGenres(_ books: [Book]) {
        romanceBooks = books.filter { $0.genre == "Romance" }
        fantasyBooks = books.filter { $0.genre == "Fantasy" }
        scienceBooks = books.filter { $0.genre == "Science" }
    }
    
    private func setupCollectionView() {
        newArrivalsCollectionView.register(BookCollectionViewCell.nib, forCellWithReuseIdentifier: BookCollectionViewCell.identifier)
        newArrivalsCollectionView.dataSource = self
        newArrivalsCollectionView.delegate = self
        
        romanceCollectionView.register(BookCollectionViewCell.nib, forCellWithReuseIdentifier: BookCollectionViewCell.identifier)
        romanceCollectionView.dataSource = self
        romanceCollectionView.delegate = self
        
        fantasyCollectionView.register(BookCollectionViewCell.nib, forCellWithReuseIdentifier: BookCollectionViewCell.identifier)
        fantasyCollectionView.dataSource = self
        fantasyCollectionView.delegate = self
        
        scienceCollectionView.register(BookCollectionViewCell.nib, forCellWithReuseIdentifier: BookCollectionViewCell.identifier)
        scienceCollectionView.dataSource = self
        scienceCollectionView.delegate = self
        
        bannerCollectionView.register(BannerCollectionViewCell.nib, forCellWithReuseIdentifier: BannerCollectionViewCell.identifier)
        
        bannerCollectionView.reloadData()
        bannerCollectionView.carouselDataSource = self
        bannerCollectionView.isAutoscrollEnabled = true
        bannerCollectionView.autoscrollTimeInterval = 3.0
        bannerCollectionView.flowLayout.itemSize = CGSize(width: Defaults.width, height: 160)
    }
    
    // MARK: - Objc private methods
    @objc private func didLibraryButton(sender: AnyObject) {
        print("OPEN A Library")
    }
}

// MARK: - Extensions
// MARK: - UICollectionViewDelegate & DataSource
extension LibraryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == newArrivalsCollectionView {
            return booksModel.count
        } else if collectionView == romanceCollectionView {
            return romanceBooks.count
        } else if collectionView == fantasyCollectionView {
            return fantasyBooks.count
        } else if collectionView == scienceCollectionView {
            return scienceBooks.count
        }
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let bookCell = newArrivalsCollectionView.dequeueReusableCell(withReuseIdentifier: BookCollectionViewCell.identifier, for: indexPath) as! BookCollectionViewCell
        
        if collectionView == newArrivalsCollectionView {
            let book = booksModel[indexPath.row]
            bookCell.configure(label: book.name, image: book.coverUrl, labelColor: "c_white")
            return bookCell
        } else if collectionView == romanceCollectionView {
            
            let romanceBook = romanceBooks[indexPath.row]
            bookCell.configure(label: romanceBook.name, image: romanceBook.coverUrl, labelColor: "c_white")
            return bookCell
        } else if collectionView == fantasyCollectionView {
            
            let fantasyBook = fantasyBooks[indexPath.row]
            bookCell.configure(label: fantasyBook.name, image: fantasyBook.coverUrl, labelColor: "c_white")
            return bookCell
        } else if collectionView == scienceCollectionView {
            
            let scienceBook = scienceBooks[indexPath.row]
            bookCell.configure(label: scienceBook.name, image: scienceBook.coverUrl, labelColor: "c_white")
            return bookCell
        } else {
            return bookCell
        }
    }
}

// MARK: - CarouselCollectionViewDataSource
extension LibraryViewController: CarouselCollectionViewDataSource {
    var numberOfItems: Int {
        return bannerSlides.count
    }
    
    func carouselCollectionView(_ carouselCollectionView: CarouselCollectionView, cellForItemAt index: Int, fakeIndexPath: IndexPath) -> UICollectionViewCell {
        let cell = bannerCollectionView.dequeueReusableCell(withReuseIdentifier: BannerCollectionViewCell.identifier, for: fakeIndexPath) as! BannerCollectionViewCell
        let bannerImage = bannerSlides[index].cover
        cell.configure(image: bannerImage)
        return cell
    }
    
    func carouselCollectionView(_ carouselCollectionView: CarouselCollectionView, didSelectItemAt index: Int) {
        let storyboard = UIStoryboard.init(name: "Recommended", bundle: nil)
        guard let libraryVC = storyboard.instantiateViewController(identifier: "RecommendedViewController") as? RecommendedViewController else { return }
        let bookId = bannerSlides[index].bookId
        print("Bookid", bookId)
        libraryVC.currentCellIndex = bookId
        self.navigationController?.pushViewController(libraryVC, animated: true)
    }
    
    func carouselCollectionView(_ carouselCollectionView: CarouselCollectionView, didDisplayItemAt index: Int) {
        pageControl.currentPage = index
    }
}
// MARK: - UICollectionViewDelegateFlowLayout
extension LibraryViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = Defaults.width / 3 - 8
        return CGSize(width: cellWidth, height: Defaults.collectionViewSize)
    }
}
