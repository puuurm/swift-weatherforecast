//
//  MenuViewController.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 4. 23..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func closeButtonDidTap(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
