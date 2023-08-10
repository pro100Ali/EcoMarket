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
        
        
        let clearButton = UIBarButtonItem(title: "Очистить", style: .plain, target: self, action: #selector(clearButtonTapped))
        
        navigationItem.leftBarButtonItem = clearButton
        navigationItem.leftBarButtonItem?.tintColor = .red
        NotificationCenter.default.addObserver(self, selector: #selector(basketUpdated(_:)), name: .basketUpdated, object: nil)
        view.addSubview(collection)
        collection.dataSource = self
        collection.delegate = self
        setupConstraints()

        
        basketProducts = BasketManager.shared.getBasketProducts()
        
        print("hello from basket hiii \(BasketManager.shared.getBasketProducts())")
        
    }
    
    @objc func basketUpdated(_ notification: Notification) {
        DispatchQueue.main.async {
            self.basketProducts = BasketManager.shared.getBasketProducts()
            self.collection.reloadData()
        }
    
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .basketUpdated, object: nil)
    }
    
    func callToViewModelForUIUpdate() {
        
        BasketManager.shared.bindViewModelToController = {
            self.updateDataSource()
        }
    }
    
    func updateDataSource(){
        DispatchQueue.main.async { [self] in
            self.collection.reloadData()
        }
    }
    
    @objc func clearButtonTapped() {
        BasketManager.shared.clearBasket()
        print(BasketManager.shared.clearBasket())
        basketProducts.removeAll()
        print(basketProducts)
        DispatchQueue.main.async { [self] in
            self.collection.reloadData()
        }
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
        cell.configure(basketProducts[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
    }
    
}

extension Notification.Name {
    static let basketUpdated = Notification.Name("BasketUpdated")
}
