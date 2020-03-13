//
//  MainViewController.swift
//  CardGame
//
//  Created by Daniel Šuškevič on 2020-03-04.
//  Copyright © 2020 Daniel Šuškevič. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scoreLabel: UILabel!
    
    private let gradientLayer = CAGradientLayer()
    let config = CollectionViewLayoutConfig()
    private let checkMatchingCards = CheckMatchingCards()
    private var collectionViewFlowLayout: UICollectionViewFlowLayout!
    private var currentGameDifficulty: String = ""
    private let cellIdentifier = "CardCollectionViewCell"
    private var symbolsForGame: [String] = []
    private var cardsTappedCellArray: [CardCollectionViewCell] = []
    private var cardsTappedSymbolArray: [String] = []
    private var cardFontSize: CGFloat = 10.0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setBackground()
        loadCardSymbols()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkGameDifficulty()
        selectBackgroundColor()
        updateColelctionViewLayout()
        newGame()
    }
    
    // MARK: - Config
    
    private func checkGameDifficulty() {
        currentGameDifficulty = CardGameSettings.shared.checkDifficulty()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        let nib = UINib(nibName: "CardCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: cellIdentifier)
    }
    
    private func getCardFontSize() {
        cardFontSize = config.getSize()
    }
    
    private func updateColelctionViewLayout() {
        if currentGameDifficulty == "Easy" {
            collectionViewFlowLayout = config.configureLayout(for: collectionView, itemPerRow: 4, lineSpacing: 15, interItemSpacing: 15)
        } else if currentGameDifficulty == "Normal" {
            collectionViewFlowLayout = config.configureLayout(for: collectionView, itemPerRow: 4, lineSpacing: 15, interItemSpacing: 15)
        } else {
            collectionViewFlowLayout = config.configureLayout(for: collectionView, itemPerRow: 5, lineSpacing: 15, interItemSpacing: 15)
        }
        getCardFontSize()
    }
    
    private func loadCardSymbols() {
        symbolsForGame = CardSymbols.shared.getSymbols(difficulty: currentGameDifficulty)
    }
    
    private func newGame() {
        loadCardSymbols()
        GameScore.shared.clearScore()
        updateScoreLabel()
        for item in cardsTappedCellArray {
            configureCellDefaultState(cell: item)
        }
        collectionView.reloadData()
        cardsTappedCellArray = []
        cardsTappedSymbolArray = []
    }
    
    private func setBackground() {
        gradientLayer.frame = view.bounds
        gradientLayer.shouldRasterize = true
        gradientLayer.startPoint = CGPoint(x: 0, y: 0) // Top left corner.
        gradientLayer.endPoint = CGPoint(x: 1, y: 1) // Bottom right corner.
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func selectBackgroundColor() {
        if currentGameDifficulty == "Easy" {
            gradientLayer.colors = [#colorLiteral(red: 0, green: 0.5725490196, blue: 0.2705882353, alpha: 1).cgColor, #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1).cgColor]
        } else if currentGameDifficulty == "Normal" {
            gradientLayer.colors = [#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1).cgColor, #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1).cgColor]
        } else {
            gradientLayer.colors = [#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1).cgColor, #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).cgColor]
        }
    }
    
    private func updateScoreLabel() {
        scoreLabel.text = "Current Score: \(GameScore.shared.getCurrentScoreFor(difficulty: currentGameDifficulty))"
    }
    
    private func configureCellDefaultState(cell: CardCollectionViewCell) {
        cell.cellButton.setTitle("", for: .normal)
        cell.cellButton.isEnabled = true
        cell.cellButton.setBackgroundImage(CardGameSettings.shared.getCardBackImage(), for: .normal)
    }
    
    private func configureClickedCellState(cell: CardCollectionViewCell, for indexPath: IndexPath) {
        cell.cellButton?.titleLabel?.font =  .systemFont(ofSize: self.cardFontSize)
        cell.cellButton.setTitle(self.symbolsForGame[indexPath.item], for: .normal)
        cell.cellButton.setBackgroundImage(UIImage(), for: .normal)
        cell.cellButton.isEnabled = false
        cardsTappedCellArray.append(cell)
        cardsTappedSymbolArray.append(self.symbolsForGame[indexPath.item])
        matchTappedCards()
    }
    
    func checkForChanges() {
        if currentGameDifficulty != CardGameSettings.shared.checkDifficulty() {
            newGame()
        }
    }
    
    // MARK: - Card Check
    
    private func matchTappedCards() {
        switch currentGameDifficulty {
        case "Easy": // easy match 2 pairs
            if cardsTappedSymbolArray.count == 2 {
                let matchResult = checkMatchingCards.checkForMatch(cardsSymbolArray: cardsTappedSymbolArray)
                cardsTappedSymbolArray = [] // clear it, not needed after check
                checkTappedCardMatchResult(result: matchResult)
            }
        case "Normal": // normal match 3 pairs (triplets)
            if cardsTappedSymbolArray.count == 3 {
                let matchResult = checkMatchingCards.checkForMatch(cardsSymbolArray: cardsTappedSymbolArray)
                cardsTappedSymbolArray = [] // clear it, not needed after check
                checkTappedCardMatchResult(result: matchResult)
            }
        case "Hard": // hard match 4 pairs(quadralupet)
            if cardsTappedSymbolArray.count == 4 {
                let matchResult = checkMatchingCards.checkForMatch(cardsSymbolArray: cardsTappedSymbolArray)
                cardsTappedSymbolArray = [] // clear it, not needed after check
                checkTappedCardMatchResult(result: matchResult)
            }
        default:
            break
        }
    }
    
    private func checkTappedCardMatchResult(result: Bool) {
        if result == true { // cards match
            for item in cardsTappedCellArray {
                item.alpha = 0.4
            }
        } else {
            for item in cardsTappedCellArray {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.configureCellDefaultState(cell: item)
                }
            }
        }
        GameScore.shared.updateScoreFor(difficulty: currentGameDifficulty, by: result)
        updateScoreLabel()
        cardsTappedCellArray = [] // clear
    }
    
    // MARK: - Actions

    @IBAction func settingsButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "showSettings", sender: sender)
    }
    
    @IBAction func newGameButtonTapped(_ sender: UIButton) {
        newGame()
    }
}

// MARK: - CollectionView extension

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return symbolsForGame.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? CardCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        configureCellDefaultState(cell: cell)
        cell.buttonAction = { [unowned self] in
            self.configureClickedCellState(cell: cell, for: indexPath)
        }
        
        return cell
    }
}
