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
    
    private var orderArray: [OrderDemo] = []
    
    private var historyBasketProducts: [Product] = []
    
    var totalCost: Double = 0
    
    
    var bindViewModelToController: (() -> ()) = {}
    
    private init() {
    }
    
    
    
    func getOrderArray() -> [OrderDemo] {
        return orderArray
    }
    
    func getBasketProducts() -> [Product] {
        return basketProducts
    }
    
    func removeById(_ id: Int) {
        if let productToRemove = basketProducts.first(where: { $0.id == id } ) {
            totalCost -= (Double(productToRemove.price!)! * Double(productToRemove.quantity!))
        }
        self.basketProducts =  basketProducts.filter { $0.id != id }
        
        NotificationCenter.default.post(name: .changeTheLabelToAdd, object: nil)
        
    }
    
    func getById(_ id: Int) -> Product? {
        return basketProducts.first { res in
            res.id == id
        }
    }
    
    func addProductToBasket(_ product: Product) {

        basketProducts.append(product)
        
        totalCost += Double(product.price!)!
        
        NotificationCenter.default.post(name: .basketUpdated, object: nil)
    }
    
    func plusQuantity(for product: Product) {
        if let index = basketProducts.firstIndex(where: { $0.id == product.id! }) {
            basketProducts[index].quantity! += 1
            let productToParse = basketProducts[index]
            totalCost += Double(productToParse.price!)!
            NotificationCenter.default.post(name: .basketUpdated, object: nil)
        }
    }
    
    func minusQuantity(for product: Product) {
        if let index = basketProducts.firstIndex(where: { $0.id == product.id! }) {
            if basketProducts[index].quantity! > 1 {
                basketProducts[index].quantity! -= 1
                totalCost -= Double(product.price!)!
                NotificationCenter.default.post(name: .basketUpdated, object: product)
            }
            else {
                NotificationCenter.default.post(name: .changeTheLabelToAdd, object: basketProducts[index].id)
                totalCost -= Double(product.price!)!
                basketProducts.remove(at: index)
            }
        }
    }
    
    
    func clearBasket() {
        basketProducts.removeAll()
        totalCost = 0
        NotificationCenter.default.post(name: .changeTheLabelToAdd, object: nil)
    }
    
    func updateHistory(_ order: OrderDemo) {
        var orderToAdd = order
        orderToAdd.orderItems = basketProducts
        orderArray.append(orderToAdd)
        NotificationCenter.default.post(name: .historyUpdated, object: nil)
    }
    
    
}

