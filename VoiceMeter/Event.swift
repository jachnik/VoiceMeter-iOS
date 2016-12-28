//
//  Event.swift
//  VoiceMeter
//
//  Created by Arkadiusz Jachnik on 28.12.2016.
//  Copyright © 2016 Arkadiusz Jachnik. All rights reserved.
//

import Foundation

class Event : HttpEntity {
    public private(set) var deviceIdentifier : String = ""
    public private(set) var voicePower : Int32 = 0
    
    init(deviceIdentifier: String, voicePower: Int32){
        var tmp = voicePower
        if tmp > 0 {
            tmp = 0
        }
        tmp = tmp + 160
        self.deviceIdentifier = deviceIdentifier
        self.voicePower = tmp
    }
    
    func toData() -> Data {
        let dict = ["deviceIdentifier": self.deviceIdentifier, "voicePower": self.voicePower] as [String : Any]
        return try! JSONSerialization.data(withJSONObject: dict)
    }
}
