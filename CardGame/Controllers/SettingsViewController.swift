//
//  SettingsViewController.swift
//  CardGame
//
//  Created by Daniel Šuškevič on 2020-03-04.
//  Copyright © 2020 Daniel Šuškevič. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    private let gradientLayer = CAGradientLayer()
    private let gameDifficulties = ["Easy", "Normal", "Hard"]

    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
        setupPickerView()
        checkGameDifficulty()
    }
    
    // MARK: - Config
    
    func setBackground() {
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [#colorLiteral(red: 0.7956927419, green: 0.4451861978, blue: 0.8532453179, alpha: 1).cgColor, #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1).cgColor]
        gradientLayer.shouldRasterize = true
        gradientLayer.startPoint = CGPoint(x: 0, y: 0) // Top left corner.
        gradientLayer.endPoint = CGPoint(x: 1, y: 1) // Bottom right corner.
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setupPickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
     private func checkGameDifficulty() {
        let currentGameDifficulty = CardGameSettings.shared.checkDifficulty()
        guard let indexOfDifficulty = gameDifficulties.firstIndex(of: currentGameDifficulty) else {
            return
        }
        pickerView.selectRow(indexOfDifficulty, inComponent: 0, animated: true)
    }
}

// MARK: - PickerView Extension

extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return gameDifficulties.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return gameDifficulties[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        CardGameSettings.shared.setDifficulty(difficulty: gameDifficulties[row])
    }
}
