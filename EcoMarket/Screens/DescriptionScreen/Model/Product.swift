//
//  Product.swift
//  EcoMarket
//
//  Created by Али  on 05.08.2023.
//

import Foundation

struct Product: Codable {
    let id: Int?
    let title: String?
    let description: String?
    let image: String?
    let quantity: Int?
    let price: String?
}
