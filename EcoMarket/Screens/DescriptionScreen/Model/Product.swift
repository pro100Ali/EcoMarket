//
//  Product.swift
//  EcoMarket
//
//  Created by Али  on 05.08.2023.
//

import Foundation

struct Product: Codable, Hashable {
    let id: Int?
    let title: String?
    let description: String?
    let image: String?
    var quantity: Int?
    var category: Int?
    let price: String?
}
