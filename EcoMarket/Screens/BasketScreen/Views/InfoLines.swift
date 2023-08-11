//
//  InfoLines.swift
//  EcoMarket
//
//  Created by Али  on 11.08.2023.
//

import UIKit
import SnapKit

class InfoLines: UIView {

    lazy private var sumText: UILabel = {
        let text = UILabel()
        text.text = "Sum"
        text.textColor = UIColor(red: 0.67, green: 0.67, blue: 0.68, alpha: 1)
        return text
    }()
    
    lazy private var countSum: UILabel = {
        let text = UILabel()
        text.text = "396"
        text.textColor = .label
        return text
    }()
    
    init(frame: CGRect, text: String, total: Int) {
        super.init(frame: frame)
        addSubview(sumText)
        addSubview(countSum)
        setupConstraints()
        sumText.text = text
        countSum.text = "\(total)"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateText(_ total: Double) {
        countSum.text = "\(total)"
    }
    func setupConstraints() {
        sumText.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        countSum.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}
