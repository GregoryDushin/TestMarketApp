//
//  CategoriesLoader.swift
//  TestApp
//
//  Created by Григорий Душин on 29.06.2023.
//

import Foundation
import RxCocoa
import RxSwift

final class CategoryLoader {
    private let decoder = JSONDecoder()
    private let session = URLSession.shared

    init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func categoryDataLoad() -> Single<[CategoryModel]> {
        guard let url = URL(string: Url.categoriesUrl) else {
            return .error(NSError(domain: "Invalid URL", code: -1, userInfo: nil))
        }

        let request = URLRequest(url: url)
        return URLSession.shared.rx.response(request: request)
            .map {_, data -> [CategoryModel] in
                do {
                    let json = try self.decoder.decode(WelcomeCategory.self, from: data)
                    return json.сategories
                } catch {
                    throw error
                }
            }

            .asSingle()
    }
}
