//
//  TemperaturePT.swift
//  Proyecto
//
//  Created by Iñaki Odriozola on 16/10/24.
//

import Foundation

class TemperaturePT: Codable {
    let temperature: Int

    init(temperature: Int) {
        self.temperature = temperature
    }

    enum CodingKeys: String, CodingKey {
        case temperature = "Temperature"
    }
}
