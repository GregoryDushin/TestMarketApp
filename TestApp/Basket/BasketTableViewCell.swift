//
//  BasketTableViewCell.swift
//  TestApp
//
//  Created by Григорий Душин on 02.07.2023.
//

import UIKit
import Realm
import RealmSwift

protocol BasketTableViewCellDelegate: AnyObject {
    func customStepperValueChanged(_ cell: BasketTableViewCell, newValue: Int)
}

final class BasketTableViewCell: UITableViewCell {
    @IBOutlet private var basketImage: UIImageView!
    @IBOutlet private var baskеtNameLabel: UILabel!
    @IBOutlet private var basketPriceLabel: UILabel!
    @IBOutlet private var basketWeightLabel: UILabel!
    @IBOutlet private var customStepper: CustomStepper!
    
    
    weak var delegate: BasketTableViewCellDelegate?
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        customStepper.layer.cornerRadius = customStepper.frame.height / 7
        customStepper.tintColor = .black
        customStepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
    }
    
    func setup(basketItem: RealmModel) {
        if let imageURL = URL(string: basketItem.imageUrl) {
            basketImage.af.setImage(withURL: imageURL)
        }
        baskеtNameLabel.text = basketItem.name
        basketPriceLabel.text = "\(basketItem.price) ₽"
        basketWeightLabel.text = "\(basketItem.weight) г"
        customStepper.value = basketItem.quantity
    }
    
    @objc private func stepperValueChanged(_ stepper: CustomStepper) {
        let newValue = Int(stepper.value)
        delegate?.customStepperValueChanged(self, newValue: newValue)
    }
}
