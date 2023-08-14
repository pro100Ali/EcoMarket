//
//  SelectionViewController.swift
//  EcoMarket
//
//  Created by Али  on 15.08.2023.
//

import UIKit
import SnapKit

class SelectionViewController: UIViewController {

    var product: Product?

    lazy private var imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "apple")
        iv.layer.cornerRadius = 16
        return iv
    }()
    
    lazy private var label: UILabel = {
       let label = UILabel()
        label.text = "Яблоко красная радуга сладкая"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    lazy private var price: UILabel = {
       let label = UILabel()
        label.text = "56 c шт"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = Constants.green
        return label
    }()
    
    lazy private var desc: UILabel = {
       let label = UILabel()
        label.text = "Cочный плод яблони, который употребляется в пищу в свежем и запеченном виде, служит сырьём в кулинарии и для приготовления напитков."
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.textColor = .gray
        return label
    }()
    
    lazy private var button: UIButton = {
        let label = UIButton()
        label.setTitle("Добавить", for: .normal)
        label.backgroundColor = Constants.green
        label.setTitleColor(.white, for: .normal)
        label.layer.cornerRadius = 16
        label.addTarget(self, action: #selector(clicked), for: .touchUpInside)

        return label
    }()
    
    let buttonPlus = ButtonPlusView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(imageView)
        view.addSubview(label)
        view.addSubview(button)
        view.addSubview(desc)
        view.addSubview(price)
        view.layer.cornerRadius = 16

        buttonPlus.delegate = self
        setupConstraints()
        showAddButton()
        
        
        let backgroundView = UIView(frame: view.bounds)
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5) // Adjust the alpha as needed
        view.insertSubview(backgroundView, at: 0)
        
        // Add a tap gesture recognizer to the background view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        backgroundView.addGestureRecognizer(tapGesture)
        
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        // Dismiss the SelectionViewController when tapping outside
        dismiss(animated: true, completion: nil)
    }
    
    
    func configure(_ product: Product) {
        if let urlImage = product.image {
            imageView.kf.setImage(with: URL(string: urlImage))
        }
        label.text = product.title
        price.text = product.price
//        desc.text = product.description
        
    }
    
    @objc func clicked() {
        BasketManager.shared.addProductToBasket(product!)
//        product?.isAdded = true
//        if product?.isAdded == true {
        print("added \(product!)")
        constraintsForButtoPlusMinus()


//        }
    }
    
//
    func constraintsForButtoPlusMinus() {
        view.addSubview(buttonPlus)
        button.isHidden = true
        buttonPlus.isHidden = false
        buttonPlus.layer.cornerRadius = 16

        buttonPlus.snp.makeConstraints { make in
            make.top.equalTo(desc.snp.bottom).offset(37)
            make.trailing.equalToSuperview().inset(16)
            make.width.equalTo(158)
            make.height.equalTo(32)
        }
    }
    
    func showAddButton() {
        button.isHidden = false
        buttonPlus.isHidden = true
    }
    
    func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.width.equalTo(343)
            make.height.equalTo(220)
            make.centerX.equalToSuperview()
        }
        label.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(imageView.snp.bottom).offset(12)
        }
        price.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(label.snp.bottom).offset(8)
        }
        
        desc.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(price.snp.bottom).offset(8)
        }
        
        button.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(desc.snp.bottom).offset(8)
            make.height.equalTo(54)
        }
    }
   

}

extension SelectionViewController: ButtonIsClicked {
    
    func plusButtonIsClicked() {
        BasketManager.shared.plusQuantity(for: product!)
        
        if let product = BasketManager.shared.getById((product?.id)!) {
            buttonPlus.updateLabel(product.quantity!)
        }

    }
    
    func minusButtonIsClicked() {
        
        BasketManager.shared.minusQuantity(for: product!)
        
        if let product = BasketManager.shared.getById((product?.id)!) {
            buttonPlus.updateLabel(product.quantity!)
        }

    }
}


class HalfScreenPresentationController: UIPresentationController {

    override var frameOfPresentedViewInContainerView: CGRect {
           guard let containerView = containerView else {
               return .zero
           }

        let halfScreenHeight: CGFloat = containerView.bounds.height * 0.6
           let yOffset = containerView.bounds.height - halfScreenHeight

           return CGRect(x: 0, y: yOffset, width: containerView.bounds.width, height: halfScreenHeight)
       }

    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
          super.presentationTransitionDidEnd(completed)
          
          if completed {
              let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
              presentedViewController.view.addGestureRecognizer(tapGesture)
          }
      }

      @objc private func handleTap() {
          presentedViewController.dismiss(animated: true, completion: nil)
      }
}

