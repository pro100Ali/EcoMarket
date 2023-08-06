//
//  HeaderView.swift
//  EcoMarket
//
//  Created by Али  on 06.08.2023.
//

import UIKit
import SnapKit

class HeaderView: UIView {
    
    var categories: [Category] = []

    var selectedIndex: IndexPath?

    var viewModel: ViewModel!
    let itemsArray = ["Item 1", "Long Text for Item 2", "Another Item"]

    lazy private var mainView: UIView = {
       let view = UIView()
        return view
    }()
    
    lazy private var collection: UICollectionView  = {
       let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 35)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(SegmentCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
//        let width = UIScreen.main.bounds.width / 4
//               let height = UIScreen.main.bounds.height / 10
//               layout.itemSize = CGSize(width: width, height: height)
//
//               //For Adjusting the cells spacing
//               layout.minimumInteritemSpacing = 5
//               layout.minimumLineSpacing = 5
//
//        collectionView.showsHorizontalScrollIndicator = false
//        collectionView.allowsMultipleSelection = false

        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        callToViewModelForUIUpdate()
        collection.delegate = self
        collection.dataSource = self
        addSubview(collection)
        setupConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func callToViewModelForUIUpdate() {
        
        viewModel = ViewModel()
        self.viewModel.bindViewModelToController = {
        self.updateDataSource()
        }
        
    }
    
    func updateDataSource(){
           DispatchQueue.main.async {
               self.categories = [Category(id: 1, name: "All", image: "assa")] + self.viewModel.empData // Update the categories array
               self.collection.reloadData()
           }
       }
    
    func setupConstraints() {
    
        collection.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalToSuperview()
        }
    }
}


extension HeaderView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? SegmentCollectionViewCell else { return UICollectionViewCell() }
        
   
        cell.label.text = categories[indexPath.row].name
             
         
        
        UIView.transition(with: cell, duration: 0.8, options: .transitionCrossDissolve, animations: { [self] in

            cell.configureSelection((indexPath == selectedIndex) ? .white : Constants.gray, (indexPath == selectedIndex) ? Constants.green : .white, 1)

        }, completion: nil)
        
      
        

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Store the selected index
        selectedIndex = indexPath

        guard let cell = collectionView.cellForItem(at: indexPath) as? SegmentCollectionViewCell else { return }
        
        UIView.transition(with: cell, duration: 0.5, options: .transitionCrossDissolve, animations: {
            cell.configureSelection(.white, Constants.green, 0)
        }, completion: nil)

//        delegate?.showTheSurah(arrayOfSurahs[indexPath.row])
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? SegmentCollectionViewCell else { return }
        
        UIView.transition(with: cell, duration: 0.5, options: .transitionCrossDissolve, animations: {
            
            cell.configureSelection(Constants.gray, .white, 1)
        }, completion: nil)
    
        
        if selectedIndex == indexPath {
            selectedIndex = nil
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: categories[indexPath.row].name!.size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17)]).width + 25, height: 30)

    }
}
