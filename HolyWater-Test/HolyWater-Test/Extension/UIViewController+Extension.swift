//
//  UIViewController+Extension.swift
//  HolyWater-Test
//
//  Created by Georgie Muler on 24.02.2024.
//

import Foundation
import UIKit

extension UIViewController {
    
    func backOnSwipe() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
    }

    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .right {
            navigationController?.popViewController(animated: true)
        }
    }
}
