//
//  TimerClass.swift
//  CardGame
//
//  Created by Daniel Šuškevič on 2020-05-19.
//  Copyright © 2020 Daniel Šuškevič. All rights reserved.
//

import UIKit

class TimerClass {
    
    private var timer: Timer?
    private var label: UILabel?
    private var timeLeft = 0

    func setTimerFor(time: Int, showResultIn: UILabel) {
        timeLeft = time
        label = showResultIn
    }
        
    func startTimer(finished: @escaping () -> ()) {
        if timeLeft > 0 {
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (_) in
                self.timeLeft -= 1
                self.label?.text = "\(self.timeLeft) seconds left"
                           
                if self.timeLeft <= 0 {
                    self.timer?.invalidate()
                    finished()
                }
            })
            timer?.tolerance = 0.1
            RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)
        }
    }
        
    func stopTimer() {
        timer?.invalidate()
    }
}
