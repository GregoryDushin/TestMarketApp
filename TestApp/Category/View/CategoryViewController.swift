//
//  ViewController.swift
//  TestApp
//
//  Created by Григорий Душин on 29.06.2023.
//

import UIKit
import RxSwift
import RxCocoa

final class CategoryViewController: UIViewController {

    @IBOutlet private var locationLable: UILabel!
    @IBOutlet private var timeLabel: UILabel!
    @IBOutlet private var categoryTableView: UITableView!
    @IBOutlet private var cityLabel: UILabel!
    
    private let categorieLoader = CategoryLoader()
    private let disposeBag = DisposeBag()
    var categories: [CategoryModel] = []
    var viewModel: CategoryViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.errorDriver
            .drive(onNext: { [weak self] errorMessage in
                guard let self = self else { return }
                self.showAlert(errorMessage)
            }
            )
            .disposed(by: disposeBag)

        viewModel.categoryArrayDriver
            .drive(onNext: { [weak self] categoryArray in
                guard let self = self else { return }
                self.categories = categoryArray
                self.categoryTableView.reloadData()
            }
            )
            .disposed(by: disposeBag)

        viewModel.dateDriver
            .drive(onNext: { [weak self] formattedDate in
                guard let self = self else { return }
                self.timeLabel.text = formattedDate
            }
            )
            .disposed(by: disposeBag)
        
        viewModel.cityDriver
            .drive(onNext: { [weak self] city in
                guard let self = self else { return }
                self.cityLabel.text = city
            }
            )
            .disposed(by: disposeBag)

        categoryTableView.rowHeight = 163
    }

    private func showAlert(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        self.present(alert, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MarketSegue" {
            let segue = segue.destination as! MarketViewController
            if let tableViewCell = sender as? UITableViewCell,
               let indexPath = categoryTableView.indexPath(for: tableViewCell) {
                segue.selectedCategory = categories[indexPath.row].name
            }
        } else if segue.identifier == "BasketSegue" {
        }
    }

    @IBSegueAction func transferMarketInfo(_ coder: NSCoder) -> MarketViewController? {
        let viewModel = MarketViewModel()
        return MarketViewController(coder: coder, viewModel: viewModel)
    }
}

extension CategoryViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = categoryTableView.dequeueReusableCell(
            withIdentifier: "CategorieTableViewCell"
        ) as? CategoryTableViewCell else { return UITableViewCell() }
        cell.setup(url:categories[indexPath.row].imageUrl, name: categories[indexPath.row].name)
        return cell
        }
}
extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
