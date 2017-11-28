//
//  ViewController.swift
//  number-recognition-ios
//
//  Created by Masaya Hayashi on 2017/11/28.
//  Copyright © 2017年 Masaya Hayashi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var drawableView: DrawableView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var numberLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setBorder(view: drawableView)
        setBorder(view: imageView)
        setBorder(view: numberLabel)
    }

    private func setBorder(view: UIView) {
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1.0
    }

}

