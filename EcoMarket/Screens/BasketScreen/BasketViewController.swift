//
//  BasketViewController.swift
//  EcoMarket
//
//  Created by Али  on 06.08.2023.
//

import UIKit
import SnapKit

class BasketViewController: UIViewController {
    
    

    var basketProducts: [Product] = []
    
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
        
 
        configureNav()
        
        NotificationCenter.default.addObserver(self, selector: #selector(basketUpdated(_:)), name: .basketUpdated, object: nil)
        
        view.addSubview(collection)
        collection.dataSource = self
        collection.delegate = self

        basketProducts = BasketManager.shared.getBasketProducts()
        
        setupConstraints()
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeTheLabelToAdd(_:)), name: .changeTheLabelToAdd, object: nil)
    }
    
    @objc func changeTheLabelToAdd(_ notification: Notification) {
        basketProducts = BasketManager.shared.getBasketProducts()
        updateDataSource()
    }
    
    func configureNav() {
        title = "Корзина"
        self.navigationItem.leftBarButtonItem?.title = "Очистить"
        navigationItem.titleView?.tintColor = .label
        view.backgroundColor = .systemBackground
        let clearButton = UIBarButtonItem(title: "Очистить", style: .plain, target: self, action: #selector(clearButtonTapped))
        
        navigationItem.leftBarButtonItem = clearButton
        navigationItem.leftBarButtonItem?.tintColor = .red
    }
    
    @objc func basketUpdated(_ notification: Notification) {
        updateDataSource()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .basketUpdated, object: nil)
    }
    
    func callToViewModelForUIUpdate() {
        
        BasketManager.shared.bindViewModelToController = {
            self.basketProducts = BasketManager.shared.getBasketProducts()
            self.updateDataSource()
        }
    }
    
    func updateDataSource(){
        DispatchQueue.main.async { [self] in
            self.basketProducts = BasketManager.shared.getBasketProducts()

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
        
        if let current = self.basketProducts[indexPath.row].id  {
            cell.configureProduct(basketProducts[indexPath.row], indexPath)
        }
        cell.updateCollection = {
            print(self.basketProducts)
            self.updateDataSource()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
    }
    
}

extension Notification.Name {
    static let basketUpdated = Notification.Name("BasketUpdated")
    static let changeTheLabelToAdd = Notification.Name("ChangeTheLabelToAdd")
}
