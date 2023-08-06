//
//  ProductCollectionViewCell.swift
//  EcoMarket
//
//  Created by Али  on 05.08.2023.
//

import UIKit
import SnapKit

struct Colors {
    static let green = UIColor(red: 0.46, green: 0.86, blue: 0.11, alpha: 1)
}



class ProductCell: UICollectionViewCell, ButtonIsClicked {
    
        func plusButtonIsClicked() {
            plusButtonTapHandler?()
        }
        
        func minusButtonIsClicked() {
            minusButtonTapHandler?()
        }
    

        static let identifier = "ProductCell"
        
        var basketProduct = [Product]()
    
        var addButtonTapHandler: (() -> Void)?
        var plusButtonTapHandler: (() -> Void)?
        var minusButtonTapHandler: (() -> Void)?

        lazy private var image: UIImageView = {
            let image = UIImageView()
            image.image = UIImage(named: "apple")
            image.sizeToFit()
            image.layer.cornerRadius = 16
            image.layer.masksToBounds = true
            return image
        }()
        
         var title: UILabel = {
            let label = UILabel()
            label.text = "Яблоко золотая радуга"
            label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
            label.textColor = .black
            label.numberOfLines = 0
            return label
        }()
    
        lazy private var price: UILabel = {
            let label = UILabel()
            label.text = "360 tg"
            label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            label.textColor = Colors.green
            label.numberOfLines = 0
            return label
        }()
    
        lazy private var button: UIButton = {
           let button = UIButton()
            button.setTitle("Добавить", for: .normal)
            button.backgroundColor = Colors.green
            button.layer.cornerRadius = 16
            button.addTarget(self, action: #selector(clicked), for: .touchUpInside)
            return button
        }()
    
        let buttonPlus = ButtonPlusView()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            layer.cornerRadius = 16
            backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
            addSubview(image)
            addSubview(title)
            addSubview(price)
            addSubview(button)
            
            setupConstraints()
            
            buttonPlus.delegate = self
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    
        func showAddButton() {
            button.isHidden = false
            buttonPlus.isHidden = true
        }
    
        @objc func clicked() {

            addButtonTapHandler?()

            addSubview(buttonPlus)
            button.isHidden = true
            buttonPlus.isHidden = false

            buttonPlus.layer.cornerRadius = 16
            
            buttonPlus.snp.makeConstraints { make in
                make.bottom.equalToSuperview().inset(4)
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(32)
            }
//            buttonPlus.frame = CGRect(x: 0, y: 0, width: 151, height: 32)
        }
    
        func configure(_ category: Product) {
            title.text = category.title
            guard let priceOfProduct = category.price else {return}
            price.text = "\(String(describing: priceOfProduct)) tg"

            guard let imageOfProduct = category.image else { return }
            image.image = UIImage(named: imageOfProduct)
        }
        
        func setupConstraints() {
            image.snp.makeConstraints { make in
                make.leading.trailing.top.equalToSuperview().inset(4)
                make.bottom.equalToSuperview().inset(128)
            }
            
            title.snp.makeConstraints { make in
                make.top.equalTo(image.snp.bottom).offset(4)
                make.leading.trailing.equalToSuperview().inset(4)
            }
            
            price.snp.makeConstraints { make in
                make.top.equalTo(image.snp.bottom).offset(62)
                make.leading.trailing.equalToSuperview().inset(4)

            }
            button.snp.makeConstraints { make in
                make.bottom.equalToSuperview().inset(4)
                make.leading.trailing.equalToSuperview().inset(10)
            }
        }
    



}

extension UICollectionView {
    func indexPathForView(view: AnyObject) -> NSIndexPath? {
        let originInCollectioView = self.convert(CGPointZero, from: (view as! UIView))
        return self.indexPathForItem(at: originInCollectioView) as NSIndexPath?
    }
}
