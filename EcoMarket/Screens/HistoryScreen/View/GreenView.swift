//
//  GreenView.swift
//  EcoMarket
//
//  Created by Али  on 12.08.2023.
//

import UIKit
import SnapKit

class GreenView: UIView {
    
    lazy private var image: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "check")
        image.sizeToFit()
        image.layer.cornerRadius = 25
        image.layer.masksToBounds = true
        return image
    }()
    
    var date: UILabel = {
        let label = UILabel()
        label.text = "Оформлен 07.07.2023 12:46"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    var cost: UILabel = {
        let label = UILabel()
        label.text = "396 tg"
        label.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    var delivery: UILabel = {
        let label = UILabel()
        label.text = "Доставка 150 tg"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(image)
        addSubview(date)
        addSubview(cost)
        addSubview(delivery)
        setupConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(dateText: String, costText: String) {
        date.text = dateText
        cost.text = "\(costText) tg"
    }
    
    func setupConstraints() {
        image.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.width.equalTo(74)
            make.height.equalTo(74)
            make.centerX.equalToSuperview()
        }
        
        date.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            
        }
        
        cost.snp.makeConstraints { make in
            make.top.equalTo(date.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            
        }
        
        delivery.snp.makeConstraints { make in
            make.top.equalTo(cost.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            
        }
    }
    
}
