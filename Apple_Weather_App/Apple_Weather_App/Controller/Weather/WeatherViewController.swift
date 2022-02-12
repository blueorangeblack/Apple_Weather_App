//
//  WeatherViewController.swift
//  Apple_Weather_App
//
//  Created by Minju Lee on 2022/02/08.
//

import UIKit

private let currentWeatherCell = "CurrentWeatherCell"
private let hourlyForecastCell = "HourlyForecastCell"
private let dailyForecastCell = "DailyForecastCell"

class WeatherViewController: UIViewController {
    
    // MARK: - Properties
    
    var weather: Weather
    
    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(CurrentWeatherCell.self, forCellWithReuseIdentifier: currentWeatherCell)
        collectionView.register(HourlyForecastCell.self, forCellWithReuseIdentifier: hourlyForecastCell)
        collectionView.register(DailyForecastCell.self, forCellWithReuseIdentifier: dailyForecastCell)
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - Lifecycle
    
    init(weather: Weather) {
        self.weather = weather
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30)
        ])
    }
    
    // MARK: - Helpers
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionNumber, _ -> NSCollectionLayoutSection? in
            if sectionNumber == 0 {
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.7)), subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = .init(top: 0, leading: 0, bottom: 10, trailing: 0)
                
                return section
            } else if sectionNumber == 1 {
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(85), heightDimension: .absolute(120)), subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = .init(top: 0, leading: 0, bottom: 10, trailing: 0)
                section.orthogonalScrollingBehavior = .continuous
                
                return section
            } else if sectionNumber == 2 {
                let item = NSCollectionLayoutItem.init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = .init(top: 0, leading: 0, bottom: 10, trailing: 0)
                
                return section
            } else {
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(150)))
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1000)), subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = .init(top: 0, leading: 0, bottom: 50, trailing: 0)
                
                return section
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension WeatherViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 24
        } else {
            return 6
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: currentWeatherCell, for: indexPath) as? CurrentWeatherCell else { return UICollectionViewCell() }
            cell.backgroundColor = .clear
            cell.cityNameLabel.text = weather.cityName
            cell.tempLabel.text = "\(String(Int(weather.currentWeather.temp)))°"
            cell.weatherDescriptionLabel.text = weather.currentWeather.description
            cell.tempMaxMinLabel.text = "최고:\(String(Int(weather.currentWeather.tempMax)))° 최저:\(String(Int( weather.currentWeather.tempMin)))°"
            cell.tempMaxMinLabel.text = "최고:\(String(Int(weather.forecast.daily[0].tempMax)))° 최저:\(String(Int(weather.forecast.daily[0].tempMin)))°"
            
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: hourlyForecastCell, for: indexPath) as? HourlyForecastCell else { return UICollectionViewCell() }
            let dateformatter = DateFormatter()
            dateformatter.locale = Locale(identifier: "ko_KR")
            dateformatter.dateFormat = "a h시"
            cell.timeLabel.text = dateformatter.string(from: weather.forecast.hourly[indexPath.row].dt)
            cell.tempLabel.text = "\(Int(weather.forecast.hourly[indexPath.row].temp))°"

            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: dailyForecastCell, for: indexPath) as? DailyForecastCell else { return UICollectionViewCell() }
            cell.backgroundColor = .secondaryLabel
            
            return cell
        }
    }
}
