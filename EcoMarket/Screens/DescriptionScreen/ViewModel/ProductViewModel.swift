//
//  SurahViewModel.swift
//  QuranKZUIKIT2
//
//  Created by Али  on 26.06.2023.
//

import Foundation

class ProductViewModel: NSObject {
    
    var products: [Product] = []

//    private var apiCaller: APICaller!

    private var alamofireCaller: AlamofireCaller!

    private(set) var empData : [Product]! {
           didSet {
               self.bindViewModelToController()
           }
       }
    
    var bindViewModelToController: (() -> ()) = {}
    
    override init() {
        super.init()
//        self.apiCaller = APICaller()
        self.alamofireCaller = AlamofireCaller()
        callFuncToGetEmpData()

    }
    
    func getProducts(for categoryID: Int) -> [Product] {
        if categoryID == 0 {
            return empData
        }
        else {
            return empData.filter { $0.category == categoryID }
        }
    }
    
    func callFuncToGetEmpData() {
        self.alamofireCaller.getAllProducts(1) { res in
            switch res {
            case .success(let success):
                self.empData = success

            case .failure(let failure):
                print("Error", failure)
            }
        }
    }
    
    func searchProduct(textField: String, selectedCategory: Int) {
        
        self.alamofireCaller.searchProduct(char: textField) { res in
            switch res {
            case .success(let success):
                
           
                    var array: [Product] = []
                    for i in 0 ..< success.count {
                        if success[i].category == selectedCategory || selectedCategory == 0 {
                            array.append(success[i])
                            print(array)
                        }
                    }
                    self.products = array

                
            case .failure(let failure):
                print(failure)
            }
        }
    }
}

