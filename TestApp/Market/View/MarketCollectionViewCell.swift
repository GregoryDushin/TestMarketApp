//
//  MarketCollectionViewCell.swift
//  TestApp
//
//  Created by Григорий Душин on 30.06.2023.
//

import UIKit

final class MarketCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private var marketImage: UIImageView!
    @IBOutlet private var marketLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setup(url: String, name: String) {
        if let imageURL = URL(string: url) {
            marketImage.af.setImage(withURL: imageURL)
        }
        marketLabel.text = name
    }
    private func setupUI() {
        marketImage.backgroundColor = .systemGray6
        marketImage.layer.cornerRadius = marketImage.frame.height / 10
        layer.masksToBounds = true
    }
}

