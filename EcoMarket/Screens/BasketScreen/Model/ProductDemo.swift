//
//  ProductDem.swift
//  EcoMarket
//
//  Created by Али  on 15.08.2023.
//

import Foundation

struct ProductsArray: Codable {
    let products: [ProductDemo]
}

struct ProductDemo: Codable {
    let product: Int
    let quantity: Int
}
