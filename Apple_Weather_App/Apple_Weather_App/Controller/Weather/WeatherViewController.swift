//
//  WeatherViewController.swift
//  Apple_Weather_App
//
//  Created by Minju Lee on 2022/02/08.
//

import UIKit

private let currentWeatherCell = "CurrentWeatherCell"

class WeatherViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(CurrentWeatherCell.self, forCellWithReuseIdentifier: currentWeatherCell)
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - Lifecycle
    
    init(color: UIColor) {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
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
                section.contentInsets = .init(top: 50, leading: 0, bottom: 10, trailing: 0)
                
                return section
            } else if sectionNumber == 1 {
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                item.contentInsets.trailing = 10
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(100), heightDimension: .absolute(150)), subitems: [item])
                
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
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(300)))
                
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
        } else {
            return 6
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: currentWeatherCell, for: indexPath)
        cell.backgroundColor = .gray
        cell.layer.cornerRadius = 5
        return cell
    }
}
