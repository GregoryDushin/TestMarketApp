//
//  CategoriesModel.swift
//  TestApp
//
//  Created by Григорий Душин on 29.06.2023.
//

import Foundation

// MARK: - Welcome
struct WelcomeCategory: Decodable {
    let сategories: [CategoryModel]
}

// MARK: - Сategory
struct CategoryModel: Decodable {
    let id: Int
    let name: String
    let imageUrl: String
}
