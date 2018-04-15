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
        view.backgroundColor = UIColor.skyBlue()
        addChildViewController(pageViewController)
        view.addSubview(pageViewController.view)
        backButton = createBackButton()
        createNavigationBarBackItem(button: backButton)

    }

    private func makepageViewController() -> UIPageViewController {
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
}

extension WeatherDetailContainerViewController: UIPageViewControllerDataSource {

    func viewController (at index: Int?) -> WeatherDetailViewController? {
        let index = index ?? 0
        let detailVC: WeatherDetailViewController? = storyboard?.viewController()
        let vm = History.shared.weatherDetailViewModel(at: index)
        detailVC?.weatherDetailViewModel = vm
        detailVC?.pageNumber = index
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

// MARK: - Reference https://github.com/Ramotion/preview-transition

extension WeatherDetailContainerViewController {

    private func createBackButton() -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 22, height: 44))
        button.setImage(UIImage.Icons.Button.Back, for: .normal)
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
