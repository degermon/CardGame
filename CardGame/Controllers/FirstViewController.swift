//
//  FirstViewController.swift
//  CardGame
//
//  Created by Daniel Šuškevič on 2020-05-12.
//  Copyright © 2020 Daniel Šuškevič. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var difficultyButton: UIButton!
    private let mainImageName = "cardsLogoWithBackground"

    override func viewDidLoad() {
        super.viewDidLoad()
        CardGameSettings.shared.checkDefaults()
        setMainImage()
        difficultySelected()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        displayDifficultyAlert()
    }
    
    // MARK: - Config
    
    private func setMainImage() {
        guard let image = UIImage(named: mainImageName) else {
            return
        }
        imageView.image = image
    }
    
    func difficultySelected() {
        let difficulty = CardGameSettings.shared.checkDifficulty()
        difficultyButton.setTitle(difficulty, for: .normal)
    }
    
    // MARK: - Actions
    
    @IBAction func difficultyButtonTapped(_ sender: Any) {
        displayDifficultyAlert()
    }
    
    @IBAction func playButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "play", sender: sender)
    }
}
