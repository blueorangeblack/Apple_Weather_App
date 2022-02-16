//
//  HourlyForecastCell.swift
//  Apple_Weather_App
//
//  Created by Minju Lee on 2022/02/10.
//

import UIKit

class HourlyForecastCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var viewModel: HourlyForecastViewModel? {
        didSet { configure() }
    }
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    private let iconAndPopStackView = IconAndPopStackView()
    
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .white
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stackView = UIStackView(arrangedSubviews: [timeLabel, iconAndPopStackView, tempLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configure() {
        guard let viewModel = viewModel else { return }

        timeLabel.text = viewModel.time
        iconAndPopStackView.imageView.image = viewModel.image
        iconAndPopStackView.popLabel.text = viewModel.pop
        tempLabel.text = viewModel.temp
    }
}
