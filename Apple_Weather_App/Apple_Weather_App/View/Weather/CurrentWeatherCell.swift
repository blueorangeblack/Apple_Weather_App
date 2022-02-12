//
//  CurrentWeatherCell.swift
//  Apple_Weather_App
//
//  Created by Minju Lee on 2022/02/08.
//

import UIKit

class CurrentWeatherCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var viewModel: CurrentWeatherViewModel? {
        didSet { configure() }
    }
    
    private let cityNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32)
        label.textColor = .white
        return label
    }()
    
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 70)
        label.textColor = .white
        return label
    }()
    
    private let weatherDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        return label
    }()
    
    private let tempMaxMinLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        let stackView = UIStackView(arrangedSubviews: [cityNameLabel, tempLabel, weatherDescriptionLabel, tempMaxMinLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configure() {
        guard let viewModel = viewModel else { return }

        cityNameLabel.text = viewModel.cityName
        tempLabel.text = viewModel.temp
        weatherDescriptionLabel.text = viewModel.weatherDescription
        tempMaxMinLabel.text = viewModel.tempMaxMin
    }
}
