import UIKit

class _35ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var projectID: Int?
    var projectName: String?
    var posts: [UserPost] = []
    var followedUsers = Set<String>()
    
    private var tableView: UITableView!
    private var postsList: [Posts] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        title = projectName ?? "Posts"

        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostCell")
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        Task {
            await fetchPosts()
        }
    }

    private func fetchPosts() async {
        do {
            let fetchedPostsList = try await PostsPT.fetchPostsPT()

            if let projectID = projectID {

                if let selectedProject = fetchedPostsList.first(where: { $0.projectID == projectID }) {
                    posts = selectedProject.userPosts
                    projectName = selectedProject.projectName
                }
            } else {

                postsList = fetchedPostsList
                posts = fetchedPostsList.flatMap { $0.userPosts }
            }

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("Failed to fetch posts: \(error)")
        }
    }

    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
        let post = posts[indexPath.row]
        
        let associatedProject = postsList.first(where: { $0.userPosts.contains { $0.postID == post.postID } })
        
        let projectNameForPost = associatedProject?.projectName ?? projectName!

        let isFollowed = followedUsers.contains(post.userID)

        cell.configure(with: post, projectName: projectNameForPost, isFollowed: isFollowed)

        cell.followButtonAction = { [weak self] in
            self?.toggleFollow(for: post.userID)
        }

        return cell
    }

    func toggleFollow(for userID: String) {
        if followedUsers.contains(userID) {
            followedUsers.remove(userID)
        } else {
            followedUsers.insert(userID)
        }
        tableView.reloadData()
    }

    // MARK: - Table view delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPost = posts[indexPath.row]

        let detailViewController = ThirteenViewController()
        detailViewController.post = selectedPost
        
        let associatedProject = postsList.first(where: { $0.userPosts.contains { $0.postID == selectedPost.postID } })
        detailViewController.projectName = associatedProject?.projectName ?? projectName

        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
