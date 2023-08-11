//
//  APICaller.swift
//  StrongTeam
//
//  Created by Али  on 17.05.2023.
//

import Foundation


class APICaller {
    
    static let shared = APICaller()

    func getAllCategories(completion: @escaping (Result<[Category], Error>) -> Void) {
        
        let urlString = "http://142.93.101.70:8000/product-category-list/"
        
        let url = URL(string: urlString)
        
        let request = URLRequest(url: url!)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let articles = try decoder.decode([Category].self, from: data)
                    
//                    print(articles)
                    completion(.success(articles))
                    
                } catch let error {
                    print("Error was \(error)")
                    completion(.failure(error))
                }
            }
            
            if let error = error {
                print("ERRRRROOR \(error)")
            }
            
        }
        task.resume()
        
    }
    
    func getAllProducts(_ id: Int, completion: @escaping (Result<[Product], Error>) -> Void) {
        
        let urlString = "http://142.93.101.70:8000/product-list/?category=\(id)"
        
        let url = URL(string: urlString)
        
        let request = URLRequest(url: url!)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let articles = try decoder.decode([Product].self, from: data)
                    
//                    print(articles)
                    completion(.success(articles))
                    
                } catch let error {
                    print("Error was \(error)")
                    completion(.failure(error))
                }
            }
            
            if let error = error {
                print("ERRRRROOR \(error)")
            }
            
        }
        task.resume()
        
    }
    
    func postTheData(basketProduct: [Product], completion: @escaping (Result<OrderDemo, Error>) -> Void) {
        let urlString = "http://142.93.101.70:8000/order-create/"
        
        let url = URL(string: urlString)
        
        var request = URLRequest(url: url!)
        
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var products: [ProductDemo] = []

        for item in basketProduct {
            products.append(ProductDemo(product: item.id!, quantity: item.quantity!))
        }
        
        let productsArray = ProductsArray(products: products)
        
        do {
            request.httpBody = try JSONEncoder().encode(productsArray)
        }
        catch {
            print(error)
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, responce, error in
            
            if let error = error {
                print("Error took place: \(error)")
                return
            }
            guard let data = data else { return }
                
            do {
                let model = try JSONDecoder().decode(OrderDemo.self, from: data)
                print(model.order_number)
                completion(.success(model))
            }
            catch {
                print(error)
                completion(.failure(error))
            }
        }.resume()
        
    }
    
    
}

struct ProductsArray: Codable {
    let products: [ProductDemo]
}

struct ProductDemo: Codable {
    let product: Int
    let quantity: Int
}
