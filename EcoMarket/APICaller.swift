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
    
    func getAllProducts(completion: @escaping (Result<[Product], Error>) -> Void) {
        
        let urlString = "http://142.93.101.70:8000/product-list/"
        
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
}
