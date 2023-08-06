//
//  BasketViewController.swift
//  EcoMarket
//
//  Created by Али  on 06.08.2023.
//

import UIKit
import SnapKit

class BasketViewController: UIViewController {
   
    

    var basketProducts: [Product] = [Product(id: 1, title: "as", description: "sa", image: "as", price: "12"), Product(id: 2, title: "as", description: "sa", image: "as", price: "12")]
    
    lazy private var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 377, height: 94)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(BasketCell.self, forCellWithReuseIdentifier: BasketCell.identifier)
        collection.isUserInteractionEnabled = true
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Корзина"
        self.navigationItem.leftBarButtonItem?.title = "Очистить"
        navigationItem.titleView?.tintColor = .label
        view.backgroundColor = .systemBackground
        view.addSubview(collection)
        collection.dataSource = self
        collection.delegate = self
        setupConstraints()
        
        let clearButton = UIBarButtonItem(title: "Очистить", style: .plain, target: self, action: #selector(clearButtonTapped))
        navigationItem.leftBarButtonItem = clearButton
        navigationItem.leftBarButtonItem?.tintColor = .red

    }
    
    
    @objc func clearButtonTapped() {
        print("clear")
    }
    

    func setupConstraints() {
        collection.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }

}

extension BasketViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return basketProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: BasketCell.identifier, for: indexPath) as! BasketCell
        cell.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
    }
    
}
