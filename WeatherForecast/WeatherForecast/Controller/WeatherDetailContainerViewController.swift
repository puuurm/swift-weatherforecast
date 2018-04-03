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

    var backButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.skyBlue
        addChildViewController(pageViewController)
        view.addSubview(pageViewController.view)
        backButton = createBackButton()
        createNavigationBarBackItem(button: backButton)

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
}

// 출처: https://github.com/Ramotion/preview-transition
extension WeatherDetailContainerViewController {

    private func createBackButton() -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 22, height: 44))
        button.setImage(UIImage(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(self.backButtonDidTap), for: .touchUpInside)
        return button
    }

    @discardableResult private func createNavigationBarBackItem(button: UIButton?) -> UIBarButtonItem? {
        guard let button = button else {
            return nil
        }
        let buttonItem = UIBarButtonItem(customView: button)
        navigationItem.leftBarButtonItem = buttonItem
        return buttonItem
    }
}

extension WeatherDetailContainerViewController {

    @objc func backButtonDidTap() {
        navigationController?.popViewController(animated: false)
    }
}
