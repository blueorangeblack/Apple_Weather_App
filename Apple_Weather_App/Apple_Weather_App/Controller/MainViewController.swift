//
//  MainViewController.swift
//  Apple_Weather_App
//
//  Created by Minju Lee on 2022/02/08.
//

import UIKit
// UserDefaults sample
struct City: Codable {
    let name: String
    let latitude: Double
    let longitude: Double
}

class MainViewController: UIViewController {
    // UserDefaults sample
    var cities = [
        City(name: "서울특별시", latitude: 37.5478, longitude: 126.941893),
        City(name: "마포구", latitude: 37.5635, longitude: 126.9084),
        City(name: "천안시", latitude: 36.8151, longitude: 127.1137),
        City(name: "로스엔젤레스", latitude: 34.0533, longitude: -118.2423),
        City(name: "파리", latitude: 48.8571, longitude: 2.3529),
        City(name: "퀘벡", latitude: 53.2915896, longitude: -71.5164244)
    ]
    
    // MARK: - Properties
    
    private let toolbar = UIToolbar()
    
    private lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.currentPage = 0
        control.numberOfPages = 1
        control.setIndicatorImage(UIImage(systemName: "location.fill"), forPage: 0)
        control.addTarget(self, action: #selector(pageControlTapped), for: .valueChanged)
        return control
    }()
    
    private var locationIndex = 0
    
    private lazy var pageViewController: UIPageViewController = {
        let vc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        vc.dataSource = self
        vc.delegate = self
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        return vc
    }()
    
    private var weatherViewControllers: [WeatherViewController] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchWeather()
        // UserDefaults sample
//        // 저장
//        UserDefaults.standard.set(try? PropertyListEncoder().encode(self.cities), forKey: "cities")
//
//        // 불러오기
//        guard let data = UserDefaults.standard.value(forKey: "cities") as? Data,
//                  let cities2 = try? PropertyListDecoder().decode([City].self, from: data) else { return }
//        print(cities2)
//
//        // 삭제
//        cities.removeAll()
//        UserDefaults.standard.set(try? PropertyListEncoder().encode(self.cities), forKey: "cities")
//        guard let data = UserDefaults.standard.value(forKey: "cities") as? Data,
//              let cities2 = try? PropertyListDecoder().decode([City].self, from: data) else { return }
//        print(cities2)
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .blue
        
        navigationController?.isNavigationBarHidden = true
        navigationController?.isToolbarHidden = false
        navigationController?.toolbar.tintColor = .white
        navigationController?.toolbar.barStyle = .black
        navigationController?.toolbar.isTranslucent = true
        
        toolbarItems = [UIBarButtonItem(customView: pageControl)]
        
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        NSLayoutConstraint.activate([
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            pageViewController.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
    
    private func fetchWeather() {
        let cityName = "마포구"
        let latitude = 37.5635684
        let longitude = 126.9084249
        let weatherManager = WeatherManager(cityName: cityName, latitude: latitude, longitude: longitude)
        weatherManager.fetchWeather { [weak self] weather in
            let weather = weather
            let vc = WeatherViewController(weather: weather)
            self?.weatherViewControllers.append(vc)
            self?.pageControl.numberOfPages = self?.weatherViewControllers.count ?? 1
            guard let vc = self?.weatherViewControllers[0] else { return }
            self?.pageViewController.setViewControllers([vc], direction: .forward, animated: true, completion: nil)
        }
    }
    
    // MARK: - Actions
    
    @objc func pageControlTapped(_ sender: UIPageControl) {
        let nextPage = sender.currentPage
        var direction: UIPageViewController.NavigationDirection = .forward

        if locationIndex > nextPage {
            direction = .reverse
        }
        
        pageViewController.setViewControllers([weatherViewControllers[nextPage]], direction: direction, animated: true, completion: nil)
        
        locationIndex = nextPage
    }
}

// MARK: - UIPageViewControllerDataSource

extension MainViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? WeatherViewController,
              let index = weatherViewControllers.firstIndex(of: vc) else { return nil }
        let previousIndex = index - 1
        if previousIndex < 0 { return nil }

        return weatherViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? WeatherViewController,
              let index = weatherViewControllers.firstIndex(of: vc) else { return nil }
        let nextIndex = index + 1
        if nextIndex == weatherViewControllers.count { return nil }

        return weatherViewControllers[nextIndex]
    }
}

// MARK: - UIPageViewControllerDelegate

extension MainViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed,
              let vc = pageViewController.viewControllers?.first as? WeatherViewController,
              let index = weatherViewControllers.firstIndex(of: vc) else { return }
        
        pageControl.currentPage = index
        locationIndex = index
    }
}
