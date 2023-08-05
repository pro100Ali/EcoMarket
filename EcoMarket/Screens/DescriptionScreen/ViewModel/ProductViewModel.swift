//
//  SurahViewModel.swift
//  QuranKZUIKIT2
//
//  Created by Али  on 26.06.2023.
//

import Foundation

class ProductViewModel: NSObject {
    
    private var apiCaller: APICaller!
    
    private(set) var empData : [Product]! {
           didSet {
               self.bindViewModelToController()
           }
       }
    
    var bindViewModelToController: (() -> ()) = {}
    
    override init() {
        super.init()
        self.apiCaller = APICaller()
        callFuncToGetEmpData()

    }
    
    func callFuncToGetEmpData() {
        self.apiCaller.getAllProducts { res in
            switch res {
            case .success(let success):
                self.empData = success

            case .failure(let failure):
                print("Error", failure)
            }
        }
    }
}

