//
//  CategoryCollectionViewCell.swift
//  EcoMarket
//
//  Created by Али  on 06.08.2023.
//

import UIKit
import SnapKit

class SegmentCollectionViewCell: UICollectionViewCell {
    
     var rectView: UIView = {
        let view = UIView()
//        view.backgroundColor = Constants.green
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor(red: 0.82, green: 0.82, blue: 0.84, alpha: 1).cgColor
        view.layer.cornerRadius = 15
        return view
    }()
    
    var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.layer.cornerRadius = 15
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor(red: 0.82, green: 0.82, blue: 0.84, alpha: 1)
        
        return label
    }()
    
    var line: UIView = {
        let line = UIView()
        line.backgroundColor = .green
        line.isHidden = true
        return line
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(rectView)
        
        rectView.addSubview(label)
        rectView.addSubview(line)
        setupConstraints()
        
    }
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)
        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        return layoutAttributes
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureSelection(_ colorOfText: UIColor, _ backColor: UIColor, _ border: Int) {
        label.textColor = colorOfText
        rectView.backgroundColor = backColor
        rectView.layer.borderWidth = CGFloat(border)
    }
        
    
    func setupConstraints() {
        rectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
        }
        line.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.centerX.equalToSuperview()
            make.height.equalTo(2)
        }
    }
    
    
}
