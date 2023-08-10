//
//  SectionHeader.swift
//  EcoMarket
//
//  Created by Али  on 10.08.2023.
//

import UIKit

class SectionHeader: UICollectionReusableView {
    static let identifier = "SectionHeader"
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with title: String) {
        label.text = title
    }
}
