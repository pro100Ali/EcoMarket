//
//  ViewController.swift
//  EcoMarket
//
//  Created by Али  on 04.08.2023.
//

import UIKit
import SnapKit
import Network

class MainViewController: UIViewController {
        
    var categories: [Category] = []
    let viewModel = ViewModel()
    let monitor = NWPathMonitor()
    let vc = CustomAlert()
    
    
    
    lazy private var headerLabel: UILabel  = {
        let label = UILabel()
        label.text = "Eco - Market"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    lazy private var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 183, height: 202)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.identifier)
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = headerLabel
        
        view.backgroundColor = .systemBackground
        view.addSubview(headerLabel)
        view.addSubview(collection)
        collection.delegate = self
        collection.dataSource = self
        setupConstraints()
        callToViewModelForUIUpdate()
        checkConnection()
        
    }
    
    func checkConnection() {
        NetworkMonitor.shared.isConnected ? nil : vc.showAlert(vc: self) 
    }
    
    func callToViewModelForUIUpdate() {

        self.viewModel.bindViewModelToController = {
            self.updateDataSource()
        }
    }
    
    func updateDataSource(){
        DispatchQueue.main.async { [self] in
            guard let data = viewModel.empData else { return }
            categories = data
            collection.reloadData()
        }
    }
    
    func setupConstraints() {
        collection.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(28)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }
}


extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as? CategoryCell else { return UICollectionViewCell()}
        cell.configure(categories[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ProductsViewController()
//        vc.selectedCategory = indexPath.row + 1
        vc.selectedCategory = categories[indexPath.row].id!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
