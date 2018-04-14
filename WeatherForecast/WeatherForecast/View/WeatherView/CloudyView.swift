//
//  CloudyView.swift
//  WeatherForecast
//
//  Created by yangpc on 2018. 4. 13..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

class CloudyView: UIView {

    private let image: UIImage = UIImage.Background.Cloudy
    private var cloudyImageView: UIImageView?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initColor()
        cloudyImageView = makeClouds()
        addSubview(cloudyImageView ?? UIImageView())
        layoutClouds()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initColor()
        cloudyImageView = makeClouds()
        addSubview(cloudyImageView ?? UIImageView())
        layoutClouds()
    }

    private func initColor() {
        backgroundColor = UIColor.clear
    }

    private func makeClouds() -> UIImageView {
        let imageView = UIImageView(
            frame: CGRect(x: frame.width, y: 0, width: image.size.width, height: image.size.height)
        )
        imageView.image = image
        return imageView
    }

    private func layoutClouds() {
        guard let imageView = cloudyImageView else { return }
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.trailingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: image.size.width).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: image.size.height).isActive = true
        imageView.contentMode = .scaleToFill
    }

}

// MARK: - Interanl methods

extension CloudyView {

    func moveClouds() {
        UIView.animate(
            withDuration: 10,
            delay: 1,
            options: UIViewAnimationOptions.repeat,
            animations: { [weak self] in
                guard let `self` = self else { return }
                self.layoutIfNeeded()
            },
            completion: nil
        )
    }

}
