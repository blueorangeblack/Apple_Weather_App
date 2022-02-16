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
private let weatherDetailCell = "WeatherDetailCell"
private let roundedBackgroundView = "RoundedBackgroundView"
private let headerView = "HeaderView"

class WeatherViewController: UIViewController {
    
    // MARK: - Properties
    
    var weather: Weather
    
    private lazy var timezone = weather.currentWeather.timezone
    private lazy var weeklyMinTemp = Int(weather.forecast.daily.map { $0.tempMin }.sorted(by: <).first ?? 0)
    private lazy var weeklyMaxTemp = Int(weather.forecast.daily.map { $0.tempMax }.sorted(by: >).first ?? 0)
    
    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.register(CurrentWeatherCell.self, forCellWithReuseIdentifier: currentWeatherCell)
        collectionView.register(HourlyForecastCell.self, forCellWithReuseIdentifier: hourlyForecastCell)
        collectionView.register(DailyForecastCell.self, forCellWithReuseIdentifier: dailyForecastCell)
        collectionView.register(WeatherDetailCell.self, forCellWithReuseIdentifier: weatherDetailCell)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerView)
        layout.register(RoundedBackgroundView.self, forDecorationViewOfKind: roundedBackgroundView)
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 10
        layout.configuration = config
        
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
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Helpers
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionNumber, _ -> NSCollectionLayoutSection? in
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(40))
            let headerView = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            headerView.pinToVisibleBounds = true
            
            if sectionNumber == 0 {
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.7)), subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                
                return section
            } else if sectionNumber == 1 {
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(80), heightDimension: .absolute(110)), subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.decorationItems = [
                    NSCollectionLayoutDecorationItem.background(elementKind: roundedBackgroundView)
                ]
                section.boundarySupplementaryItems = [headerView]
                
                return section
            } else if sectionNumber == 2 {
                let item = NSCollectionLayoutItem.init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.decorationItems = [
                    NSCollectionLayoutDecorationItem.background(elementKind: roundedBackgroundView)
                ]
                section.boundarySupplementaryItems = [headerView]
                
                return section
            } else {
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(130)))
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1000)), subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = .init(top: 0, leading: 0, bottom: 15, trailing: 0)
                
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
            return 25
        } else if section == 2 {
            return 8
        } else {
            return 6
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: currentWeatherCell, for: indexPath) as? CurrentWeatherCell else { return UICollectionViewCell() }
            cell.viewModel = CurrentWeatherViewModel(weather: weather)
            
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: hourlyForecastCell, for: indexPath) as? HourlyForecastCell else { return UICollectionViewCell() }
            cell.viewModel = HourlyForecastViewModel(currentWeather: weather.currentWeather, hourlyForecast: weather.forecast.hourly[indexPath.item])
            
            return cell
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: dailyForecastCell, for: indexPath) as? DailyForecastCell else { return UICollectionViewCell() }
            cell.viewModel = DailyForecastViewModel(dailyForecast: weather.forecast.daily[indexPath.item], index: indexPath.item, timezone: timezone, weeklyMinTemp: weeklyMinTemp, weeklyMaxTemp: weeklyMaxTemp)
            
            return cell
        case 3:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: weatherDetailCell, for: indexPath) as? WeatherDetailCell else { return UICollectionViewCell() }
            cell.viewModel = WeatherDetailViewModel(currentWeather: weather.currentWeather, index: indexPath.item, timezone: timezone, tomorrowSunrise: weather.forecast.daily[1].sunrise, tomorrowSunset: weather.forecast.daily[1].sunset)
            
            return cell
        default :
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerView, for: indexPath) as? HeaderView else { return UICollectionReusableView() }
        headerView.viewModel = HeaderViewModel(section: indexPath.section)
        
        return headerView
    }
}
