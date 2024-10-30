import UIKit

class FortyFiveViewController: UIViewController {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!

    private let noPostsLabel: UILabel = {
        let label = UILabel()
        label.text = "Ooopss you haven't posted anything. Join the Conversation!"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var postsList = [Posts]()
    var userPostsList = [(UserPost, Int, String)]()
    var followedUsers = Set<String>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostCell")

        view.addSubview(noPostsLabel)
        NSLayoutConstraint.activate([
            noPostsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noPostsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noPostsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            noPostsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])

        noPostsLabel.isHidden = true

        displayUserInfo()
        fetchUserPosts()
    }
    
    private func displayUserInfo() {
        if let username = UserDefaults.standard.string(forKey: "username"),
           let userCity = UserDefaults.standard.string(forKey: "userCity"),
           let userFollowers = UserDefaults.standard.integer(forKey: "userFollowers") as Int?,
           let userFollowing = UserDefaults.standard.array(forKey: "userFollowing") as? [String],
           let userURL = UserDefaults.standard.string(forKey: "userURL") {

            usernameLabel.text = username
            cityLabel.text = userCity
            followersLabel.text = "\(userFollowers)"
            followingLabel.text = "\(userFollowing.count)"

            loadImage(from: userURL)
        } else {
            print("User data not found in UserDefaults.")
        }
    }

    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL string")
            return
        }

        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self.userImageView.image = UIImage(data: data)
                    self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width / 2
                    self.userImageView.clipsToBounds = true
                }
            } else {
                print("Failed to load image from URL")
            }
        }
    }

    private func fetchUserPosts() {
        Task {
            do {
                let fetchedPostsList = try await PostsPT.fetchPostsPT()

                self.userPostsList.removeAll()

                let username = UserDefaults.standard.string(forKey: "username")

                for posts in fetchedPostsList {
                    let userPosts = posts.userPosts.filter { $0.username == username }

                    for userPost in userPosts {
                        self.userPostsList.append((userPost, posts.projectID, posts.projectName))
                    }
                }

                DispatchQueue.main.async {
                    self.noPostsLabel.isHidden = !self.userPostsList.isEmpty
                    self.tableView.reloadData()
                }
            } catch {
                print("Failed to fetch user posts with error: \(error.localizedDescription)")
            }
        }
    }



}

extension FortyFiveViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userPostsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostTableViewCell else {
            fatalError("Unable to dequeue a PostTableViewCell")
        }

        let (userPost, projectID, projectName) = userPostsList[indexPath.row]

        let isFollowed = followedUsers.contains(userPost.userID)

        cell.configure(with: userPost, projectName: projectName, isFollowed: isFollowed)

        cell.followButtonAction = { [weak self] in
            self?.toggleFollow(for: userPost.userID)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let (selectedPost, _, projectName) = userPostsList[indexPath.row]

        let detailVC = ThirteenViewController()
        detailVC.post = selectedPost
        detailVC.comments = selectedPost.comments
        detailVC.projectName = projectName
 
        navigationController?.pushViewController(detailVC, animated: true)
    }

    func toggleFollow(for userID: String) {
        if followedUsers.contains(userID) {
            followedUsers.remove(userID)
        } else {
            followedUsers.insert(userID)
        }
        tableView.reloadData()
    }
}
