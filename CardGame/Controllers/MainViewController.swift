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
    
    private var currentGameDifficulty: Bool = false // false is easy, true is hard
    private let gradientLayer = CAGradientLayer()
    private var collectionViewFlowLayout: UICollectionViewFlowLayout!
    private let cellIdentifier = "CardCollectionViewCell"
    private var symbolsForGame: [String] = []
    private var cardFontSize: CGFloat = 10.0

    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        setBackground()
        loadCardSymbols()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        selectBackgroundColor()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupCollectionViewCardSize()
    }
    
    // MARK: - Config
    
    private func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        let nib = UINib(nibName: "CardCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: cellIdentifier)
    }
    
    private func setupCollectionViewCardSize() {
        if collectionViewFlowLayout == nil {
            let numberOfItemPerRow: CGFloat = 4
            let lineSpacing: CGFloat = 15
            let interCardSpacing: CGFloat = 15
            
            let width = (collectionView.frame.width - (numberOfItemPerRow - 1) * interCardSpacing) / numberOfItemPerRow
            let height = 1.5 * width
            cardFontSize = width - 10
            
            collectionViewFlowLayout = UICollectionViewFlowLayout()
            
            collectionViewFlowLayout.itemSize = CGSize(width: width, height: height)
            collectionViewFlowLayout.sectionInset = .zero
            collectionViewFlowLayout.scrollDirection = .vertical
            collectionViewFlowLayout.minimumLineSpacing = lineSpacing
            collectionViewFlowLayout.minimumInteritemSpacing = interCardSpacing
            
            collectionView.setCollectionViewLayout(collectionViewFlowLayout, animated: true)
        }
    }
    
    private func loadCardSymbols() {
        symbolsForGame = CardSymbols.shared.getSymbols(difficulty: currentGameDifficulty)
    }
    
    private func setBackground() {
        gradientLayer.frame = view.bounds
        gradientLayer.shouldRasterize = true
        gradientLayer.startPoint = CGPoint(x: 0, y: 0) // Top left corner.
        gradientLayer.endPoint = CGPoint(x: 1, y: 1) // Bottom right corner.
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func selectBackgroundColor() {
        if currentGameDifficulty == false {
            gradientLayer.colors = [#colorLiteral(red: 0, green: 0.5725490196, blue: 0.2705882353, alpha: 1).cgColor, #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1).cgColor]
        } else {
            gradientLayer.colors = [#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1).cgColor, #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).cgColor]
        }
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
    }
    
    // MARK: - Actions

    @IBAction func settingsButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "showSettings", sender: sender)
    }
    
    @IBAction func newGameButtonTapped(_ sender: Any) {
        collectionView.reloadData()
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
