//
//  ConfirmationVC.swift
//  EcoMarket
//
//  Created by Али  on 11.08.2023.
//

import UIKit
import SnapKit


class ConfirmationVC: UIViewController {
    
    
    var textFieldPhone = CustomTextField(frame: .zero, text: "Номер телефона")
    var textFieldAddress = CustomTextField(frame: .zero, text: "Адрес")
    var textFieldOrientattion = CustomTextField(frame: .zero, text: "Ориентир")
    var textFieldComments = CustomTextField(frame: .zero, text: "Комментарии")
    
    var totalCost: UILabel = {
        let total = UILabel()
        total.text = "Сумма заказа 340"
        total.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        return total
    }()
    
    lazy private var button: UIButton = {
        let button = UIButton()
        button.setTitle("Оформить", for: .normal)
        button.backgroundColor = Constants.gray
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    let vc = CustomAlert()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(textFieldPhone)
        view.addSubview(textFieldAddress)
        view.addSubview(textFieldOrientattion)
        view.addSubview(textFieldComments)
        view.addSubview(button)
        view.addSubview(totalCost)
        
        textFieldPhone.delegate = self
        textFieldAddress.delegate = self
        textFieldOrientattion.delegate = self
        textFieldComments.delegate = self
        setupConstraints()
    }
    
    @objc func buttonAction() {
        
        
        AlamofireCaller.shared.postTheData(basketProduct: BasketManager.shared.getBasketProducts()) { res in
            switch res {
            case .success(let success):
                print(success)
                BasketManager.shared.updateHistory(success)
            case .failure(let failure):
                print(failure)
            }
        }
        
        
        vc.showAlert(vc: self, text: "Заказ №343565657 оформлен", imageText: "bagSmile", descText: "Дата и время 07.07.2023 12:46", myFunc: dismissToMainTabBar)
        
        
    }
    
    @objc func dismissToMainTabBar() {
        if let mainTabBarController = tabBarController as? TabBarController {
            navigationController?.popToRootViewController(animated: false)
            mainTabBarController.selectedIndex = 0 // Select the first tab
            BasketManager.shared.clearBasket()
            if let viewControllerToPop = navigationController?.viewControllers.first(where: { $0 is MainViewController }) {
                navigationController?.popToViewController(viewControllerToPop, animated: true)
            }
            
        }
    }
    
    
    
    
    func updateButtonState() {
        let isAllFieldsFilled = !textFieldPhone.getText()!.isEmpty &&
        !textFieldAddress.getText()!.isEmpty &&
        !textFieldOrientattion.getText()!.isEmpty &&
        !textFieldComments.getText()!.isEmpty
        button.isEnabled = true
        button.backgroundColor = isAllFieldsFilled ? Constants.green : Constants.gray
    }
    
    func setupConstraints() {
        textFieldPhone.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(39)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
        }
        textFieldAddress.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(39)
            make.top.equalTo(textFieldPhone.snp.bottom).offset(20)
        }
        textFieldOrientattion.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(39)
            make.top.equalTo(textFieldAddress.snp.bottom).offset(20)
        }
        
        textFieldComments.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(39)
            make.top.equalTo(textFieldOrientattion.snp.bottom).offset(20)
        }
        
        totalCost.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(100)
            make.centerX.equalToSuperview()
            make.height.equalTo(19)
        }
        
        button.snp.makeConstraints { make in
            make.top.equalTo(totalCost.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(54)
        }
    }
    
    
}


class CustomTextField: UIView {
    
    lazy private var textfield: UITextField = {
        let text = UITextField()
        return text
    }()
    
    weak var delegate: UITextFieldDelegate? {
        get { return textfield.delegate }
        set { textfield.delegate = newValue }
    }
    
    
    init(frame: CGRect, text: String) {
        super.init(frame: frame)
        addSubview(textfield)
        textfield.placeholder = text
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getText() -> String? {
        return textfield.text
    }
    func setupConstraints() {
        textfield.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
    }
}


extension ConfirmationVC: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        updateButtonState()
    }
}
