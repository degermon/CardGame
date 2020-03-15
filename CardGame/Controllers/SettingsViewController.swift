//
//  SettingsViewController.swift
//  CardGame
//
//  Created by Daniel Šuškevič on 2020-03-04.
//  Copyright © 2020 Daniel Šuškevič. All rights reserved.
//

import UIKit

protocol SettingsVCDelegate: class {
    func updateCards()
}

class SettingsViewController: UIViewController {
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var difficultyButton: UIButton!
    
    private let gradientLayer = CAGradientLayer()
    private let transparentView = UIView()
    private let tableView = UITableView()
    private var selectedButton = UIButton() // used later in animations
    private let gameDifficulties = ["Easy", "Normal", "Hard"]
    weak var delegate: SettingsVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
        setupTableView()
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
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PickerTableViewCell.self, forCellReuseIdentifier: "pickerTableViewCell")
    }
    
    private func checkGameDifficulty() {
        let currentGameDifficulty = CardGameSettings.shared.checkDifficulty()
        difficultyButton.setTitle(currentGameDifficulty, for: .normal)
    }
    
    // MARK: - DropDown Picker configuration
    
    func addTransparentView() { // add darked background and table view when it is called
        let frame = selectedButton.frame
        let window = UIApplication.shared.keyWindow // now using/supporting multiple scenes, so warning can be ignored
        transparentView.frame = window?.frame ?? self.view.frame
        self.view.addSubview(transparentView)
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        
        // table view setup
        tableView.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width + frame.height, height: 0)
        self.view.addSubview(tableView)
        tableView.layer.cornerRadius = 5
        tableView.isScrollEnabled = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView)) // when tapped on darker background call and remove it
        transparentView.addGestureRecognizer(tapGesture)
        
        transparentView.alpha = 0
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
            self.tableView.frame = CGRect(x: frame.origin.x, y: frame.origin.y + frame.height + 5, width: frame.width, height: CGFloat(self.gameDifficulties.count * 43))
        }, completion: nil) // added animation for better view
    }
    
    @objc func removeTransparentView() { // added animation for better view
        let frame = selectedButton.frame
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
            self.tableView.frame = CGRect(x: frame.origin.x, y: frame.origin.y + frame.height, width: frame.width, height: 0)
        }, completion: nil)
    }
    
    // MARK: - Actions
        
    @IBAction func difficultyButtonTapped(_ sender: Any) {
        selectedButton = difficultyButton
        addTransparentView()
    }
}

// MARK: - TableView Extension

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameDifficulties.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "pickerTableViewCell", for: indexPath)
        cell.textLabel?.text = gameDifficulties[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chosenDifficulty = gameDifficulties[indexPath.row]
        CardGameSettings.shared.setDifficulty(difficulty: chosenDifficulty)
        checkGameDifficulty()
        removeTransparentView()
        delegate?.updateCards()
    }
}
