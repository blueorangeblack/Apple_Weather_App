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
    
    private let tempRangeViewHeight: CGFloat = 4
    
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
    
    private lazy var tempRangeView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.clipsToBounds = true
        view.layer.cornerRadius = tempRangeViewHeight / 2
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
        
        NSLayoutConstraint.activate([
            dayLabel.widthAnchor.constraint(equalToConstant: 36),
            iconAndPopStackView.widthAnchor.constraint(greaterThanOrEqualToConstant: 60),
            tempMinLabel.widthAnchor.constraint(equalToConstant: 44),
            spaceView.widthAnchor.constraint(lessThanOrEqualToConstant: 10),
            tempRangeView.widthAnchor.constraint(lessThanOrEqualToConstant: 100),
            tempRangeView.heightAnchor.constraint(equalToConstant: tempRangeViewHeight),
            tempMaxLabel.widthAnchor.constraint(equalToConstant: 44)
        ])
        
        tempRangeView.setContentCompressionResistancePriority(UILayoutPriority(500), for: .horizontal)
        
        let stackView = UIStackView(arrangedSubviews: [dayLabel, iconAndPopStackView, tempMinLabel, spaceView, tempRangeView, tempMaxLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
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
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let viewModel = viewModel else { return }
        
        let dailyMin = viewModel.dailyMinTemp
        let dailyMax = viewModel.dailyMaxTemp
        let weeklyMin = viewModel.weeklyMinTemp
        let weeklyMax = viewModel.weeklyMaxTemp
        
        let weeklyRange = weeklyMax - weeklyMin
        let dailyX1 = CGFloat((dailyMin - weeklyMin) * 100 / weeklyRange)
        let dailyX2 = CGFloat(100 / weeklyRange * (weeklyRange - (weeklyMax - dailyMax)))
        
        let dailyPath = UIBezierPath()
        dailyPath.lineWidth = tempRangeViewHeight
        dailyPath.move(to: CGPoint(x: dailyX1, y: tempRangeViewHeight / 2))
        if dailyMax == weeklyMax {
            dailyPath.addLine(to: CGPoint(x: 100, y: tempRangeViewHeight / 2))
        } else {
            dailyPath.addLine(to: CGPoint(x: dailyX2, y: tempRangeViewHeight / 2))
        }
        UIColor.clear.setStroke()
        
        let dailyShapeLayer = CAShapeLayer()
        dailyShapeLayer.path = dailyPath.cgPath
        dailyShapeLayer.lineWidth = dailyPath.lineWidth
        var strokeColor = UIColor.blue.cgColor
        if dailyMax < 0 {
            strokeColor = UIColor.blue.cgColor
        } else if dailyMax < 10 {
            strokeColor = UIColor.systemTeal.cgColor
        } else if dailyMax < 20 {
            strokeColor = UIColor.yellow.cgColor
        } else {
            strokeColor = UIColor.orange.cgColor
        }
        dailyShapeLayer.strokeColor = strokeColor
        dailyShapeLayer.lineCap = .round
        
        tempRangeView.layer.addSublayer(dailyShapeLayer)
    }
    
    func configure() {
        guard let viewModel = viewModel else { return }
        
        dayLabel.text = viewModel.day
        iconAndPopStackView.imageView.image = viewModel.image
        iconAndPopStackView.popLabel.text = viewModel.pop
        tempMinLabel.text = viewModel.tempMinString
        tempMaxLabel.text = viewModel.tempMaxString
    }
}
