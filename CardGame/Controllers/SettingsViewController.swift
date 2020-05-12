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
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var highscoreLabel: UILabel!
    
    // MARK: - Variables
    
    let gameDifficulties = CardGameSettings.shared.getAllGameDifficulties()
    let cellIdentifier = "CardCollectionViewCell"
    weak var delegate: SettingsVCDelegate?
    private let gradientLayer = CAGradientLayer()
    private let collectionViewConfig = CollectionViewLayoutConfig()
    private let transparentView = UIView()
    private let tableView = UITableView()
    private var selectedButton = UIButton() // used later in animations
    private var selectedSkinCell = CardCollectionViewCell()

    // MARK: - Config
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
        setupTableView()
        setupCollectionView()
        checkGameDifficulty()
        updateColelctionViewLayout()
        updateHigscoreLabel()
    }
        
    private func setBackground() {
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [#colorLiteral(red: 0.7956927419, green: 0.4451861978, blue: 0.8532453179, alpha: 1).cgColor, #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1).cgColor]
        gradientLayer.shouldRasterize = true
        gradientLayer.startPoint = CGPoint(x: 0, y: 0) // Top left corner.
        gradientLayer.endPoint = CGPoint(x: 1, y: 1) // Bottom right corner.
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PickerTableViewCell.self, forCellReuseIdentifier: "pickerTableViewCell")
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        let nib = UINib(nibName: "CardCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: cellIdentifier)
    }
    
    private func updateColelctionViewLayout() {
        let collectionViewConfig = CollectionViewLayoutConfig()
        let items = CardGameSettings.shared.getCardSkinNames().count
        collectionViewConfig.configureLayout(for: collectionView, itemPerRow: CGFloat(items), lineSpacing: 5, interItemSpacing: 15)
    }
    
    private func updateHigscoreLabel() {
        highscoreLabel.text = "\(gameDifficulties[0]): \(GameScore.shared.getCurrentHighscoreFor(difficulty: gameDifficulties[0]))\n\(gameDifficulties[1]): \(GameScore.shared.getCurrentHighscoreFor(difficulty: gameDifficulties[1]))\n\(gameDifficulties[2]): \(GameScore.shared.getCurrentHighscoreFor(difficulty: gameDifficulties[2])) "
    }
    
    func checkGameDifficulty() {
        let currentGameDifficulty = CardGameSettings.shared.checkDifficulty()
        difficultyButton.setTitle(currentGameDifficulty, for: .normal)
    }
    
    // MARK: - CollectionView cell related
    
    func configureCellDefaultState(cell: CardCollectionViewCell, skinName: String) {
        cell.cellButton.setTitle("", for: .normal)
        cell.cellButton.isEnabled = true
        guard let image = UIImage(named: skinName) else {
            return
        }
        cell.cellButton.setBackgroundImage(image, for: .normal)
        if image == CardGameSettings.shared.getCardBackImage() {
            skinSelected(cell: cell)
        }
    }
    
    func skinSelected(cell: CardCollectionViewCell) {
        skinDeselected(cell: selectedSkinCell)
        guard let image = UIImage(named: "checkmark") else {
            return
        }
        cell.cellButton.setImage(image, for: .normal)
        cell.alpha = 0.7
        selectedSkinCell = cell
    }
    
    func skinDeselected(cell: CardCollectionViewCell) {
        if cell.cellButton != nil {
            cell.cellButton.setImage(UIImage(), for: .normal)
        }
        cell.alpha = 1
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
    
    @IBAction func clearHighscoreButtonTapped(_ sender: Any) {
        GameScore.shared.clearHighscore()
        updateHigscoreLabel()
    }
}
