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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(label: String, image: String) {
        cellLabel.text = label
        cellLabel.layer.opacity = 0.7
        guard let imageURL = URL(string: image) else { return }
        cellImage.sd_setImage(with: imageURL)
        cellImage.layer.cornerRadius = 16
    }

}
