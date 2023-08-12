//
//  HistoryViewController.swift
//  EcoMarket
//
//  Created by Али  on 10.08.2023.
//

import UIKit
import SnapKit

class HistoryViewController: UIViewController {
    
    var orderArray: [OrderDemo] = []
    
//    var sections: [String] = ["Today", "Yesterday"]
//    var sectionedOrders: [String: [Order]] = ["Today": [Order(id: "12345", totalCost: 5000)], "Yesterday": [Order(id: "54321", totalCost: 10000)]]
    
    lazy private var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionHeadersPinToVisibleBounds = true
        layout.itemSize = CGSize(width: 370, height: 70)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(OrderCell.self, forCellWithReuseIdentifier: OrderCell.identifier)
        collection.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
        collection.isUserInteractionEnabled = true
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "История заказов"
        view.backgroundColor = .systemBackground
        view.addSubview(collection)
        collection.dataSource = self
        collection.delegate = self
        setupConstraints()
        
        NotificationCenter.default.addObserver(self, selector: #selector(historyUpdated(_:)), name: .historyUpdated, object: nil)
        
    }
    
  
    
    @objc func historyUpdated(_ notification: Notification) {
        orderArray = BasketManager.shared.getOrderArray()
        DispatchQueue.main.async {
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

extension HistoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orderArray.count
    }
    
    
    //    func numberOfSections(in collectionView: UICollectionView) -> Int {
    //        return sections.count
    //    }
    
    //    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    //        let sectionKey = sections[section]
    //        return sectionedOrders[sectionKey]?.count ?? 0
    //    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: OrderCell.identifier, for: indexPath) as! OrderCell
        cell.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
        
        //        let sectionKey = sections[indexPath.section]
        //        if let order = sectionedOrders[sectionKey]?[indexPath.row] {
        //            cell.configure(order)
        //        }
        cell.configure(orderArray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
    }
    
    //    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    //        switch kind {
    //        case UICollectionView.elementKindSectionHeader:
    //            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath)
    //            header.backgroundColor = .white
    //
    //            // Remove old label if it exists (to prevent labels stacking on top of each other)
    //            for subview in header.subviews where subview is UILabel {
    //                subview.removeFromSuperview()
    //            }
    //
    //            // Create new label
    //            let label = UILabel()
    //            label.text = sections[indexPath.section]
    //            label.textColor = .black
    //            label.font = UIFont.boldSystemFont(ofSize: 16)
    //            header.addSubview(label)
    //
    //            // Apply constraints to label
    //            label.translatesAutoresizingMaskIntoConstraints = false
    //            NSLayoutConstraint.activate([
    //                label.centerYAnchor.constraint(equalTo: header.centerYAnchor),
    //                label.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 16),
    //                label.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -16)
    //            ])
    //
    //            return header
    //        default:
    //            assert(false, "Invalid element type")
    //        }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 30)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = BillVC()
        vc.orderItems = orderArray[indexPath.row].orderItems!
        vc.greenView.configure(dateText: orderArray[indexPath.row].created_at!, costText: orderArray[indexPath.row].total_amount!)
        vc.title = "№\(orderArray[indexPath.row].order_number!)"
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
