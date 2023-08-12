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
    
    lazy private var button: UIButton = {
       let button = UIButton()
        button.setTitle("Оформить", for: .normal)
        button.backgroundColor = Constants.green
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    let vc = CustomAlert()
    
    let infoSum = InfoLines(frame: .zero, text: "Сумма", total: 0)
    let infoDelivery = InfoLines(frame: .zero, text: "Доставка", total: 150)
    let infoInTotal = InfoLines(frame: .zero, text: "Итого", total: 150)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
 
        configureNav()
        
        NotificationCenter.default.addObserver(self, selector: #selector(basketUpdated(_:)), name: .basketUpdated, object: nil)
        
        view.addSubview(collection)
        view.addSubview(button)
        view.addSubview(infoSum)
        view.addSubview(infoDelivery)
        view.addSubview(infoInTotal)
        collection.dataSource = self
        collection.delegate = self

        basketProducts = BasketManager.shared.getBasketProducts()
        
        setupConstraints()
        NotificationCenter.default.addObserver(self, selector: #selector(changeTheLabelToAdd(_:)), name: .changeTheLabelToAdd, object: nil)
        
        
    }
    
   
    
    @objc func buttonAction() {
        if BasketManager.shared.totalCost < 300 {
            vc.showAlert(vc: self, text: "Заказ может быть при покупке свыше 300 с", imageText: "bagO", descText: nil, myFunc: nil)
        }
        else {
            let vc = ConfirmationVC()
            vc.totalCost.text = "Cумма заказа \(BasketManager.shared.totalCost)"
            navigationController?.pushViewController(vc, animated: true)
        }
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
        print("total cost: \(BasketManager.shared.totalCost)")

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
            infoSum.updateText(BasketManager.shared.totalCost)
            infoInTotal.updateText(BasketManager.shared.totalCost + 150)
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
        
        infoSum.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(150)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(19)
        }
        
        infoDelivery.snp.makeConstraints { make in
            make.top.equalTo(infoSum.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(19)
        }
        
        infoInTotal.snp.makeConstraints { make in
            make.top.equalTo(infoDelivery.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(19)
        }
        
        button.snp.makeConstraints { make in
            make.top.equalTo(infoInTotal.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(54)
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


