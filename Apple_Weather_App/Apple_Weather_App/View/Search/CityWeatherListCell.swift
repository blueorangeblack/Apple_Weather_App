//
//  CityWeatherListCell.swift
//  Apple_Weather_App
//
//  Created by Minju Lee on 2022/02/09.
//

import UIKit

class CityWeatherListCell: UITableViewCell {
    
    // MARK: - Properties
    
    var viewModel: CityWeatherListViewModel? {
        didSet { configure() }
    }
    
    private var backViewLeadingConstraint: NSLayoutConstraint?
    private var backViewTrailingConstraint: NSLayoutConstraint?
    
    private let backView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 13
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let cityNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let weatherDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 45)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tempMaxMinLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .systemBackground
        
        [backView, cityNameLabel, timeLabel, weatherDescriptionLabel, tempLabel, tempMaxMinLabel].forEach { contentView.addSubview($0) }
        
        backViewLeadingConstraint = NSLayoutConstraint(item: backView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 10)
        backViewLeadingConstraint?.isActive = true

        backViewTrailingConstraint = NSLayoutConstraint(item: backView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -10)
        backViewTrailingConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            backView.heightAnchor.constraint(equalToConstant: 115),
            
            cityNameLabel.topAnchor.constraint(equalTo: backView.topAnchor, constant: 15),
            cityNameLabel.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 15),
            timeLabel.topAnchor.constraint(equalTo: cityNameLabel.bottomAnchor),
            timeLabel.leadingAnchor.constraint(equalTo: cityNameLabel.leadingAnchor),
            weatherDescriptionLabel.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -15),
            weatherDescriptionLabel.leadingAnchor.constraint(equalTo: cityNameLabel.leadingAnchor),
            
            tempLabel.topAnchor.constraint(equalTo: cityNameLabel.topAnchor, constant: -7),
            tempLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -15),
            tempMaxMinLabel.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -15),
            tempMaxMinLabel.trailingAnchor.constraint(equalTo: tempLabel.trailingAnchor)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configure() {
        guard let viewModel = viewModel else { return }
        
        backView.backgroundColor = viewModel.weatherColor
        cityNameLabel.text = viewModel.cityName
        timeLabel.text = viewModel.time
        weatherDescriptionLabel.text = viewModel.weatherDescription
        tempLabel.text = viewModel.temp
        tempMaxMinLabel.text = viewModel.tempMaxMin
        
        if viewModel.isEditing {
            backViewLeadingConstraint?.isActive = false
            backViewLeadingConstraint = nil
            backViewLeadingConstraint = NSLayoutConstraint(item: backView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 50)
            backViewLeadingConstraint?.isActive = true
            backViewTrailingConstraint?.isActive = false
            backViewTrailingConstraint = nil
            backViewTrailingConstraint = NSLayoutConstraint(item: backView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -50)
            backViewTrailingConstraint?.isActive = true
        } else {
            backViewLeadingConstraint?.isActive = false
            backViewLeadingConstraint = nil
            backViewLeadingConstraint = NSLayoutConstraint(item: backView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 10)
            backViewLeadingConstraint?.isActive = true
            backViewTrailingConstraint?.isActive = false
            backViewTrailingConstraint = nil
            backViewTrailingConstraint = NSLayoutConstraint(item: backView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -10)
            backViewTrailingConstraint?.isActive = true
        }
    }
}
