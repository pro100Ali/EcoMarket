//
//  BillVC.swift
//  EcoMarket
//
//  Created by Али  on 11.08.2023.
//

import UIKit
import SnapKit

class BillVC: UIViewController {
    
    var orderItems: [Product] = [Product(id: 2, title: "!2", description: "21", image: "21", price: "2")]
    
    lazy private var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionHeadersPinToVisibleBounds = true
        layout.itemSize = CGSize(width: 370, height: 70)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(BillCell.self, forCellWithReuseIdentifier: BillCell.identifier)
        collection.isUserInteractionEnabled = true
        return collection
    }()
    
    let greenView = GreenView(frame: .zero)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(collection)
        view.addSubview(greenView)
        collection.delegate = self
        collection.dataSource = self
        setupConstraints()
        print(orderItems)
        greenView.backgroundColor = Constants.green
        
    }
    
    func setupConstraints() {
        greenView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(226)
        }
        collection.snp.makeConstraints { make in
            make.top.equalTo(greenView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()

        }
    }

    

}

extension BillVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orderItems.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: BillCell.identifier, for: indexPath) as! BillCell
        cell.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
        cell.configure(orderItems[indexPath.row])
                
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
    }
    
}


