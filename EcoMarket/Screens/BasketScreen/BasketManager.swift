//
//  BasketViewModel.swift
//  EcoMarket
//
//  Created by Али  on 07.08.2023.
//

import Foundation

class BasketManager {
    
    static let shared = BasketManager()
    
    private var basketProducts: [Product] = []
    
//    private(set) var basketProducts: [Product]! {
//           didSet {
//               self.bindViewModelToController()
//           }
//       }
    
    var bindViewModelToController: (() -> ()) = {}

    private init() {
        // Initialize any other settings or data related to the basket
    }
    
   
    
    func getBasketProducts() -> [Product] {
        return basketProducts
    }

    func removeById(_ id: Int) {
        
        self.basketProducts =  basketProducts.filter { $0.id != id }
        NotificationCenter.default.post(name: .basketUpdated, object: nil)

    }
    
    func getById(_ id: Int) -> Product {
        return basketProducts.first { res in
            res.id == id
        }!
    }
    
    func addProductToBasket(_ product: Product) {
          // Add the product to the basketProducts array
          basketProducts.append(product)
          
          // Post a notification that the basket has been updated
          NotificationCenter.default.post(name: .basketUpdated, object: nil)
      }
    
    func updateQuantity(for productID: Int, quantity: Int) {
        // Find the product in the basket by its ID and update the quantity
        if let index = basketProducts.firstIndex(where: { $0.id == productID }) {
            basketProducts[index].quantity = quantity
            NotificationCenter.default.post(name: .basketUpdated, object: nil)

        }
    }
    
    func clearBasket() {
        basketProducts.removeAll()
    }
}

