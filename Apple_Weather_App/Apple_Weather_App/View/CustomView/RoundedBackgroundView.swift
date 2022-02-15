//
//  RoundedBackgroundView.swift
//  Apple_Weather_App
//
//  Created by Minju Lee on 2022/02/14.
//

import UIKit

/// RoundedBackgroundView (UICollectionReusableView)
class RoundedBackgroundView: UICollectionReusableView {
    
    // MARK: - Properties
    
//    private var roundedView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .secondaryLabel
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = backgroundViewColor
        layer.cornerRadius = 10
        
//        addSubview(roundedView)
//
//        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topLeft, .topRight, .bottomLeft, .bottomRight], cornerRadii: CGSize(width: 10, height: 10))
//        let mask = CAShapeLayer()
//        mask.path = path.cgPath
//        roundedView.layer.mask = mask
//
//        NSLayoutConstraint.activate([
//            roundedView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            roundedView.topAnchor.constraint(equalTo: topAnchor),
//            roundedView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            roundedView.bottomAnchor.constraint(equalTo: bottomAnchor)
//        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
