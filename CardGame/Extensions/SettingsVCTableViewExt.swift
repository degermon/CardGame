//
//  SettingsVCTableViewExt.swift
//  CardGame
//
//  Created by Daniel Šuškevič on 2020-03-18.
//  Copyright © 2020 Daniel Šuškevič. All rights reserved.
//

import UIKit

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
