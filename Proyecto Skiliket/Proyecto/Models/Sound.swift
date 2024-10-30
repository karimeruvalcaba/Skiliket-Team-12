//
//  Sound.swift
//  Proyecto
//
//  Created by Iñaki Odriozola on 16/10/24.
//

import Foundation

class Sound: Identifiable {
    
    var value:String
    var timeStamp:Date
    
    init(value: String, timeStamp: Date) {
        self.value = value
        self.timeStamp = timeStamp
    }
}
