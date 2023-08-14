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
    var searching = false
    var selectedCategory: Int = 0
    
    var basketProduct = [Product]()

    let loadingIndicator = LoadingIndicator(frame:.zero)


    
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
    
    let bg = BagView(frame: .zero)
    
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(basketUpdated(_:)), name: .basketUpdated, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(basketUpdated(_:)), name: .changeTheLabelToAdd, object: nil)
     
        view.addSubview(bg)
        bg.isHidden = true
        
   
    }
    
 
    deinit {
        NotificationCenter.default.removeObserver(self, name: .changeTheLabelToAdd, object: nil)
        NotificationCenter.default.removeObserver(self, name: .basketUpdated, object: nil)
    }
    
    func addSubviewToCenter(_ subView: UIView){
        view.addSubview(subView)
        
        let loadingIndicatorSize: CGFloat = 50.0
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height

        let centerX = (screenWidth - loadingIndicatorSize) / 2
        let centerY = (screenHeight - loadingIndicatorSize) / 2

        subView.frame = CGRect(x: centerX, y: centerY, width: loadingIndicatorSize, height: loadingIndicatorSize)
    }
    
    @objc func searchRecord() {
        searching = true
        collection.isHidden = true
        let searchData: Int = textField.text!.count
    
        self.bg.isHidden = true
        
            if searchData == 0 {
                searching = false
                updateDataSource()
                self.bg.isHidden = true
                
                    DispatchQueue.main.async {
                        self.collection.isHidden = false

                    }
            }
            else {
                self.collection.isHidden = true
                self.addSubviewToCenter(bg)
                addSubviewToCenter(loadingIndicator)
                loadingIndicator.startAnimating()
                viewModel.searchProduct(textField: textField.text!, selectedCategory: selectedCategory)
                updateDataSource()
                bg.configure("bagSmile", text: "Ничего не нашли")

                DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                        DispatchQueue.main.async {
                            
                            self.loadingIndicator.stopAnimating()
                            self.loadingIndicator.removeFromSuperview()
                            self.collection.reloadData()
                            
                            if self.viewModel.products.count != 0 {
                                self.collection.isHidden = false
                                self.bg.isHidden = true
                            }
                            else {
                                self.bg.isHidden = false
                            }

                        }
                    }
            }
         
       
//        if searchData != 0 {
//            searching = true
//            for product in products {
//                if let productToSearch = textField.text {
//                    let range = product.title!.lowercased().range(of: productToSearch, options: .caseInsensitive, range: nil, locale: nil)
//                    if range != nil {
//                        self.filteredProducts.append(product)
//                    }
//                }
//            }
//        }
//        else {
//            filteredProducts = products
//            searching = false
//        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
        }
      
            
    }
    
    @objc func basketUpdated(_ notification: Notification) {
        updateDataSource()
    }
    
    
    func callToViewModelForUIUpdate() {
        
        self.viewModel.bindViewModelToController = {
            self.updateDataSource()
        }
    }
    
    func updateDataSource(){
        DispatchQueue.main.async { [self] in
            if !searching {
                viewModel.products = viewModel.getProducts(for: selectedCategory)
            }
            print("selected category is \(selectedCategory)")
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
        
        return viewModel.products.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as? ProductCell else { return UICollectionViewCell()}
        
   
        if viewModel.products.count > indexPath.row {
            cell.configureProduct(product: viewModel.products[indexPath.row] ,indexPath: indexPath)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = SelectionViewController()
        vc.product = viewModel.products[indexPath.row]
        vc.configure(vc.product!)

        vc.modalPresentationStyle = .overFullScreen // Adjust the presentation style as needed
        present(vc, animated: true, completion: nil)
    }
}


extension ProductsViewController: ShowTheProducts {
    func changeSelected(_ id: Int) {
        self.selectedCategory = id
        
        DispatchQueue.main.async {
            self.searchRecord()
            self.updateDataSource()
        }
       
    }
    
}
