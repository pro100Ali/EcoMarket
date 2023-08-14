//
//  LoadingIndicator.swift
//  EcoMarket
//
//  Created by Али  on 14.08.2023.
//
import UIKit

class LoadingIndicator: UIView {
    
    private var circleLayer: CAShapeLayer!
    
    private var image: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(named: "Ellipse")
        return iv
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        circleLayer = CAShapeLayer()
        circleLayer.strokeColor = Constants.green.cgColor
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineWidth = 5
        circleLayer.lineCap = .round
        layer.addSublayer(circleLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        circleLayer.frame = bounds
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2 - circleLayer.lineWidth / 2
        let startAngle: CGFloat = 0
        let endAngle: CGFloat = .pi * 0.9
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        circleLayer.path = path.cgPath
    }

    func startAnimating() {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0
        rotateAnimation.toValue = 2 * Double.pi
        rotateAnimation.duration = 1
        rotateAnimation.repeatCount = .infinity
        circleLayer.add(rotateAnimation, forKey: "rotate")
    }

    func stopAnimating() {
        circleLayer.removeAnimation(forKey: "rotate")
    }
}
