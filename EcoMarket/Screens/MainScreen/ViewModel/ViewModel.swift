//
//  SurahViewModel.swift
//  QuranKZUIKIT2
//
//  Created by Али  on 26.06.2023.
//

import Foundation

class ViewModel: NSObject {
    
    private var apiCaller: APICaller!
    
    private(set) var empData : [Category]! {
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
        self.apiCaller.getAllCategories { res in
            switch res {
            case .success(let success):
                self.empData = success
                self.empData.sort { $0.id! < $1.id! }

            case .failure(let failure):
                print("Error", failure)
            }
        }
    }
}
