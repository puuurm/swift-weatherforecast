//
//  SettingViewController.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 4. 26..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    private lazy var optionSwitchCellModel: [OptionSwitchCellModel] = {
        return [
            OptionSwitchCellModel(title: "온도 단위", items: ["℃", "℉"]),
            OptionSwitchCellModel(title: "풍속 단위", items: ["meter/s", "miles/h"])
        ]
    }()

    @IBOutlet weak var settingTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func closeButtonDidTap(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension SettingViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionSwitchCellModel.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: OptionSwitchCell? = tableView.dequeueReusableCell(for: indexPath)
        let model = optionSwitchCellModel[indexPath.row]
        cell?.setContents(cellModel: model)
        return cell ?? UITableViewCell()
    }

}

extension SettingViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height * 0.6 / CGFloat(optionSwitchCellModel.count)
    }
}
