//
//  Humidity.swift
//  Proyecto
//
//  Created by Iñaki Odriozola on 16/10/24.
//

import Foundation

class Humidity: Identifiable {
    
    var value:String
    var timeStamp:Date
    
    init(value: String, timeStamp: Date) {
        self.value = value
        self.timeStamp = timeStamp
    }
}
