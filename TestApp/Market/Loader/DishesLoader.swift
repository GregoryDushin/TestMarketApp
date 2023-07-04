//
//  Loader.swift
//  TestApp
//
//  Created by Григорий Душин on 29.06.2023.
//
import Foundation
import RxCocoa
import RxSwift

final class DishLoader {
    private let decoder = JSONDecoder()
    private let session = URLSession.shared

    init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    func dishesDataLoad() -> Single<[MarketModel]> {
        guard let url = URL(string: Url.dishUrl) else {
            return .error(NSError(domain: "Invalid URL", code: -1, userInfo: nil))
        }

        let request = URLRequest(url: url)
        return URLSession.shared.rx.response(request: request)
            .map {_, data -> [MarketModel] in
                do {
                    let json = try self.decoder.decode(WelcomeMarket.self, from: data)
                    return json.dishes
                } catch {
                    throw error
                }
            }

            .asSingle()
    }
}
