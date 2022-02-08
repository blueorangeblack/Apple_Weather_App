//
//  MainViewController.swift
//  Apple_Weather_App
//
//  Created by Minju Lee on 2022/02/08.
//

import UIKit

class MainViewController: UIViewController {
    
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
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .orange
        
        navigationController?.isNavigationBarHidden = true
        navigationController?.isToolbarHidden = false
        navigationController?.toolbar.tintColor = .white
        navigationController?.toolbar.barStyle = .black
        navigationController?.toolbar.isTranslucent = true
        
        toolbarItems = [UIBarButtonItem(customView: pageControl)]
        
        let firstVC: WeatherViewController = {
            let vc = WeatherViewController(color: .red)
            return vc
        }()
        weatherViewControllers.append(firstVC)
        let secondVC: WeatherViewController = {
            let vc = WeatherViewController(color: .green)
            return vc
        }()
        weatherViewControllers.append(secondVC)
        let thirdVC: WeatherViewController = {
            let vc = WeatherViewController(color: .purple)
            return vc
        }()
        weatherViewControllers.append(thirdVC)
        
        pageControl.numberOfPages = weatherViewControllers.count
        
        pageViewController.setViewControllers([weatherViewControllers[2]], direction: .forward, animated: true, completion: nil)
        pageViewController.setViewControllers([weatherViewControllers[1]], direction: .forward, animated: true, completion: nil)
        pageViewController.setViewControllers([weatherViewControllers[0]], direction: .forward, animated: true, completion: nil)
        
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.view.frame = view.frame
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
