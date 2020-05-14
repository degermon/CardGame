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
    @IBOutlet weak var highscoreLabel: UILabel!
    
    // MARK: - Variables
    
    let cellIdentifier = "CardCollectionViewCell"
    var symbolsForGame: [String] = []
    private let backgroundGradient = BackgroundGradient()
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
        checkGameDifficulty()
        setupCollectionView()
        loadCardSymbols()
        settingsChanged() // set/load all on first launch
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateHighcoreLabel()
        setupBackground()
    }
        
    private func checkGameDifficulty() {
        currentGameDifficulty = CardGameSettings.shared.checkDifficulty()
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
        updateHighcoreLabel()
        checkForGameEnd()
    }
    
    private func updateHighcoreLabel() {
        highscoreLabel.text = "Highscore: \(GameScore.shared.getCurrentHighscoreFor(difficulty: currentGameDifficulty))"
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
    
    // MARK: - Collection View setup
    
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
    
    // MARK: - Backround setup
    
    func setupBackground() {
        let colors = CardGameSettings.shared.getColorFor(difficulty: currentGameDifficulty)
        
        backgroundGradient.setBackground(for: backgroundView, color1: colors.0, color2: colors.1, animate: true)
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
