//
//  MarketViewController.swift
//  TestApp
//
//  Created by Григорий Душин on 30.06.2023.
//

import RxSwift
import RxCocoa
import UIKit

final class MarketViewController: UIViewController {
    
    @IBOutlet private var backButton: UIButton!
    @IBOutlet private var categoryLabel: UILabel!
    @IBOutlet private var tagCollectionView: UICollectionView!
    @IBOutlet private var marketCollectionView: UICollectionView!
    
    var viewModel: MarketViewModel
    private let disposeBag = DisposeBag()
    private var dishes: [MarketModel] = []
    private var filteredDishes: [MarketModel] = []
    private var selectedTagIndex: Int = 0
    private var selectedTag: String?
    private var dishTags: [String] = []
    
    var selectedCategory = ""
    
    init?(coder: NSCoder, viewModel: MarketViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryLabel.text = selectedCategory
        
        viewModel.errorDriver
            .drive(onNext: { [weak self] errorMessage in
                guard let self = self else { return }
                self.showAlert(errorMessage)
            })
            .disposed(by: disposeBag)
        
        viewModel.dishArrayDriver
            .drive(onNext: { [weak self] dishes in
                guard let self = self else { return }
                self.dishes = dishes
                self.filteredDishes = dishes
                self.tagCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.tagsArrayDriver
            .drive(onNext: { [weak self] tags in
                guard let self = self else { return }
                self.dishTags = tags
                self.marketCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
        updateUI()
    }
    
    private func updateUI() {
        tagCollectionView.showsHorizontalScrollIndicator = false
    }
    
    private func showAlert(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        present(alert, animated: true)
    }
    
    @IBAction private func backAction(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
}

extension MarketViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == tagCollectionView {
            return dishTags.count
        } else {
            return filteredDishes.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == tagCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCollectionViewCell", for: indexPath) as! TagCollectionViewCell
            cell.tagLabel.text = dishTags[indexPath.item]
            
            if indexPath.item == selectedTagIndex {
                cell.backgroundColor = .systemGray5
            } else {
                cell.backgroundColor = .systemGray6
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MarketCollectionViewCell", for: indexPath) as! MarketCollectionViewCell
            let dish = filteredDishes[indexPath.item]
            cell.setup(url: dish.imageUrl, name: dish.name)
            return cell
        }
    }
}

extension MarketViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == tagCollectionView {
            selectedTagIndex = indexPath.item
            selectedTag = dishTags[indexPath.item]
            if selectedTag == "Все меню" {
                filteredDishes = dishes
            } else {
                filteredDishes = dishes.filter { $0.tegs.contains(selectedTag!) }
            }
            tagCollectionView.reloadData()
            marketCollectionView.reloadData()
        } else if collectionView == marketCollectionView {
            let selectedDish = filteredDishes[indexPath.item]
            showProductViewController(with: selectedDish)
        }
    }
    
    private func showProductViewController(with dish: MarketModel) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let productViewController = storyboard.instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
        productViewController.product = dish
        present(productViewController, animated: true, completion: nil)
    }
}
