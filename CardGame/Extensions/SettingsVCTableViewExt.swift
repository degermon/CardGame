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
        return itemsToPopulatePickerTableView.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pickerTableViewCell", for: indexPath)
        cell.textLabel?.text = itemsToPopulatePickerTableView[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch selectedButton {
        case difficultyButton:
            let chosenDifficulty = itemsToPopulatePickerTableView[indexPath.row]
            UserDefaultsDataManager.shared.saveDifficulty(difficulty: chosenDifficulty)
            CardGameSettings.shared.setDifficulty(difficulty: chosenDifficulty)
            checkGameDifficulty()
        case timerButton:
            let chosenTimerSettings = itemsToPopulatePickerTableView[indexPath.row]
            if chosenTimerSettings == "Yes" {
                CardGameSettings.shared.setGameTimer(state: true)
            } else {
                CardGameSettings.shared.setGameTimer(state: false)
            }
            checkGameTimerState()
        default:
            break
        }
        delegate?.updateCards()
        removeTransparentView()
    }
}
