//
//  CategorieTableViewCell.swift
//  TestApp
//
//  Created by Григорий Душин on 29.06.2023.
//

import AlamofireImage
import UIKit

final class CategoryTableViewCell: UITableViewCell {

    @IBOutlet private var categoryImage: UIImageView!
    @IBOutlet private var categoryLabel: UILabel!
    
    func setup(url: String, name: String) {
        if let imageURL = URL(string: url) {
            categoryImage.af.setImage(withURL: imageURL)
        }
        categoryLabel.text = name
    }
}
