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
    
    private let width = UIScreen.main.bounds.width
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageHeight.constant = (width / 3 - 8) / 0.8
    }
    
    func configure(label: String, image: String, labelColor: String) {
        cellLabel.textColor = UIColor(named: labelColor)
        cellLabel.text = label
        cellLabel.layer.opacity = 0.7
        guard let imageURL = URL(string: image) else { return }
        cellImage.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "im_placeholder"))
        cellImage.layer.cornerRadius = 16
    }

}
