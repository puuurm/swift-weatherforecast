//
//  WeatherDetailContainerViewController.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 2. 23..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

enum Position {
    case left
    case right
}

class WeatherDetailContainerViewController: UIViewController {

    var currentIndex: Int!
    var backgroundImage: UIImage?
    private var backButton: UIButton?
    private var backgroundSettingButton: UIButton?

    private lazy var pageViewController: UIPageViewController = {
        return createPageViewController()
    }()

    private func createPageViewController() -> UIPageViewController {
        let pageVC: UIPageViewController? = storyboard?.viewController()
        if let startVC = viewController(at: currentIndex) {
            pageVC?.dataSource = self
            pageVC?.setViewControllers(
                [startVC],
                direction: .forward,
                animated: true,
                completion: nil
            )
        }
        return pageVC ?? UIPageViewController()
    }

    private func createButton(image: UIImage, action: Action) -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 22, height: 44))
        button.setImage(image, for: .normal)
        button.addTarget(action.target, action: action.selector, for: .touchUpInside)
        return button
    }

    @discardableResult private func createBarButtonItem(button: UIButton?, position: Position) -> UIBarButtonItem? {
        guard let button = button else { return nil }
        let barButtonItem = UIBarButtonItem(customView: button)
        if position == .left {
            navigationItem.leftBarButtonItem = barButtonItem
        } else {
            navigationItem.rightBarButtonItem = barButtonItem
        }
        return barButtonItem
    }

}

// MARK: - View Lifecycle

extension WeatherDetailContainerViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addChildViewController(pageViewController)
        view.addSubview(pageViewController.view)
        initBarButtonItem()
    }

}

// MARK: - Initializer

extension WeatherDetailContainerViewController {

    private func initBarButtonItem() {
        backButton = createButton(
            image: UIImage.Icons.Button.Back,
            action: Action(target: self, selector: #selector(self.backButtonDidTap))
        )
        backgroundSettingButton = createButton(
            image: UIImage.Icons.Button.BackgroundSetting,
            action: Action(target: self, selector: #selector(self.backgroundSettingButtonDidTap))
        )
        createBarButtonItem(button: backButton, position: .left)
        createBarButtonItem(button: backgroundSettingButton, position: .right)
    }
}

// MARK: - UIPageViewControllerDataSource

extension WeatherDetailContainerViewController: UIPageViewControllerDataSource {

    func viewController (at index: Int?) -> WeatherDetailViewController? {
        let index = index ?? 0
        let detailVC: WeatherDetailViewController? = storyboard?.viewController()
        let vm = History.shared.weatherDetailViewModel(at: index)
        detailVC?.weatherDetailViewModel = vm
        detailVC?.pageNumber = index
        detailVC?.backgroundImage = backgroundImage
        return detailVC
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

// MARK: - Action

extension WeatherDetailContainerViewController {

    @objc func backButtonDidTap() {
        navigationController?.popViewController(animated: false)
    }

    @objc func backgroundSettingButtonDidTap() {

    }
}
