//
//  MainViewController.swift
//  Apple_Weather_App
//
//  Created by Minju Lee on 2022/02/08.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.currentPage = 0
        control.numberOfPages = UserDefaultsManager.cities.isEmpty ? 1 : UserDefaultsManager.cities.count
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
    
    private var cityWeatherList = [Weather]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchCityWeatherList()
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = dailySkyBlue
        
        navigationController?.isNavigationBarHidden = true
        navigationController?.isToolbarHidden = false
        navigationController?.toolbar.tintColor = .white
        navigationController?.toolbar.barStyle = .black
        navigationController?.toolbar.isTranslucent = true

        let mapButton = UIBarButtonItem(image: (UIImage(systemName: "map")), style: .plain, target: self, action: nil)
        
        let pageControlButton = UIBarButtonItem(customView: pageControl)
        
        let listButton = UIBarButtonItem(image: (UIImage(systemName: "list.bullet")), style: .plain, target: self, action: #selector(listButtonTapped))
       
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbarItems = [mapButton, space, pageControlButton, space, listButton]
        
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        NSLayoutConstraint.activate([
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30)
        ])
    }
    
    private func fetchCityWeatherList() {
        let weatherManager = WeatherManager()
        weatherManager.fetchCityWeatherList { [weak self] cityWeatherList in
            self?.cityWeatherList = cityWeatherList
            cityWeatherList.forEach {
                let vc = WeatherViewController(weather: $0)
                self?.weatherViewControllers.append(vc)
                guard let wvc = self?.weatherViewControllers.first else { return }
                self?.pageViewController.setViewControllers([wvc], direction: .forward, animated: true, completion: nil)
            }
        }
    }
    
    private func changeCurrentPage(index: Int) {
        pageControl.currentPage = index
        locationIndex = index
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
    
    @objc func listButtonTapped(_ sender: UIBarButtonItem) {
        let cwvc = CityWeatherListViewController()
        let vc = UINavigationController(rootViewController: cwvc)
        cwvc.delegate = self
        cwvc.cityWeatherList = cityWeatherList
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
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
        
        changeCurrentPage(index: index)
    }
}

// MARK: - CityWeatherListViewControllerDelegate

extension MainViewController: CityWeatherListViewControllerDelegate {
    func didSelectCity(cityWeatherList: [Weather], index: Int) {
        self.pageControl.numberOfPages = cityWeatherList.count
        self.cityWeatherList = cityWeatherList
        self.weatherViewControllers = []
        
        let dispatchGroup = DispatchGroup()
        cityWeatherList.forEach {
            dispatchGroup.enter()
            let vc = WeatherViewController(weather: $0)
            weatherViewControllers.append(vc)
            guard let wvc = weatherViewControllers.first else { return }
            pageViewController.setViewControllers([wvc], direction: .forward, animated: false, completion: nil)
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let wvcs = self?.weatherViewControllers[index] else { return }
            self?.pageViewController.setViewControllers([wvcs], direction: .forward, animated: false, completion: nil)
            self?.changeCurrentPage(index: index)
        }
    }
}
