//
//  WeatherDetailContainerViewController.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 2. 23..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

class WeatherDetailContainerViewController: UIViewController {

    var currentIndex: Int!

    private lazy var pageViewController: UIPageViewController = {
        return makepageViewController()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        addChildViewController(pageViewController)
        view.addSubview(pageViewController.view)
    }

    private func makepageViewController() -> UIPageViewController {
        let id = "PageViewController"
        guard let pageVC = storyboard?.instantiateViewController(
            withIdentifier: id
            ) as? UIPageViewController,
            let startVC = viewController(at: currentIndex) else {
                return UIPageViewController()
        }
        pageVC.dataSource = self
        pageVC.setViewControllers(
            [startVC],
            direction: .forward,
            animated: true,
            completion: nil
        )
        return pageVC
    }
}

extension WeatherDetailContainerViewController: UIPageViewControllerDataSource {

    func viewController (at index: Int?) -> WeatherDetailViewController? {
        let id = "WeatherDetailViewController"
        let index = index ?? 0
        guard let vc = storyboard?.instantiateViewController(
            withIdentifier: id
            ) as? WeatherDetailViewController else {
            return nil
        }
        let vm = History.shared.weatherDetailViewModel(at: index)
        vc.weatherDetailViewModel = vm
        vc.pageNumber = index
        return vc
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
        ) -> UIViewController? {
        guard let vc = viewController as? WeatherDetailViewController else { return nil }
        var index = vc.pageNumber ?? 0
        index -= 1
        if index < 0 || index == History.shared.count {
            return nil
        }
        return self.viewController(at: index)
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
        ) -> UIViewController? {

        guard let vc = viewController as? WeatherDetailViewController else { return nil }
        var index = vc.pageNumber ?? 0
        index += 1
        if index == History.shared.count {
            return nil
        }
        return self.viewController(at: index)
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return History.shared.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentIndex ?? 0
    }
}
