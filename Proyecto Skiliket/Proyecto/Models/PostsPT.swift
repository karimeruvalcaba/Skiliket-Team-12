import Foundation

// MARK: - PostsPT
class PostsPT: Codable {
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
    }
}

enum PostsPTError: Error, LocalizedError {
    case notConnected
    case notDevice
}

extension PostsPT {
    static func fetchPostsPT() async throws -> [Posts] {

        let urls = [
            URL(string: "https://login-f0288-default-rtdb.firebaseio.com/postsgdl.json")!,
            URL(string: "https://login-f0288-default-rtdb.firebaseio.com/postsmty.json")!,
            URL(string: "https://login-f0288-default-rtdb.firebaseio.com/postscdmx.json")!,
            URL(string: "https://login-f0288-default-rtdb.firebaseio.com/poststoronto.json")!
        ]
        
        var postsList: [Posts] = []

        try await withThrowingTaskGroup(of: PostsPT.self) { group in
            for url in urls {
                group.addTask {
                    let (data, response) = try await URLSession.shared.data(from: url)
                    
                    guard let httpResponse = response as? HTTPURLResponse,
                          httpResponse.statusCode == 200 else {
                        throw PostsPTError.notConnected
                    }
                    
                    let jsonDecoder = JSONDecoder()
                    let postsPT = try jsonDecoder.decode(PostsPT.self, from: data)
                    return postsPT
                }
            }
            
            for try await postsPT in group {

                let parentPost = Posts(projectID: postsPT.projectID, projectName: postsPT.projectName, userPosts: postsPT.userPosts)
                
                for userPost in parentPost.userPosts {
                    userPost.parentPost = parentPost
                }
                
                postsList.append(parentPost)
            }
        }
        
        return postsList
    }
}
