//
//  IconAndPopStackView.swift
//  Apple_Weather_App
//
//  Created by Minju Lee on 2022/02/13.
//

import UIKit

class IconAndPopStackView: UIStackView {
    
    // MARK: - Properties
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 20)
        return imageView
    }()
    
    let popLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .systemTeal
        return label
    }()
    
    // MARK: - Lifecycle
    
    init() {
        super.init(frame: .zero)
        
        let iconStackView = UIStackView(arrangedSubviews: [imageView, popLabel])
        iconStackView.axis = .vertical
        iconStackView.alignment = .center
        iconStackView.distribution = .fillProportionally
        iconStackView.spacing = 2
        iconStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(iconStackView)
        
        NSLayoutConstraint.activate([
            iconStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconStackView.topAnchor.constraint(equalTo: topAnchor),
            iconStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            iconStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
