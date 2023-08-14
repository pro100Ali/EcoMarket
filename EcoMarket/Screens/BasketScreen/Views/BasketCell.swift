//
//  BasketCell.swift
//  EcoMarket
//
//  Created by Али  on 06.08.2023.
//

import UIKit
import SnapKit

class BasketCell: UICollectionViewCell  {
    
  
    var product: Product?
    var indexPath: IndexPath?
    var updateCollection: (() -> Void)?
    
    static let identifier = "BasketCell"

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

    lazy private var trash: UIButton = {
       let image = UIButton()
        image.setImage(UIImage(named: "trash"), for: .normal)
        image.addTarget(self, action: #selector(actionButton), for: .touchUpInside)
        image.backgroundColor = .white
        image.layer.cornerRadius = 5
        return image
    }()
    
    @objc func actionButton() {
        BasketManager.shared.removeById((product?.id)!)
        updateCollection?()
    }
   
    let buttonPlus = ButtonPlusView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 15

        addSubview(image)
        contentView.addSubview(trash)
        addSubview(price)
        addSubview(title)
        addSubview(descriptionOfProduct)
        contentView.addSubview(buttonPlus)
        contentView.bringSubviewToFront(buttonPlus)
        setupConstraints()
        buttonPlus.delegate = self
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureProduct(_ product: Product, _ indexPath: IndexPath) {
        self.indexPath = indexPath
        self.product = product
        
        if let urlImage = product.image {
            image.kf.setImage(with: URL(string: urlImage))
        }
        title.text = product.title
        price.text = product.price
        guard let quantity = product.quantity else {return}
        buttonPlus.score.text = "\(String(describing: quantity))"
        descriptionOfProduct.text = product.description
    }
    
    
    
    
    
    func setupConstraints() {
        buttonPlus.snp.makeConstraints { make in
            make.bottom.equalTo(image.snp.bottom)
            make.trailing.equalToSuperview().inset(4)
            make.leading.equalToSuperview().inset(260)
            make.height.equalTo(32)
        }
        image.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(4)
            make.width.equalTo(98)
            make.top.bottom.equalToSuperview().inset(4)
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
            make.leading.equalTo(image.snp.trailing).offset(8)
            make.bottom.equalTo(image.snp.bottom)
        }
        trash.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(2)
        }
    }
}


extension BasketCell: ButtonIsClicked {
    
    func plusButtonIsClicked() {
        
        BasketManager.shared.plusQuantity(for: product!)

    }
    
    func minusButtonIsClicked() {
        BasketManager.shared.minusQuantity(for: product!)

    }
    
}
