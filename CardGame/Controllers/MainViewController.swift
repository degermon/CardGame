//
//  MainViewController.swift
//  CardGame
//
//  Created by Daniel Šuškevič on 2020-03-04.
//  Copyright © 2020 Daniel Šuškevič. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // - MARK: Actions

    @IBAction func settingsButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "showSettings", sender: sender)
    }
}
