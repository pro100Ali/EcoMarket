//
//  BagView.swift
//  EcoMarket
//
//  Created by Али  on 14.08.2023.
//

import UIKit
import SnapKit

class BagView: UIView {

    lazy private var image: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(named: "bagO")
        return image
    }()
    
    lazy private var label: UILabel = {
       let label = UILabel()
        label.text = "Nothing found"
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(image)
        addSubview(label)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        image.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        label.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).offset(28)
            make.centerX.equalToSuperview()
        }
        
    }
}
