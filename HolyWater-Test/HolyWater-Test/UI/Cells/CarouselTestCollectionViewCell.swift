//
//  CarouselTestCollectionViewCell.swift
//  HolyWater-Test
//
//  Created by Georgie Muler on 23.02.2024.
//

import UIKit
import CollectionViewPagingLayout
import SDWebImage

class CarouselTestCollectionViewCell: UICollectionViewCell {

    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    
    @IBOutlet private weak var cellImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellImage.layer.cornerRadius = 16
    }
    
    func configure(image: String, book: String, author: String) {
        guard let imageUrl = URL(string: image) else { return }
        cellImage.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "im_placeholder"))
    }
}

extension CarouselTestCollectionViewCell: ScaleTransformView {
    var scaleOptions: ScaleTransformViewOptions {
        ScaleTransformViewOptions(
            minScale: 0.8,
            scaleRatio: 1.0,
            translationRatio: CGPoint(x: 0.90, y: 0.2),
            maxTranslationRatio: CGPoint(x: 2, y: 0),
            shadowEnabled: true
            )
    }
    
}
