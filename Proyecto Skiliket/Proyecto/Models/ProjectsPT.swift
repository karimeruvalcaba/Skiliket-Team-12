//
//  ProjectsPT.swift
//  Projects
//
//  Created by user264340 on 9/30/24.
//

import Foundation

// MARK: - TemperaturePT
class ProjectsPT: Codable {
    let device: Int

    init(device: Int) {
        self.device = device
    }

}

enum ProjectsPTError: Error, LocalizedError {
    case notConnected
    case notDevice
}

extension ProjectsPT {
    static func fetchProjectPT() async throws -> Projects {
        let urlComponents = URLComponents(string: "https://login-f0288-default-rtdb.firebaseio.com/projects.json")!
        let (data, response) = try await URLSession.shared.data(from: urlComponents.url!)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw ProjectsPTError.notConnected
        }

        let jsonDecoder = JSONDecoder()
        let devices = try jsonDecoder.decode(Projects.self, from: data)
        return devices
    }
}
