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
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .white
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 20)
        return imageView
    }()
    
    private let popLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .systemTeal
        return label
    }()
    
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .white
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .secondaryLabel
        
        let iconStackView = UIStackView(arrangedSubviews: [imageView, popLabel])
        iconStackView.axis = .vertical
        iconStackView.alignment = .center
        iconStackView.distribution = .fill
        iconStackView.spacing = 2
        iconStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView(arrangedSubviews: [timeLabel, iconStackView, tempLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
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
        imageView.image = viewModel.image
        popLabel.text = viewModel.pop
        tempLabel.text = viewModel.temp
    }
}
