//
//  Presentable.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 3. 27..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import SwiftMessages

protocol Presentable {
    func presentErrorMessage(message: String)
}

extension Presentable {
    func presentErrorMessage(message: String) {
        guard let messageView = try? MessageView.viewFromNib(layout: .statusLine) else { return }
        var config = SwiftMessages.Config()
        config.presentationStyle = .top
        config.presentationContext = .window(windowLevel: UIWindowLevelNormal)
        config.dimMode = .gray(interactive: true)
        config.preferredStatusBarStyle = .lightContent
        messageView.configureTheme(.error)
        messageView.configureContent(body: message)
        DispatchQueue.main.async {
            SwiftMessages.show(config: config, view: messageView)
        }
    }
}
