//
//  CarouselCollectionViewCell.swift
//  HolyWater-Test
//
//  Created by Georgie Muler on 23.02.2024.
//

import UIKit
import CollectionViewPagingLayout

class CarouselCollectionViewCell: UICollectionViewCell {

    var card: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        // Adjust the card view frame
        // you can use Auto-layout too
        let cardFrame = CGRect(
            x: 80,
            y: 100,
            width: frame.width - 160,
            height: frame.height - 200
        )
        card = UIView(frame: cardFrame)
        card.backgroundColor = .systemOrange
        contentView.addSubview(card)
    }
}

extension CarouselCollectionViewCell: ScaleTransformView {
    var scaleOptions: ScaleTransformViewOptions {
        ScaleTransformViewOptions(
            minScale: 0.6,
            scaleRatio: 0.4,
            translationRatio: CGPoint(x: 0.66, y: 0.2),
            maxTranslationRatio: CGPoint(x: 2, y: 0)
            )
    }
}
