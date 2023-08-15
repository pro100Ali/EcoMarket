//
//  AlamofireCALLER.swift
//  EcoMarket
//
//  Created by Али  on 15.08.2023.
//

import Foundation
import Alamofire

class AlamofireCaller {
    
    static let shared = AlamofireCaller()
    
    func getAllCategories(completion: @escaping (Result<[Category], Error>) -> Void) {
        
        let urlString = "http://142.93.101.70:8000/product-category-list/"
        
        AF.request(urlString).validate().responseDecodable(of: [Category].self) { response in
            
            switch response.result {
            case .success(let categories):
                completion(.success(categories))
            case .failure(let error):
                completion(.failure(error))
            }
            
        }

    }

    func getAllProducts(_ id: Int, completion: @escaping (Result<[Product], Error>) -> Void) {
        
        let urlString = "http://142.93.101.70:8000/product-list/?category=\(id)"
        
        AF.request(urlString).validate().responseDecodable(of: [Product].self) { response in
            
            switch response.result {
            case .success(let categories):
                completion(.success(categories))
            case .failure(let error):
                completion(.failure(error))
            }
            
        }

    }
    
    func searchProduct(char: String, completion: @escaping (Result<[Product], Error>) -> Void) {
        
        let searchTerm = String(char).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

          guard let term = searchTerm, let url = URL(string: "http://142.93.101.70:8000/product-list/?search=\(term)") else {
              completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
              return
          }

        AF.request(url).validate().responseDecodable(of: [Product].self) { response in
            
            switch response.result {
            case .success(let categories):
                completion(.success(categories))
            case .failure(let error):
                completion(.failure(error))
            }
        }

    }
    
    
    func postTheData(basketProduct: [Product], completion: @escaping (Result<OrderDemo, Error>) -> Void) {
        let urlString = "http://142.93.101.70:8000/order-create/"
        

        var products: [ProductDemo] = []

        for item in basketProduct {
            products.append(ProductDemo(product: item.id!, quantity: item.quantity!))
        }
        
        let productsArray = ProductsArray(products: products)
        

        AF.request(urlString, method: .post, parameters: productsArray, encoder: JSONParameterEncoder.default, headers: ["Accept": "application/json", "Content-Type": "application/json"])
            .validate()
            .responseDecodable(of: OrderDemo.self) { response in
                switch response.result {
                case .success(let orderDemo):
                    completion(.success(orderDemo))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        

    }

}
