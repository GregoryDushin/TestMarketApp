//
//  ProductViewController.swift
//  TestApp
//
//  Created by Григорий Душин on 02.07.2023.
//

import AlamofireImage
import UIKit
import Realm
import RealmSwift

final class ProductViewController: UIViewController {
    
    @IBOutlet private var invisibleView: UIView!
    @IBOutlet private var productImage: UIImageView!
    @IBOutlet private var productNameLabel: UILabel!
    @IBOutlet private var productPriceLabel: UILabel!
    @IBOutlet private var productWeightLabel: UILabel!
    @IBOutlet private var productDescriptionLabel: UILabel!
    @IBOutlet private var closeButton: UIButton!
    @IBOutlet private var likeButton: UIButton!
    @IBOutlet private var productView: UIView!
    
    var product: MarketModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureView()
    }
    
    private func configureView() {
        if let product = product {
            if let imageURL = URL(string: product.imageUrl) {
                productImage.af.setImage(withURL: imageURL)
            }
            productNameLabel.text = product.name
            productPriceLabel.text = String(product.price) + " ₽"
            productWeightLabel.text = String(product.weight) + "г"
            productDescriptionLabel.text = product.description
        }
    }
    
    private func setupUI() {
        invisibleView.backgroundColor = .clear
        productImage.backgroundColor = .systemGray6
        productImage.layer.cornerRadius = productImage.frame.height / 20
        closeButton.layer.cornerRadius = closeButton.frame.height / 5
        likeButton.layer.cornerRadius = likeButton.frame.height / 5
        productView.layer.cornerRadius = productView.frame.height / 35
    }
    
    @IBAction func viewDidClosed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func goInBasket(_ sender: Any) {
        
        let realm = try! Realm()
        if let product = product {
            let basketItem = RealmModel(
                name: product.name,
                price: product.price,
                mainImage: product.imageUrl,
                weight: product.weight)
            do {
                try realm.write {
                    realm.add(basketItem)
                }
                showAlert("\(product.name) добавлен в вашу корзину.")
                
            } catch {
                showAlert(error.localizedDescription)
            }
        }
    }
    
    private func showAlert(_ message: String ) {
        let alert = UIAlertController(title: .none, message: message, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        dismiss(animated: true, completion: nil)
    }
}
