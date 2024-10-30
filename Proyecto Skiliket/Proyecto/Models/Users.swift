// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let users = try? JSONDecoder().decode(Users.self, from: jsonData)

import Foundation

// MARK: - Users
class Users: Codable {
    let users: [User]

    init(users: [User]) {
        self.users = users
    }
}

// MARK: - User
class User: Codable {
    let address: String
    let age: Int
    let city, country, email: String
    let followers: Int
    let following: [String]
    let userID, userType: String
    let userURL: String
    let username: String

    enum CodingKeys: String, CodingKey {
        case address, age, city, country, email, followers, following
        case userID = "user_id"
        case userType = "user_type"
        case userURL = "user_url"
        case username
    }

    init(address: String, age: Int, city: String, country: String, email: String, followers: Int, following: [String], userID: String, userType: String, userURL: String, username: String) {
        self.address = address
        self.age = age
        self.city = city
        self.country = country
        self.email = email
        self.followers = followers
        self.following = following
        self.userID = userID
        self.userType = userType
        self.userURL = userURL
        self.username = username
    }
}
