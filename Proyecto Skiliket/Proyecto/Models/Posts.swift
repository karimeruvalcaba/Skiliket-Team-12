//
//  Posts.swift
//  Projects
//
//  Created by user264340 on 10/1/24.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let posts = try? JSONDecoder().decode(Posts.self, from: jsonData)

import Foundation

// MARK: - Posts
class Posts: Codable {
    let projectID: Int
    let projectName: String
    var userPosts: [UserPost]

    enum CodingKeys: String, CodingKey {
        case projectID = "project_id"
        case projectName = "project_name"
        case userPosts = "user_posts"
    }

    init(projectID: Int, projectName: String, userPosts: [UserPost]) {
        self.projectID = projectID
        self.projectName = projectName
        self.userPosts = userPosts
        
        for userPost in self.userPosts {
            userPost.parentPost = self
        }
    }
}

// MARK: - UserPost
class UserPost: Codable {
    let comments: [Comment]
    let content: String
    let likes: Int
    let postDate: String
    let postID: Int
    let postURL: String
    let userID: String
    let userURL: String
    let username: String

    weak var parentPost: Posts?

    enum CodingKeys: String, CodingKey {
        case comments, content, likes
        case postDate = "post_date"
        case postID = "post_id"
        case postURL = "post_url"
        case userID = "user_id"
        case userURL = "user_url"
        case username
    }

    init(comments: [Comment], content: String, likes: Int, postDate: String, postID: Int, postURL: String, userID: String, userURL: String, username: String) {
        self.comments = comments
        self.content = content
        self.likes = likes
        self.postDate = postDate
        self.postID = postID
        self.postURL = postURL
        self.userID = userID
        self.userURL = userURL
        self.username = username
    }
}

// MARK: - Comment
class Comment: Codable {
    let commentDate: String
    let commentID: Int
    let content, userID: String
    let userURL: String
    let username: String

    enum CodingKeys: String, CodingKey {
        case commentDate = "comment_date"
        case commentID = "comment_id"
        case content
        case userID = "user_id"
        case userURL = "user_url"
        case username
    }

    init(commentDate: String, commentID: Int, content: String, userID: String, userURL: String, username: String) {
        self.commentDate = commentDate
        self.commentID = commentID
        self.content = content
        self.userID = userID
        self.userURL = userURL
        self.username = username
    }
}
