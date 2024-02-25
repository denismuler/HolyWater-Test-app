//
//  BookCollectionViewCell.swift
//  HolyWater-Test
//
//  Created by Georgie Muler on 21.02.2024.
//

import UIKit
import SDWebImage

class BookCollectionViewCell: UICollectionViewCell {

    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet private weak var cellImage: UIImageView!
    @IBOutlet private weak var cellLabel: UILabel!
    @IBOutlet private weak var imageHeight: NSLayoutConstraint!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        imageHeight.constant = (Constants.width / 3 - 8) / 0.8
    }
    
    func configure(label: String, image: String, labelColor: String) {
        cellLabel.textColor = UIColor(named: labelColor)
        cellLabel.text = label
        if labelColor != Constants.colorlblsummary {
            cellLabel.layer.opacity = 0.7
        }
        guard let imageURL = URL(string: image) else { return }
        cellImage.sd_setImage(with: imageURL, placeholderImage: UIImage(named: Constants.placeholderImage))
        cellImage.layer.cornerRadius = 16
    }

}
