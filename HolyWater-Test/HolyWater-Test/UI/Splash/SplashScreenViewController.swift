//
//  ViewController.swift
//  HolyWater-Test
//
//  Created by Georgie Muler on 20.02.2024.
//

import UIKit
import RxSwift
import FirebaseRemoteConfig


class SplashScreenViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var welcomelbl: UILabel!
    @IBOutlet private weak var loadingProgress: UIProgressView!
    
    // MARK: - Properties
    
    // MARK: - VC lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadingProgress.progress = 0.0
        
        let timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            timer.invalidate()
            let storyboard = UIStoryboard.init(name: "Library", bundle: nil)
            guard let libraryVC = storyboard.instantiateViewController(identifier: "LibraryScreenViewController") as? LibraryScreenViewController else { return }
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


class FirebaseRemoteConfigManager {
    static let shared = FirebaseRemoteConfigManager()
    
    private init() {
        setupRemoteConfigDefaults()
    }
    
    private func setupRemoteConfigDefaults() {
        let defaults: [String: NSObject] = [
            "welcome_message": "Welcome to our app!" as NSObject,
        ]
        
        RemoteConfig.remoteConfig().setDefaults(defaults)
    }
    
    func fetchRemoteConfig(completion: @escaping (Error?) -> Void) {
        RemoteConfig.remoteConfig().fetch { status, error in
            if status == .success {
                RemoteConfig.remoteConfig().activate(completion: nil)
                completion(nil)
            } else {
                completion(error)
            }
        }
    }
    
    func getConfigValue(forKey key: String) -> String {
        return RemoteConfig.remoteConfig()[key].stringValue ?? ""
    }
}

