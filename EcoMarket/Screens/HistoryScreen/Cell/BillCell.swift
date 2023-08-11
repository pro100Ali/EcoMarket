//
//  BillCell.swift
//  EcoMarket
//
//  Created by Али  on 11.08.2023.
//

import UIKit
import SnapKit

class BillCell: UICollectionViewCell {
    
    static let identifier = "BillCell"

    
    lazy private var image: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "apple")
        image.sizeToFit()
        image.layer.cornerRadius = 22
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
    
    var descriptionOfProduct: UILabel = {
       let label = UILabel()
       label.text = "Яблоко золотая радуга"
       label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = Constants.gray
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

    lazy private var quantity: UILabel = {
        let label = UILabel()
        label.text = "1 шт"
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.textColor = Constants.gray
        label.numberOfLines = 0
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 15

        addSubview(image)
        addSubview(price)
        addSubview(title)
        addSubview(descriptionOfProduct)
        addSubview(quantity)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(_ product: Product) {
        if let urlImage = product.image {
            image.kf.setImage(with: URL(string: urlImage))
        }
        title.text = product.title
        price.text = product.price
        guard let quantityCount = product.quantity else {return}
        quantity.text = "\(quantityCount) шт"

        descriptionOfProduct.text = product.description
    }
    
    func setupConstraints() {
        image.snp.makeConstraints { make in
            make.width.equalTo(43)
            make.height.equalTo(43)
            make.leading.equalToSuperview().inset(4)
            make.centerY.equalToSuperview()
        }
        title.snp.makeConstraints { make in
            make.leading.equalTo(image.snp.trailing).offset(8)
            make.top.equalTo(image.snp.top)
        }
        descriptionOfProduct.snp.makeConstraints { make in
            make.leading.equalTo(image.snp.trailing).offset(8)
            make.top.equalTo(title.snp.bottom).offset(4)
        }
        price.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.top.equalTo(title.snp.top)
        }
        quantity.snp.makeConstraints { make in
            make.top.equalTo(price.snp.bottom).offset(9)
            make.trailing.equalToSuperview().inset(12)
        }
    }
}
