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
class ProductCell: UICollectionViewCell {

        static var identifier = "ProductCell"
        
        
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
            return button
        }()
    
        
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            layer.cornerRadius = 16
            backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
            addSubview(image)
            addSubview(title)
            addSubview(price)
            addSubview(button)
           
            setupConstraints()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        
        func configure(_ category: Product) {
            title.text = category.title

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
            }
            button.snp.makeConstraints { make in
                make.bottom.equalToSuperview().inset(4)
                make.leading.trailing.equalToSuperview().inset(10)
            }
        }
    



}
