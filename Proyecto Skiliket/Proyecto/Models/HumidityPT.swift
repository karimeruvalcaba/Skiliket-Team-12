//
//  HumidityPT.swift
//  Proyecto
//
//  Created by Iñaki Odriozola on 16/10/24.
//

import Foundation

class HumidityPT: Codable {
    let humidity: Int

    init(humidity: Int) {
        self.humidity = humidity
    }

    enum CodingKeys: String, CodingKey {
        case humidity = "Humidity"
    }
}
