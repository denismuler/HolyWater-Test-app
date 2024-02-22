//
//  LibraryScreenViewController.swift
//  HolyWater-Test
//
//  Created by Georgie Muler on 21.02.2024.
//

import UIKit
import RxSwift
import RxDataSources

class LibraryScreenViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet private weak var newArrivalsCollectionView: UICollectionView!
    @IBOutlet private weak var romanceCollectionView: UICollectionView!
    @IBOutlet private weak var fantasyCollectionView: UICollectionView!
    @IBOutlet private weak var scienceCollectionView: UICollectionView!
    @IBOutlet private weak var bannerCollectionView: UICollectionView!
    @IBOutlet private weak var pageControl: UIPageControl!
    
    // MARK: - Private properties
    private let viewModel = BooksViewModel()
    private let disposeBag = DisposeBag()
    
    private var booksModel  : [Book] = []
    private var romanceBooks: [Book] = []
    private var fantasyBooks: [Book] = []
    private var scienceBooks: [Book] = []
    private var bannerSlides: [Banner] = []
    
    private var sections: [Section] = []
    
    private var timer: Timer?
    private var currentCellIndex = 0

    // MARK: - VC lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        setupCollectionView()
        pageControl.numberOfPages = bannerSlides.count
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
    }
    
    // MARK: - Private methods
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(moveToNextBanner), userInfo: nil, repeats: true)
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
        bannerCollectionView.dataSource = self
        bannerCollectionView.delegate = self
    }
    
    // MARK: - Objc private methods
    @objc private func moveToNextBanner() {
        if currentCellIndex < bannerSlides.count - 1 {
            currentCellIndex += 1
        } else {
            currentCellIndex = 0
        }
        bannerCollectionView.scrollToItem(at: IndexPath(row: currentCellIndex, section: 0), at: .centeredHorizontally, animated: true)
        pageControl.currentPage = currentCellIndex
    }
}

// MARK: - Extensions
// MARK: - UICollectionViewDelegate & DataSource
extension LibraryScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == bannerCollectionView {
            return bannerSlides.count
        } else if collectionView == newArrivalsCollectionView {
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
        let bannerCell = bannerCollectionView.dequeueReusableCell(withReuseIdentifier: BannerCollectionViewCell.identifier, for: indexPath) as! BannerCollectionViewCell

        if collectionView == bannerCollectionView {
            
            let banner = bannerSlides[indexPath.row]
            bannerCell.configure(image: banner.cover)
            return bannerCell
        } else if collectionView == newArrivalsCollectionView {
            
            let book = booksModel[indexPath.row]
            bookCell.configure(label: book.name, image: book.coverUrl)
            return bookCell
        } else if collectionView == romanceCollectionView {
            
            let romanceBook = romanceBooks[indexPath.row]
            bookCell.configure(label: romanceBook.name, image: romanceBook.coverUrl)
            return bookCell
        } else if collectionView == fantasyCollectionView {
            
            let fantasyBook = fantasyBooks[indexPath.row]
            bookCell.configure(label: fantasyBook.name, image: fantasyBook.coverUrl)
            return bookCell
        } else if collectionView == scienceCollectionView {
            
            let scienceBook = scienceBooks[indexPath.row]
            bookCell.configure(label: scienceBook.name, image: scienceBook.coverUrl)
            return bookCell
        } else {
            return bookCell
        }
    }
}
// MARK: - UICollectionViewDelegateFlowLayout
extension LibraryScreenViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == bannerCollectionView {
            let width = UIScreen.main.bounds.width
            let cellWidth = width
            return CGSize(width: cellWidth, height: 160)
        } else {
            let width = UIScreen.main.bounds.width
            let _ = (width / 2 ) - 44
            return CGSize(width: 120, height: 200)
        }
    }
}

extension LibraryScreenViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == bannerCollectionView {
            let currentIndex = Int(scrollView.contentOffset.x / scrollView.bounds.width)
            currentCellIndex = currentIndex
            if currentCellIndex == bannerSlides.count {
                
            } else {
                pageControl.currentPage = currentIndex
            }
        }
    }
}
