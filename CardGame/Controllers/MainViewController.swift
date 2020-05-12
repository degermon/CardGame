//
//  MainViewController.swift
//  CardGame
//
//  Created by Daniel Šuškevič on 2020-03-04.
//  Copyright © 2020 Daniel Šuškevič. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, SettingsVCDelegate {
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scoreLabel: UILabel!
    
    // MARK: - Variables
    
    let cellIdentifier = "CardCollectionViewCell"
    var symbolsForGame: [String] = []
    private let gradientLayer = CAGradientLayer()
    private let collectionViewConfig = CollectionViewLayoutConfig()
    private let checkMatchingCards = CheckMatchingCards()
    private var collectionViewFlowLayout: UICollectionViewFlowLayout!
    private var currentGameDifficulty: String = ""
    private var cardsTappedCellArray: [CardCollectionViewCell] = []
    private var cardsTappedSymbolArray: [String] = []
    private var cardFontSize: CGFloat = 10.0
    private var cardPairsMatched = 0

    // MARK: - Config
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setBackground()
        loadCardSymbols()
        checkGameDifficulty()
        settingsChanged() // set/load all on first launch
    }
        
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
        cardFontSize = collectionViewConfig.getSize()
    }
    
    private func updateColelctionViewLayout() {
        if currentGameDifficulty == "Easy" {
            collectionViewConfig.configureLayout(for: collectionView, itemPerRow: 4, lineSpacing: 15, interItemSpacing: 15)
        } else if currentGameDifficulty == "Normal" {
            collectionViewConfig.configureLayout(for: collectionView, itemPerRow: 4, lineSpacing: 15, interItemSpacing: 15)
        } else {
            collectionViewConfig.configureLayout(for: collectionView, itemPerRow: 5, lineSpacing: 15, interItemSpacing: 15)
        }
        getCardFontSize()
    }
    
    private func loadCardSymbols() {
        symbolsForGame = CardSymbols.shared.getSymbols(difficulty: currentGameDifficulty)
    }
    
    private func newGame() {
        resetCells()
        cardPairsMatched = 0
        GameScore.shared.clearScore()
        updateScoreLabel()
        collectionView.reloadData()
        cardsTappedCellArray = []
        cardsTappedSymbolArray = []
    }
    
    private func settingsChanged() {
        checkGameDifficulty()
        selectBackgroundColor()
        updateColelctionViewLayout()
        loadCardSymbols()
        newGame()
    }
    
    func updateCards() {
        settingsChanged()
    }
    
    func startNewGame() {
        newGame()
    }
    
    private func updateScoreLabel() {
        scoreLabel.text = "Current Score: \(GameScore.shared.getCurrentScoreFor(difficulty: currentGameDifficulty))"
        checkForGameEnd()
    }
    
    func checkForGameEnd() { //"Easy", "Normal", "Hard"
        switch currentGameDifficulty {
        case "Easy":
            if cardPairsMatched == 8 {
                showEndgameAlert()
            }
        case "Normal":
            if cardPairsMatched == 5 {
                showEndgameAlert()
            }
        case "Hard":
            if cardPairsMatched == 6 {
                showEndgameAlert()
            }
        default:
            break
        }
    }
    // MARK: - Backround setup
    
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
    
    // MARK: - CollectionVeiw Cell related
    
    func resetCells() {
        guard let cellArray = collectionView.visibleCells as? [CardCollectionViewCell] else { return }
        for cell in cellArray {
            configureCellDefaultState(cell: cell)
        } // return all cells to default state
    }
    
    func configureCellDefaultState(cell: CardCollectionViewCell) {
        cell.cellButton.setTitle("", for: .normal)
        cell.cellButton.isEnabled = true
        cell.cellButton.setBackgroundImage(CardGameSettings.shared.getCardBackImage(), for: .normal)
    }
    
    func configureClickedCellState(cell: CardCollectionViewCell, for indexPath: IndexPath) {
        cell.cellButton?.titleLabel?.font =  .systemFont(ofSize: self.cardFontSize)
        cell.cellButton.setTitle(self.symbolsForGame[indexPath.item], for: .normal)
        cell.cellButton.setBackgroundImage(UIImage(), for: .normal)
        cell.cellButton.isEnabled = false
        cardsTappedCellArray.append(cell)
        cardsTappedSymbolArray.append(self.symbolsForGame[indexPath.item])
        matchTappedCards()
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
            cardPairsMatched += 1
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
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SettingsViewController, let settingsVC = destination as SettingsViewController? {
            settingsVC.delegate = self
        }
    }
    
    // MARK: - Actions

    @IBAction func settingsButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "showSettings", sender: sender)
    }
    
    @IBAction func newGameButtonTapped(_ sender: UIButton) {
        newGame()
    }
}
