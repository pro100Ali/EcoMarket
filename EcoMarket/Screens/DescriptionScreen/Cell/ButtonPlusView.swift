//
//  ButtonPlusView.swift
//  EcoMarket
//
//  Created by Али  on 06.08.2023.
//

import UIKit
import SnapKit

protocol ButtonIsClicked: AnyObject {
    func plusButtonIsClicked()
    
    func minusButtonIsClicked()
}


class ButtonPlusView: UIView {

    var product = [Product]()
    
    var plusButtonTapPlusHandler: (() -> Void)?
    
    var minusButtonTapPlusHandler: (() -> Void)?
    
    weak var delegate: ButtonIsClicked?
    
    lazy private var plusButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = Constants.green
        button.addTarget(self, action: #selector(plusButtonAction), for: .touchUpInside)
//        button.layer.cornerRadius = 10
        return button
    }()
    
    lazy private var minusButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "minus"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = Constants.green
        button.addTarget(self, action: #selector(minusButtonAction), for: .touchUpInside)

//        button.layer.cornerRadius = 15

        return button
    }()
    
     var score: UILabel = {
       let label = UILabel()
        label.text = "1"
        label.textColor = .black
        return label
    }()
    
    lazy private var circlePlus: UIView = {
       let label = UIView()
        label.layer.cornerRadius = 15
        label.backgroundColor = Constants.green
        return label
    }()
    
    lazy private var circleMinus: UIView = {
       let label = UIView()
        label.layer.cornerRadius = 15
        label.backgroundColor = Constants.green
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(score)
        addSubview(circlePlus)
        addSubview(circleMinus)
        circlePlus.addSubview(plusButton)
        circleMinus.addSubview(minusButton)
        setupConstraints()
        
  

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func plusButtonAction() {
        delegate?.plusButtonIsClicked()
    }
    
    @objc func minusButtonAction() {
        delegate?.minusButtonIsClicked()
    }
    
    func updateLabel(_ quantity: Int) {
        score.text = "\(quantity)"
    }
    
    func setupConstraints() {
        circlePlus.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
        plusButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        circleMinus.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
        minusButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        score.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}
