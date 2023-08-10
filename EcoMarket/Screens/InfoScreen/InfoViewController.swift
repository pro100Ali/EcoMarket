//
//  InfoViewController.swift
//  EcoMarket
//
//  Created by Али  on 10.08.2023.
//

import UIKit
import SnapKit

class InfoViewController: UIViewController {

    lazy private var image: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "headerView")
        return image
    }()
    
    lazy private var text: UILabel = {
       let text = UILabel()
        text.text = "Eco Market"
        text.textColor = .label
        text.font = UIFont.systemFont(ofSize: 25, weight: .semibold)

        return text
    }()
    
    lazy private var textDesc: UILabel = {
       let text = UILabel()
        text.text = "Фрукты, овощи, зелень, сухофрукты а так же сделанные из натуральных ЭКО продуктов (варенье, салаты, соления, компоты и т.д.) можете заказать удобно, качественно и по доступной цене.Готовы сотрудничать взаимовыгодно с магазинами.Наши цены как на рынке.        Мы заинтересованы в экономии ваших денег и времени.Стоимость доставки 150 сом и ещё добавлен для окраину города.При отказе подтвержденного заказа более 2-х раз Клиент заносится в чёрный список!!"
        text.numberOfLines = 0
        text.textColor = .label
        return text
    }()

    let button = CustomButton(frame: .zero, "phone", "Позвонить")
    let button2 = CustomButton(frame: .zero, "whatsapp", "WhatsApp")
    let button3 = CustomButton(frame: .zero, "instagram", "Instagram")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Инфо"
        view.addSubview(image)
        view.addSubview(text)
        view.addSubview(textDesc)
        view.addSubview(button)
        view.addSubview(button2)
        view.addSubview(button3)
        setupConstraints()
    }
    

   
    func setupConstraints() {
        image.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(626)
        }
        text.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(16)
        }
        
        textDesc.snp.makeConstraints { make in
            make.top.equalTo(text.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(16)
        }
        
        button.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(54)
            make.top.equalTo(textDesc.snp.bottom).offset(33)
        }
        button2.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(54)
            make.top.equalTo(button.snp.bottom).offset(12)
        }
        
        button3.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(54)
            make.top.equalTo(button2.snp.bottom).offset(12)
        }
    }

}
