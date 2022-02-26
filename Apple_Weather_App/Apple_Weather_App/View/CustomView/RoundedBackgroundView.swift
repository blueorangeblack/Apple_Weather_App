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
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = backgroundViewColor
        layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
