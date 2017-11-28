//
//  ViewController.swift
//  number-recognition-ios
//
//  Created by Masaya Hayashi on 2017/11/28.
//  Copyright © 2017年 Masaya Hayashi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var trainStatusLabel: UILabel!
    @IBOutlet private weak var drawableView: DrawableView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var numberLabel: UILabel!

    @IBAction func reload(_ sender: Any) {
        GetStatusService().request(URLSession.shared) { result in
            switch result {
            case .success(let res):
                self.setStatus(res.status)
            case .failure(let err):
                print(err)
            }
        }
    }

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

    func setStatus(_ status: TrainStatus) {
        trainStatusLabel.text = status.rawValue
    }

}

