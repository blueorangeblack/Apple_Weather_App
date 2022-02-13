//
//  DailyForecastCell.swift
//  Apple_Weather_App
//
//  Created by Minju Lee on 2022/02/11.
//

import UIKit

class DailyForecastCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var viewModel: DailyForecastViewModel? {
        didSet { configure() }
    }
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        return label
    }()
    
    private let iconAndPopStackView = IconAndPopStackView()
    
    private let tempMinLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .right
        label.textColor = .secondarySystemBackground.withAlphaComponent(0.5)
        return label
    }()
    
    private let spaceView = UIView()
    
    let tempRangeView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.clipsToBounds = true
        return view
    }()
    
    private let tempMaxLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .right
        label.textColor = .white
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .secondaryLabel
        
        NSLayoutConstraint.activate([
            dayLabel.widthAnchor.constraint(equalToConstant: 36),
            iconAndPopStackView.widthAnchor.constraint(greaterThanOrEqualToConstant: 60),
            tempMinLabel.widthAnchor.constraint(equalToConstant: 44),
            spaceView.widthAnchor.constraint(lessThanOrEqualToConstant: 10),
            tempRangeView.widthAnchor.constraint(lessThanOrEqualToConstant: 100),
            tempRangeView.heightAnchor.constraint(equalToConstant: 2),
            tempMaxLabel.widthAnchor.constraint(equalToConstant: 44)
        ])
        
        tempRangeView.setContentCompressionResistancePriority(UILayoutPriority(500), for: .horizontal)
        
        let stackView = UIStackView(arrangedSubviews: [dayLabel, iconAndPopStackView, tempMinLabel, spaceView, tempRangeView, tempMaxLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configure() {
        guard let viewModel = viewModel else { return }
        
        dayLabel.text = viewModel.day
        iconAndPopStackView.imageView.image = viewModel.image
        iconAndPopStackView.popLabel.text = viewModel.pop
        tempMinLabel.text = viewModel.tempMinString
        tempMaxLabel.text = viewModel.tempMaxString
        
        let dayilyMin = viewModel.dayilyMinTemp
        let dayilyMax = viewModel.dayilyMaxTemp
        let weeklyMin = viewModel.weeklyMinTemp
        let weeklyMax = viewModel.weeklyMaxTemp
        
        let weeklyRange = weeklyMax - weeklyMin
        let start: CGFloat = CGFloat((dayilyMin - weeklyMin) * 100 / weeklyRange)
        let stop: CGFloat = CGFloat(100 / weeklyRange * (weeklyRange - (weeklyMax - dayilyMax)))
        
        let path = UIBezierPath()
        path.lineWidth = 3
        path.move(to: CGPoint(x: start, y: 1.5))
        if dayilyMax == weeklyMax {
            path.addLine(to: CGPoint(x: 100, y: 1.5))
        } else {
            path.addLine(to: CGPoint(x: stop, y: 1.5))
        }
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = path.lineWidth
        shapeLayer.strokeColor = UIColor.orange.cgColor
        
        tempRangeView.layer.addSublayer(shapeLayer)
    }
}
