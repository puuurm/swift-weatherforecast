//
//  ViewController.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 2. 7..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let dataManager = DataManager()
        dataManager.fetchForecastInfo(id: .korea) {
            (result) -> Void in
            switch result {
            case let .success(r) : print(r)
            case let .failure(error): print(error)
            }
        }
    }
}

