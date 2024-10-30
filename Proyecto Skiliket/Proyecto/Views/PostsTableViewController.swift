import UIKit

class PostsTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {

    var postsList = [Posts]()
    var projects: Projects?
    var userPostsList = [UserPost]()
    var filteredPostsList = [UserPost]()
    var searchFilteredPostsList = [UserPost]()
    var followedUsers = Set<String>()

    var originalSegmentedControl: UISegmentedControl!
    var searchSegmentedControl: UISegmentedControl!
    
    var searchController: UISearchController!
    var isSearching = false

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostCell")
        
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension

        configureSegmentedControls()
        configureSearchController()

        if let userFollowing = UserDefaults.standard.array(forKey: "userFollowing") as? [String] {
            followedUsers.formUnion(userFollowing)
        }

        Task {
            do {
                let fetchedPostsList = try await PostsPT.fetchPostsPT()
                let fetchedProjects = try await ProjectsPT.fetchProjectPT()
                self.updateGUI(postsList: fetchedPostsList, projects: fetchedProjects)
            } catch {
                print("Fetch failed with error: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Configure segmented controls
    func configureSegmentedControls() {
        originalSegmentedControl = UISegmentedControl(items: ["Global", "My Zone", "Following"])
        originalSegmentedControl.selectedSegmentIndex = 0
        originalSegmentedControl.addTarget(self, action: #selector(segmentedControlChanged(_:)), for: .valueChanged)

        let segmentedControlContainer = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        segmentedControlContainer.addSubview(originalSegmentedControl)
        originalSegmentedControl.frame = segmentedControlContainer.bounds

        tableView.tableHeaderView = segmentedControlContainer
    }

    // MARK: - Configure search controller
    func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search posts, projects, or profiles"
        searchController.searchBar.delegate = self

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        definesPresentationContext = true
    }

    // MARK: - Configure search segmented control (for when searching is active)
    func configureSearchSegmentedControl() {
        searchSegmentedControl = UISegmentedControl(items: ["Posts", "Projects", "Profiles"])
        searchSegmentedControl.selectedSegmentIndex = 0
        searchSegmentedControl.addTarget(self, action: #selector(searchSegmentedControlChanged(_:)), for: .valueChanged)

        let segmentedControlContainer = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        segmentedControlContainer.addSubview(searchSegmentedControl)
        searchSegmentedControl.frame = segmentedControlContainer.bounds

        tableView.tableHeaderView = segmentedControlContainer
    }

    // MARK: - Update the UI after fetching posts and projects
    func updateGUI(postsList: [Posts], projects: Projects) {
        Task { @MainActor in
            self.postsList = postsList
            self.projects = projects
            self.userPostsList = postsList.flatMap { $0.userPosts }
            self.filterPosts()
            tableView.reloadData()
        }
    }

    func filterPosts() {
        guard let projects = projects else { return }

        let userCity = UserDefaults.standard.string(forKey: "userCity") ?? ""
        let userType = UserDefaults.standard.string(forKey: "userType") ?? "default"

        if userType == "guest" {
            switch originalSegmentedControl.selectedSegmentIndex {
            case 0: // My Zone
                filteredPostsList = userPostsList
            case 1: // Global
                filteredPostsList = []
            case 2: // Following
                filteredPostsList = []
            default:
                break
            }
        } else {
            switch originalSegmentedControl.selectedSegmentIndex {
            case 0:
                filteredPostsList = userPostsList
            case 1:
                filteredPostsList = userPostsList.filter { userPost in
                    if let project = projects.projects.first(where: { $0.id == userPost.parentPost?.projectID }) {
                        return project.location.contains(where: { $0.city == userCity })
                    }
                    return false
                }
            case 2:
                filteredPostsList = userPostsList.filter { followedUsers.contains($0.userID) }
            default:
                break
            }
        }

        updateSearchResults(for: searchController)
    }

    // MARK: - UISearchResultsUpdating

    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            searchFilteredPostsList = filteredPostsList
            tableView.reloadData()
            if isSearching {
                isSearching = false
                tableView.tableHeaderView?.subviews.forEach { $0.removeFromSuperview() }
                configureSegmentedControls()
            }
            return
        }

        if (!isSearching) {
            isSearching = true
            tableView.tableHeaderView?.subviews.forEach { $0.removeFromSuperview() }
            configureSearchSegmentedControl()
        }

        switch searchSegmentedControl.selectedSegmentIndex {
        case 0:
            searchFilteredPostsList = filteredPostsList.filter { userPost in
                return userPost.content.lowercased().contains(searchText.lowercased())
            }
        case 1:
            searchFilteredPostsList = filteredPostsList.filter { userPost in
                guard let parentPost = userPost.parentPost else { return false }
                return parentPost.projectName.lowercased().contains(searchText.lowercased())
            }
        case 2:
            searchFilteredPostsList = filteredPostsList.filter { userPost in
                return userPost.username.lowercased().contains(searchText.lowercased())
            }
        default:
            break
        }

        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchFilteredPostsList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostTableViewCell else {
            fatalError("Unable to dequeue a PostTableViewCell")
        }
        let userPost = searchFilteredPostsList[indexPath.row]

        let projectName = userPost.parentPost?.projectName ?? "Unknown Project"

        let isFollowed = followedUsers.contains(userPost.userID)

        cell.configure(with: userPost, projectName: projectName, isFollowed: isFollowed)

        cell.followButtonAction = { [weak self] in
            self?.toggleFollow(for: userPost.userID)
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPost = searchFilteredPostsList[indexPath.row]

        let projectName = selectedPost.parentPost?.projectName ?? "Unknown Project"

        let detailVC = ThirteenViewController()
        detailVC.post = selectedPost
        detailVC.comments = selectedPost.comments
        detailVC.projectName = projectName

        navigationController?.pushViewController(detailVC, animated: true)
    }

    // MARK: - Segmented Control Actions

    @objc func segmentedControlChanged(_ sender: UISegmentedControl) {
        filterPosts()
    }

    @objc func searchSegmentedControlChanged(_ sender: UISegmentedControl) {
        updateSearchResults(for: searchController)
    }
}
