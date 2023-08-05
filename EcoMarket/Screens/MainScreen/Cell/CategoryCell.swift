//
//  CategoryCell.swift
//  EcoMarket
//
//  Created by Али  on 04.08.2023.
//

import UIKit
import SnapKit

class CategoryCell: UICollectionViewCell {
    
    static var identifier = "CategoryCell"
    
    var view = UIView()
    
    lazy private var image: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "fruits")
        image.sizeToFit()
        image.layer.cornerRadius = 16
        image.layer.masksToBounds = true
        return image
    }()
    
    lazy private var title: UILabel = {
        let label = UILabel()
        label.text = "Fruits"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 16
        addSubview(image)
        addGradient()
        image.addSubview(title)
        image.addSubview(view)
        image.bringSubviewToFront(title)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.black.withAlphaComponent(0.4).cgColor, UIColor.clear.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        view.layer.addSublayer(gradientLayer)
    }
    
    func configure(_ category: Category) {
        if let imageOfCategory = category.image {
            image.image = UIImage(named: imageOfCategory)
        }
        title.text = category.name
    }
    
    func setupConstraints() {
        image.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        title.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(12)
            make.width.equalToSuperview().multipliedBy(0.7)
            make.bottom.equalToSuperview().inset(12)
        }
    }
}


