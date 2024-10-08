//
//  timeIntervalExtension.swift
//  mp3_player
//
//  Created by Anna Bukreeva on 12.01.21.
//

import Foundation
import SwiftUI


extension TimeInterval{

        func stringFromTimeInterval() -> String {
            let time = NSInteger(self)
//            let ms = Int((self.truncatingRemainder(dividingBy: 1)) * 1000)
            let seconds = time % 60
            let minutes = (time / 60) % 60
            let hours = (time / 3600)

//            return String(format: "%0.2d:%0.2d:%0.2d.%0.3d",hours,minutes,seconds,ms)
            return String(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
        }
    }
