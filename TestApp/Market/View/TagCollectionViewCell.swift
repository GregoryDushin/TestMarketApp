//
//  TagCollectionViewCell.swift
//  TestApp
//
//  Created by Григорий Душин on 30.06.2023.
//

import UIKit

final class TagCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var tagLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        layer.cornerRadius = frame.height / 5
        layer.masksToBounds = true
    }
}
