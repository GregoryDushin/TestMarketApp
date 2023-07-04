//
//  MarketViewModel.swift
//  TestApp
//
//  Created by Григорий Душин on 02.07.2023.
//

import Foundation
import RxCocoa
import RxSwift

final class MarketViewModel {
    
    private let disposeBag = DisposeBag()
    private let dishArray = BehaviorRelay<[MarketModel]>(value: [])
    private let tagsArray = BehaviorRelay<[String]>(value: [])
    private let errorSubject = BehaviorRelay<String>(value: "")
    let dishLoader = DishLoader()

    var errorDriver: Driver<String> {
        errorSubject.asDriver()
    }

    var dishArrayDriver: Driver<[MarketModel]> {
        dishArray.asDriver()
    }
    
    var tagsArrayDriver: Driver<[String]> {
        tagsArray.asDriver()
    }

    required init() {
        getData()
    }

    func getData() {
        
        let dishTags = ["Все меню", "Салаты", "С рисом", "С рыбой"]
        
        dishLoader.dishesDataLoad()
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] dishes in
                    self?.dishArray.accept(dishes)
                    self?.tagsArray.accept(dishTags)
                },
                onFailure: { [weak self] error in
                    let errorMessage = error.localizedDescription
                    self?.errorSubject.accept(errorMessage)
                }
            )
            .disposed(by: disposeBag)
    }
}
