//
//  CategoryViewModel.swift
//  TestApp
//
//  Created by Григорий Душин on 01.07.2023.
//

import CoreLocation
import Foundation
import RxSwift
import RxCocoa

final class CategoryViewModel: NSObject {

    private let disposeBag = DisposeBag()
    private let categoryArray = BehaviorRelay<[CategoryModel]>(value: [])
    private let errorSubject = BehaviorRelay<String>(value: "")
    private let dateSubject = BehaviorRelay<String>(value: "")
    private let citySubject = BehaviorRelay<String?>(value: nil)
    let categorLoader = CategoryLoader()
    
    var errorDriver: Driver<String> {
        errorSubject.asDriver()
    }

    var categoryArrayDriver: Driver<[CategoryModel]> {
        categoryArray.asDriver()
    }
    
    var dateDriver: Driver<String> {
        dateSubject.asDriver()
    }
    
    var cityDriver: Driver<String?> {
        citySubject.asDriver()
    }
    
    required override init() {
        super.init()
        getData()
        configureDate()
        setupLocationManager()
    }
    
    func getData() {
        categorLoader.categoryDataLoad()
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] category in
                    self?.categoryArray.accept(category)
                },
                onFailure: { [weak self] error in
                    let errorMessage = error.localizedDescription
                    self?.errorSubject.accept(errorMessage)
                }
            )
            .disposed(by: disposeBag)
    }

    private func configureDate(){
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMMM"
            return formatter
        }()
        let currentDate = Date()
        self.dateSubject.accept(dateFormatter.string(from: currentDate))
        
    }
    
    private func setupLocationManager() {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

extension CategoryViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            if let error = error {
                let errorMessage = error.localizedDescription
                self?.errorSubject.accept(errorMessage)
                return
            }

            guard let placemark = placemarks?.first, let city = placemark.locality else {
                return
            }

            DispatchQueue.main.async {
                self?.citySubject.accept(city)
            }
        }
        manager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let errorMessage = error.localizedDescription
        errorSubject.accept(errorMessage)
    }
}
