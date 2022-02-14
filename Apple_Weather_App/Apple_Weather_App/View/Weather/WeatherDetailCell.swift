//
//  WeatherDetailCell.swift
//  Apple_Weather_App
//
//  Created by Minju Lee on 2022/02/13.
//

import UIKit

class WeatherDetailCell: UICollectionViewCell {
    
    // MARK: - Properties
    //일몰 일출 바람 / 체감온도 습도 / 가시거리 기압
    var viewModel: WeatherDetailViewModel? {
        didSet { configure() }
    }
    
    var roundedBackgroundViewTrailingConstraint: NSLayoutConstraint?
    
    private let roundedBackgroundView: UIView = {
       let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .secondaryLabel
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(roundedBackgroundView)
        NSLayoutConstraint.activate([
            roundedBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            roundedBackgroundView.topAnchor.constraint(equalTo: topAnchor),
            roundedBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configure() {
        guard let viewModel = viewModel else { return }
        roundedBackgroundViewTrailingConstraint?.isActive = false
        roundedBackgroundViewTrailingConstraint = nil
        roundedBackgroundViewTrailingConstraint = NSLayoutConstraint(item: roundedBackgroundView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: viewModel.backViewTrailingConstant)
        roundedBackgroundViewTrailingConstraint?.isActive = true
    }
}
