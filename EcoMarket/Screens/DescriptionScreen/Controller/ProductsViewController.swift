//
//  ProductsViewController.swift
//  EcoMarket
//
//  Created by Али  on 05.08.2023.
//

import UIKit
import SnapKit

class ProductsViewController: UIViewController {
    
    let searchController = UISearchController()
    let viewModel = ProductViewModel()
    var products: [Product] = []
    var filteredProducts = [Product]()
    var searching = false
    
    lazy private var textField: UITextField = {
        let field = UITextField()
        field.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
        field.layer.cornerRadius = 16
        field.addTarget(self, action: #selector(searchRecord), for: .editingChanged)
        field.layer.sublayerTransform = CATransform3DMakeTranslation(13, 0, 0)
        field.attributedPlaceholder =
        NSAttributedString(string: "Быстрый поиск", attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 0.82, green: 0.82, blue: 0.84, alpha: 1)])
        
        let iconImageView = UIImageView(image: UIImage(named: "search"))
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = UIColor(red: 0.82, green: 0.82, blue: 0.84, alpha: 1)
        iconImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        field.leftView = iconImageView
        field.leftViewMode = .always
        
        return field
    }()
    
    lazy private var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 183, height: 260)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.identifier)
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(collection)
        view.addSubview(textField)
        collection.delegate = self
        collection.dataSource = self
        setupConstraints()
        title = "Продукты"
        callToViewModelForUIUpdate()
        
    }
    
    @objc func searchRecord() {
        self.filteredProducts.removeAll()
        let searchData: Int = textField.text!.count
        if searchData != 0 {
            searching = true
            for product in products {
                if let productToSearch = textField.text {
                    let range = product.title!.lowercased().range(of: productToSearch, options: .caseInsensitive, range: nil, locale: nil)
                    if range != nil {
                        self.filteredProducts.append(product)
                    }
                }
            }
        }
        else {
            filteredProducts = products
            searching = false
        }
        collection.reloadData()
    }
    
    
    func callToViewModelForUIUpdate() {
        
        self.viewModel.bindViewModelToController = {
            self.updateDataSource()
        }
    }
    
    func updateDataSource(){
        DispatchQueue.main.async { [self] in
            guard let data = viewModel.empData else { return }
            products = data
            collection.reloadData()
        }
    }
    
    func setupConstraints() {
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
        collection.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
            make.top.equalTo(textField.snp.bottom).offset(20)
        }
    }
    
}


extension ProductsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searching {
            return filteredProducts.count
        }
        else {
            return products.count
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as? ProductCell else { return UICollectionViewCell()}
        
        if searching {
            
            cell.configure(filteredProducts[indexPath.row])
        }
        else {
            cell.configure(products[indexPath.row])
            
        }
        return cell
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}

