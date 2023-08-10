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
    var selectedCategory: Int = 0
    
    var basketProduct = [Product]()

    lazy private var textFieldHeightConstraint: NSLayoutConstraint = {
        return textField.heightAnchor.constraint(equalToConstant: 50)
    }()
    
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
    
    var headerView = HeaderView()
    
    lazy private var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 183, height: 260)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.identifier)
        collection.showsVerticalScrollIndicator = false
        return collection
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(collection)
        view.addSubview(textField)
        view.addSubview(headerView)
        collection.delegate = self
        collection.dataSource = self
        setupConstraints()
        title = "Продукты"
        callToViewModelForUIUpdate()
        headerView.delegate = self
        
        
        
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
//            guard let data = viewModel.empData else { return }
            products = viewModel.getProducts(for: selectedCategory)
            headerView.selectedIndex2 = IndexPath(item: selectedCategory, section: 0)
            
            print("Apple index:: \(products[0].title)")
            collection.reloadData()
        }
    }
    
    func setupConstraints() {
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(textFieldHeightConstraint.constant)
        }
        headerView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(16)
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.05)
        }
        collection.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
        }
       

    }
    
    
}


extension ProductsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate, UIScrollViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
//        print(BasketManager.shared.getById(products[indexPath.row].id!).title)

        cell.addButtonTapHandler = { [weak self] in
            guard let current = self?.products[indexPath.row] else {return}
            let productToAdd = Product(id: current.id, title: current.title, description: current.description, image: current.image, quantity: current.quantity, price: current.price)
            
            BasketManager.shared.addProductToBasket(productToAdd)

        }
        
        cell.plusButtonTapHandler = { [weak self] in
            guard let currentID = self?.products[indexPath.row].id else {return}
            

            for (i, index) in self!.basketProduct.enumerated() {
                	
                index.id == currentID ? self!.basketProduct[i].quantity! += 1 : print("Aroso")
                
                BasketManager.shared.updateQuantity(for: currentID, quantity: self!.basketProduct[i].quantity!)
                
                cell.buttonPlus.updateLabel(self!.basketProduct[i].quantity!)
            }


            print(self!.basketProduct)
        }
        
        cell.minusButtonTapHandler = { [weak self] in
            
            guard let currentID = self?.products[indexPath.row].id else {return}
            
            var currentProduct = BasketManager.shared.getById(currentID)
            
            if currentProduct.quantity! <= 1 {
                    print("already zero")
                    BasketManager.shared.removeById(currentID)
                    cell.showAddButton()
                }
                else {
                    currentProduct.id == currentID ? currentProduct.quantity! -= 1 : print("Aroso")
                    cell.buttonPlus.updateLabel(currentProduct.quantity!)
                    BasketManager.shared.updateQuantity(for: currentID, quantity: currentProduct.quantity!)
                }
        }
     
        return cell
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 25, left: 0, bottom: 0, right: 0)
    }
    
}


extension ProductsViewController: ShowTheProducts {
    func changeSelected(_ id: Int) {
        self.selectedCategory = id
        updateDataSource()
    }
    
    
}
