//
//  SettingViewController.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 4. 26..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet weak var settingTableView: UITableView!
    private var optionSwitchManager = OptionSwitchManager()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func closeButtonDidTap(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource

extension SettingViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionSwitchManager.numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: OptionSwitchCell? = tableView.dequeueReusableCell(for: indexPath)
        let model: OptionSwitchCellModel? = optionSwitchManager.cellModel(at: indexPath)
        let selectedValue: String = optionSwitchManager.switchValue(at: indexPath)
        cell?.setContents(cellModel: model, delegate: self)
        cell?.updateValue(selectedValue)
        return cell ?? UITableViewCell()
    }

}

// MARK: - UITableViewDelegate

extension SettingViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height * 0.5 / CGFloat(optionSwitchManager.numberOfRows)
    }
}

// MARK: - SegmentedSwitchDelegate

extension SettingViewController: SegmentedSwitchDelegate {

    func switchValueChanged(_ value: String) {
        optionSwitchManager.updateValue(value)
    }

}

struct OptionSwitchManager {

    private var optionSwitchCellModels: [OptionSwitchCellModel] = []
    private var userdefaultsKey: [UserDefaults.Unit.StringDefaultKey] = [.temperature, .windSpeed]

    init() {
        let models = [
            OptionSwitchCellModel(title: "온도 단위", dataSource: Unit.Temperature.allTypes),
            OptionSwitchCellModel(title: "풍속 단위", dataSource: Unit.WindSpeed.allTypes)
        ]
        optionSwitchCellModels.append(contentsOf: models)
    }

    func switchValue(at indexPath: IndexPath) -> String {
        let row: Int = indexPath.row
        let defaultValue: String = optionSwitchCellModels[row].dataSource[0]
        let userDefaultValue: String? = UserDefaults.Unit.string(forKey: userdefaultsKey[row])
        return userDefaultValue ?? defaultValue
    }

    func updateValue(_ value: String) {
        for i in 0..<optionSwitchCellModels.count
            where optionSwitchCellModels[i].dataSource.contains(value) {
                UserDefaults.Unit.set(value, forKey: userdefaultsKey[i])
                UserDefaults.Unit.synchronize()
                NotificationCenter.default.post(name: .DidUpdateUnit, object: self)
        }
    }

}

extension OptionSwitchManager: AvailableDataSource {

    var numberOfSections: Int {
        return 1
    }

    var numberOfRows: Int {
        return optionSwitchCellModels.count
    }

    func cellModel<T>(at indexPath: IndexPath) -> T? {
        return optionSwitchCellModels[indexPath.row] as? T
    }

}
