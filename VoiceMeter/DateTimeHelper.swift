//
//  DateTimeHelper.swift
//  VoiceMeter
//
//  Created by Arkadiusz Jachnik on 28.12.2016.
//  Copyright © 2016 Arkadiusz Jachnik. All rights reserved.
//

import Foundation

class DateTimeHelper {
    
    static func getTime() -> String {
        let date = NSDate()
        let calendar = NSCalendar.current
        let hour = calendar.component(.hour, from: date as Date)
        let minutes = calendar.component(.minute, from: date as Date)
        let seconds = calendar.component(.second, from: date as Date)
        return "\(hour):\(minutes):\(seconds)"
    }
}
