//
//  UsersPT.swift
//  Proyecto
//
//  Created by user264340 on 10/8/24.
//

import Foundation

// MARK: - UsersPT
class UsersPT: Codable {
    let users: Int

    init(users: Int) {
        self.users = users
    }

}

enum UsersPTError: Error, LocalizedError {
    case notConnected
    case notUsers
}

extension UsersPT {
    static func fetchUser(byEmail email: String) async throws -> User? {
        let urlComponents = URLComponents(string: "https://login-f0288-default-rtdb.firebaseio.com/users.json")!
        let (data, response) = try await URLSession.shared.data(from: urlComponents.url!)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw UsersPTError.notConnected
        }

        let jsonDecoder = JSONDecoder()
        let usersObject = try jsonDecoder.decode(Users.self, from: data)
        
        return usersObject.users.first { $0.email == email }
    }
}


