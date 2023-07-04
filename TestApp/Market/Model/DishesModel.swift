//
//  DishesModel.swift
//  TestApp
//
//  Created by Григорий Душин on 29.06.2023.
//

import Foundation

// MARK: - Welcome
struct WelcomeMarket: Codable {
    let dishes: [MarketModel]
}

// MARK: - Dish
struct MarketModel: Codable {
    let id: Int
    let name: String
    let price, weight: Int
    let description: String
    let imageUrl: String
    let tegs: [String]
}
