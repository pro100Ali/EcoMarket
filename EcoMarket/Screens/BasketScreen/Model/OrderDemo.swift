//
//  File.swift
//  EcoMarket
//
//  Created by Али  on 11.08.2023.
//

import Foundation

struct OrderDemo: Codable {
    
    let order_number: Int?
    let total_amount: String?
    let created_at: String?
    var orderItems: [Product]?
}
