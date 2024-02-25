//
//  BannerCollectionViewCell.swift
//  HolyWater-Test
//
//  Created by Georgie Muler on 22.02.2024.
//

import UIKit

class BannerCollectionViewCell: UICollectionViewCell {

    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet private weak var cellImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(image: String) {
        guard let imageURL = URL(string: image) else { return }
        cellImage.sd_setImage(with: imageURL, placeholderImage: UIImage(named: Constants.placeholderImage))
        cellImage.layer.cornerRadius = 16
    }
}
