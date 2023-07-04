//
//  BasketViewController.swift
//  TestApp
//
//  Created by Григорий Душин on 02.07.2023.
//

import UIKit
import RealmSwift
import Realm
import CoreLocation

final class BasketViewController: UIViewController {
    
    @IBOutlet private var basketTableView: UITableView!
    @IBOutlet private var basketButton: UIButton!
    @IBOutlet private var locationLabel: UILabel!
    @IBOutlet private var timeLabel: UILabel!
    
    var basketItems: Results<RealmModel>!
    var notificationToken: NotificationToken?
    var realm: Realm!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            realm = try Realm()
        } catch {
            print("Failed to instantiate Realm: \(error)")
        }
        
        basketItems = realm.objects(RealmModel.self)
        basketTableView.reloadData()
        observeRealmChanges()
        updateUI()
        updateTotalPrice()
        timeLabel.text = configureDate()
        setupLocationManager()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        notificationToken?.invalidate()
    }
    
    @IBAction func homeButton(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func basketAction(_ sender: Any) {
        showAlert("Sorry, not now =(")
    }
    
    private func updateUI() {
        basketTableView.rowHeight = 100
    }
    
    private func observeRealmChanges() {
        notificationToken = basketItems.observe { [weak self] changes in
            guard let self = self else { return }
            
            switch changes {
            case .initial:
                self.basketTableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                self.basketTableView.beginUpdates()
                self.basketTableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                self.basketTableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                self.basketTableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                self.basketTableView.endUpdates()
            case .error(let error):
                print("Realm error: \(error)")
            }
            
            self.updateTotalPrice()
        }
    }
    
    private func updateTotalPrice() {
        let totalPrice = basketItems.reduce(0) { (result, basketItem) in
            let quantity = basketItem.quantity
            let price = basketItem.price
            return result + (price * quantity)
        }
        
        basketButton.setTitle("Оплатить: \(totalPrice) ₽", for: .normal)
    }
    
    private func showAlert(_ message: String ) {
        let alert = UIAlertController(title: .none, message: message, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        dismiss(animated: true, completion: nil)
    }
    
    private func configureDate() -> String{
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMMM"
            return formatter
        }()
        let currentDate = Date()
        return dateFormatter.string(from: currentDate)
    }
    
    private func setupLocationManager() {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

extension BasketViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return basketItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasketTableViewCell", for: indexPath) as! BasketTableViewCell
        
        let basketItem = basketItems[indexPath.row]
        cell.delegate = self
        cell.setup(basketItem: basketItem)
        
        return cell
    }
}

extension BasketViewController: BasketTableViewCellDelegate {
    func customStepperValueChanged(_ cell: BasketTableViewCell, newValue: Int) {
        guard let indexPath = basketTableView.indexPath(for: cell) else { return }
        let basketItem = basketItems[indexPath.row]
        
        do {
            let realm = try Realm()
            try realm.write {
                basketItem.quantity = newValue
            }
        } catch {
            print("Failed to update quantity: \(error)")
        }
        
        updateTotalPrice()
        
        if newValue == 0 {
            do {
                let realm = try Realm()
                try realm.write {
                    realm.delete(basketItem)
                }
            } catch {
                print("Failed to delete basket item: \(error)")
            }
        }
    }
}
extension BasketViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            if let error = error {
                let errorMessage = error.localizedDescription
                self?.showAlert(errorMessage)
                return
            }
            
            guard let placemark = placemarks?.first, let city = placemark.locality else {
                return
            }
            
            DispatchQueue.main.async {
                self?.locationLabel.text = city
            }
        }
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let errorMessage = error.localizedDescription
        showAlert(errorMessage)
    }
}
