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
    @IBOutlet private weak var confidenceLabel: UILabel!

    @IBAction func reload(_ sender: Any) {
        GetStatusService().request(URLSession.shared) { result in
            switch result {
            case .success(let res):
                DispatchQueue.main.async {
                    self.setStatus(res.status)
                }
            case .failure(let err):
                print(err)
            }
        }
    }

    @IBAction func clearButtonTapped(_ sender: Any) {
        drawableView.clear()
        imageView.image = nil
        numberLabel.text = "?"
        confidenceLabel.text = nil
    }

    @IBAction func recognizeButtonTapped(_ sender: Any) {
        removeBorder(view: drawableView)
        let image = drawableView.getResizedImage()
        imageView.image = image
        setBorder(view: drawableView)

        guard let rgbaData = image?.getPixels() else { return }
        var data = [UInt8]()
        for i in 0..<28*28 {
            let r = rgbaData[4 * i]
            let g = rgbaData[4 * i + 1]
            let b = rgbaData[4 * i + 2]
            let gray = UInt8((2 * Int(r) + 4 * Int(g) + Int(b)) / 7)
            data.append(gray)
        }

        RecognizeNumberService(data: data).request(URLSession.shared) { result in
            switch result {
            case .success(let res):
                DispatchQueue.main.async {
                    self.numberLabel.text = String(res.answer)
                    self.confidenceLabel.text = String(Double(res.confidence) * 100) + "%"
                }
            case .failure(let err):
                print(err)
                DispatchQueue.main.async {
                    self.numberLabel.text = "?"
                }
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

    private func removeBorder(view: UIView) {
        view.layer.borderColor = nil
        view.layer.borderWidth = 0.0
    }

    func setStatus(_ status: TrainStatus) {
        trainStatusLabel.text = status.rawValue
    }

}

