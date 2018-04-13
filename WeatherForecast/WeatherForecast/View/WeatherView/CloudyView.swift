//
//  CloudyView.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 4. 13..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

class CloudyView: UIView {

    let image = UIImage.Background.Cloudy
    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 400, height: 400 * 0.6))

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        makeClouds()
        layoutClouds()
    }

    func makeClouds() {
        imageView.image = image
        addSubview(imageView)
    }

    func layoutClouds() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.trailingAnchor.constraint(equalTo: leadingAnchor, constant: -5).isActive = true
        imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 400).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.6).isActive = true
        imageView.contentMode = .scaleToFill
    }

    func moveClouds() {

        UIView.animate(
            withDuration: 10,
            delay: 1,
            options: UIViewAnimationOptions.repeat,
            animations: { [weak self] in
                guard let `self` = self else { return }
                self.imageView.frame.origin.x -= (self.frame.width+400)
        },
            completion: nil
        )
    }

}
