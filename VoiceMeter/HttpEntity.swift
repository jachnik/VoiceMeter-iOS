//
//  HttpEntity.swift
//  VoiceMeter
//
//  Created by Arkadiusz Jachnik on 28.12.2016.
//  Copyright © 2016 Arkadiusz Jachnik. All rights reserved.
//

import Foundation

protocol HttpEntity {
    func toData() -> Data
}
