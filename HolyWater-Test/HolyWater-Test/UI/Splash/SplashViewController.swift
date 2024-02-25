//
//  ViewController.swift
//  HolyWater-Test
//
//  Created by Georgie Muler on 20.02.2024.
//

import UIKit

class SplashViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var welcomelbl: UILabel!
    @IBOutlet private weak var loadingProgress: UIProgressView!
        
    // MARK: - VC lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadingProgress.progress = 0.0
        
        let timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            timer.invalidate()
            let storyboard = UIStoryboard.init(name: "Library", bundle: nil)
            guard let libraryVC = storyboard.instantiateViewController(identifier: "LibraryViewController") as? LibraryViewController else { return }
            self.navigationController?.pushViewController(libraryVC, animated: true)
        }
    }
    
    // MARK: - Private methods
    private func setupUI() {
        welcomelbl.layer.opacity = 0.8
    }
    
    // MARK: - Objc private methods
    @objc func updateProgress() {
        loadingProgress.progress += 0.1
        
        if loadingProgress.progress >= 1.0 {
            Timer().invalidate()
        }
    }
}
