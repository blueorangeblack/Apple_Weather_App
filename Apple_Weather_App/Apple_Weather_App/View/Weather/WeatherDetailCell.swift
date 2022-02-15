//
//  WeatherDetailCell.swift
//  Apple_Weather_App
//
//  Created by Minju Lee on 2022/02/13.
//

import UIKit

class WeatherDetailCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var viewModel: WeatherDetailViewModel? {
        didSet { configure() }
    }
    
    private var roundedBackgroundViewTrailingConstraint: NSLayoutConstraint?
    private var roundedBackgroundViewLeadingConstraint: NSLayoutConstraint?
    
    private let roundedBackgroundView: UIView = {
       let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = backgroundViewColor
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = headerTitleColor
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let subdetailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let labelStackView = UIStackView(arrangedSubviews: [detailLabel, subdetailLabel])
        labelStackView.axis = .vertical
        labelStackView.alignment = .leading
        labelStackView.distribution = .fillProportionally
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        
        [roundedBackgroundView, titleLabel, labelStackView].forEach { contentView.addSubview($0) }
        
        NSLayoutConstraint.activate([
            roundedBackgroundView.topAnchor.constraint(equalTo: topAnchor),
            roundedBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            titleLabel.heightAnchor.constraint(equalToConstant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            
            labelStackView.leadingAnchor.constraint(equalTo: roundedBackgroundView.leadingAnchor, constant: 20),
            labelStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            labelStackView.trailingAnchor.constraint(equalTo: roundedBackgroundView.trailingAnchor, constant: -20),
            labelStackView.bottomAnchor.constraint(equalTo: roundedBackgroundView.bottomAnchor, constant: -20)
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
        
        roundedBackgroundViewLeadingConstraint?.isActive = false
        roundedBackgroundViewLeadingConstraint = nil
        roundedBackgroundViewLeadingConstraint = NSLayoutConstraint(item: roundedBackgroundView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: viewModel.backViewLeadingConstant)
        roundedBackgroundViewLeadingConstraint?.isActive = true
        
        titleLabel.text = viewModel.title
        detailLabel.text = viewModel.detail
        subdetailLabel.text = viewModel.subdetail
    }
}
