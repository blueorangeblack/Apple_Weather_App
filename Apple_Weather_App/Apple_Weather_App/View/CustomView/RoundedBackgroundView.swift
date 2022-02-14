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
    
    private var roundedView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondaryLabel
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(roundedView)
        
        NSLayoutConstraint.activate([
            roundedView.leadingAnchor.constraint(equalTo: leadingAnchor),
            roundedView.topAnchor.constraint(equalTo: topAnchor),
            roundedView.trailingAnchor.constraint(equalTo: trailingAnchor),
            roundedView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
