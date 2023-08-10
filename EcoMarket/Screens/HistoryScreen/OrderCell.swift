//
//  BasketCell.swift
//  EcoMarket
//
//  Created by Али  on 06.08.2023.
//

import UIKit
import SnapKit

class OrderCell: UICollectionViewCell {
    
    static let identifier = "OrderCell"

    lazy private var image: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "frame")
        image.sizeToFit()
        image.layer.cornerRadius = 16
        image.layer.masksToBounds = true
        return image
    }()
    
     var title: UILabel = {
        let label = UILabel()
        label.text = "Заказа #12345"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    var descriptionOfProduct: UILabel = {
       let label = UILabel()
       label.text = "12:46"
       label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = UIColor(red: 0.67, green: 0.67, blue: 0.68, alpha: 1)
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

   
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 15

        addSubview(image)
        addSubview(price)
        addSubview(title)
        addSubview(descriptionOfProduct)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ order: Order) {
        title.text = order.id
        price.text = "\(order.totalCost) tg"
    }
    func setupConstraints() {
        image.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(43)
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
            make.trailing.equalToSuperview().inset(22)
            make.top.equalTo(title.snp.top)
        }
    }
}
