//
//  RealmModel.swift
//  TestApp
//
//  Created by Григорий Душин on 02.07.2023.
//

import Foundation
import RealmSwift
import Realm

class RealmModel: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var price: Int = 0
    @objc dynamic var imageUrl: String = ""
    @objc dynamic var weight: Int = 0
    @objc dynamic var quantity: Int = 1
    
    convenience init(name: String, price: Int, mainImage: String, weight: Int) {
        self.init()
        self.name = name
        self.price = price
        self.imageUrl = mainImage
        self.weight = weight
    }
}

