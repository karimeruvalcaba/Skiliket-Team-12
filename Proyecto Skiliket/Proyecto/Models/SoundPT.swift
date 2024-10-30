//
//  SoundPT.swift
//  Proyecto
//
//  Created by Iñaki Odriozola on 16/10/24.
//

import Foundation

class SoundPT: Codable {
    let sound: Int

    init(sound: Int) {
        self.sound = sound
    }

    enum CodingKeys: String, CodingKey {
        case sound = "Sound"
    }
}
