//
//  CustomAlert.swift
//  EcoMarket
//
//  Created by Али  on 05.08.2023.
//

import UIKit
import SnapKit


class CustomAlert {
    
    
    struct Constants {
        static let backgroundAlpha: CGFloat = 0.8
    }
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0
        return view
    }()
    
    private let alertView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        return view
    }()
    
    
    private var myTargetView: UIView?
    
    func showAlert(vc: UIViewController) {
        
        guard let targetView = vc.view else { return }
        
        myTargetView = targetView
        
        backgroundView.frame = targetView.frame
        targetView.addSubview(backgroundView)
        
        alertView.frame = CGRect(x: 0, y: -600, width: targetView.frame.width, height: 458)
        
        targetView.addSubview(alertView)
        
        
        let image = UIImageView()
        image.image = UIImage(named: "sputnik")
        alertView.addSubview(image)
        
        image.snp.makeConstraints { make in
            make.height.equalTo(224)
            make.leading.trailing.equalToSuperview().inset(80)
        }
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 80, width: alertView.frame.width , height: 80))
        titleLabel.text = "Отсутствует интернет  соединение"
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines  = 0
        alertView.addSubview(titleLabel)
        
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.7)
        }
        
        
        let desc = UILabel(frame: CGRect(x: 0, y: 80, width: alertView.frame.width, height: 80))
        desc.text = "Попробуйте подключить мобильный интернет"
        desc.font = UIFont.systemFont(ofSize: 18, weight: .light)
        desc.textColor = .gray
        desc.textAlignment = .center
        desc.numberOfLines  = 0
        
        alertView.addSubview(desc)
        
        desc.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.7)
            
        }
        
        let buttonAlert = UIButton(frame: CGRect(x: 140, y: alertView.frame.height - 90, width: alertView.frame.width - 280, height: 40))
        buttonAlert.setTitle("Ok", for: .normal)
        buttonAlert.backgroundColor = .green
        buttonAlert.layer.cornerRadius = 16
        buttonAlert.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        alertView.addSubview(buttonAlert)
        
        buttonAlert.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(25)
            make.top.equalTo(desc.snp.bottom).offset(10)
            make.height.equalTo(60)
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundView.alpha = Constants.backgroundAlpha
        }) { done in
            if done {
                UIView.animate(withDuration: 0.3) {
                    self.alertView.center = targetView.center
                }
            }
        }
        
    }
    
    @objc func dismissAlert() {
        guard let targetView = myTargetView else {return}
        
        UIView.animate(withDuration: 0.3, animations: {
            self.alertView.frame = CGRect(x: 0, y: targetView.frame.height, width: targetView.frame.width, height: 300)
            
        }, completion: { done in
            if done {
                UIView.animate(withDuration: 0.3, animations: {
                    self.backgroundView.alpha = 0
                }, completion: { done in
                    if done {
                        self.alertView.removeFromSuperview()
                        self.backgroundView.removeFromSuperview()
                    }
                })
                
            }
        })
    }
    
}



