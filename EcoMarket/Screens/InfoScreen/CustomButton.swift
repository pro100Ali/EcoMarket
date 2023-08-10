//
//  CustomButton.swift
//  EcoMarket
//
//  Created by Али  on 10.08.2023.
//

import UIKit
import SnapKit

class CustomButton: UIView {
    
    
    
    lazy private var button: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 16
        button.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
        return button
    }()
    
    lazy private var view: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
        return view
    }()
    
    lazy private var label: UILabel = {
        let label = UILabel()
        label.text = "Follow"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    lazy private var image: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "instagram")
        return image
    }()
    
    init(frame: CGRect, _ iconText: String, _ text: String) {
        super.init(frame: frame)
        
        addSubview(button)
        button.addSubview(view)
        view.addSubview(label)
        view.addSubview(image)
        setupConstraints()
        image.image = UIImage(named: iconText)
        label.text = text
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        label.snp.makeConstraints { make in
            make.leading.equalTo(image.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
        }
        image.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()

        }
        view.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.32)
        }
        
    }
}
