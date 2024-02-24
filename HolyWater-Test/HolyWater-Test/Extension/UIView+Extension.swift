//
//  UIView+Extension.swift
//  HolyWater-Test
//
//  Created by Georgie Muler on 23.02.2024.
//

import Foundation
import UIKit

extension UIView {
  
  enum RoundAlign {
    case upper
    case down
  }
  
  func roundCorner() {
    let radius = min(bounds.height, bounds.width) / 2
    layer.cornerRadius = radius
    layer.masksToBounds = true
    clipsToBounds = true
  }
  
  func roundCorner(with radius: CGFloat, align: RoundAlign) {
    layer.cornerRadius = radius
    layer.masksToBounds = true
    switch align {
    case .upper:
      layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    case .down:
      layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    clipsToBounds = true
  }
}
