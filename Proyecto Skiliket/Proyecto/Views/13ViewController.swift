import UIKit

class ThirteenViewController: UIViewController {

    // MARK: - UI Elements
    let userProfileImageView = UIImageView()
    let usernameLabel = UILabel()
    let projectNameLabel = UILabel()
    let postDateLabel = UILabel()
    let postImageView = UIImageView()
    let contentTextView = UITextView()
    let likesLabel = UILabel()
    let commentsLabel = UILabel()
    let likeButton = UIButton(type: .system)
    let followButton = UIButton(type: .system)
    let commentsTableView = UITableView()

    let commentContainerView = UIView()
    let commentTextField = UITextField()
    let submitCommentButton = UIButton(type: .system)

    // MARK: - Variables
    var isLiked = false
    var likeCount: Int = 0
    var isFollowed = false
    var post: UserPost?
    var comments: [Comment] = []
    var projectName: String?

    private var commentContainerBottomConstraint: NSLayoutConstraint!
    private let currentUserID = UserDefaults.standard.string(forKey: "username") ?? "Unknown User"

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()


        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)


        if let userType = UserDefaults.standard.string(forKey: "userType"), userType == "guest" {
            likeButton.isHidden = true
            followButton.isHidden = true
            commentContainerView.isHidden = true
        }

        if let post = post {
            usernameLabel.text = post.username
            contentTextView.text = post.content
            contentTextView.sizeToFit()
            projectNameLabel.text = projectName ?? "Unknown Project"
            postDateLabel.text = post.postDate
            likeCount = post.likes
            likesLabel.text = "Likes: \(likeCount)"
            commentsLabel.text = "Comments: \(post.comments.count)"
            comments = post.comments

            loadImage(from: post.userURL, into: userProfileImageView)
            loadImage(from: post.postURL, into: postImageView)
            
            configureFollowButton(for: post)
        }

        commentsTableView.reloadData()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - UI Setup
    func setupUI() {
        view.addSubview(userProfileImageView)
        view.addSubview(usernameLabel)
        view.addSubview(projectNameLabel)
        view.addSubview(postDateLabel)
        view.addSubview(postImageView)
        view.addSubview(contentTextView)
        view.addSubview(likesLabel)
        view.addSubview(commentsLabel)
        view.addSubview(likeButton)
        view.addSubview(followButton)
        view.addSubview(commentsTableView)
        view.addSubview(commentContainerView)

        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        likeButton.tintColor = .gray
        likeButton.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)

        followButton.tintColor = .gray
        followButton.layer.cornerRadius = 15
        followButton.layer.borderWidth = 1
        followButton.layer.borderColor = UIColor.gray.cgColor
        followButton.addTarget(self, action: #selector(didTapFollowButton), for: .touchUpInside)

        commentTextField.placeholder = "Add a comment..."
        commentTextField.borderStyle = .roundedRect
        submitCommentButton.setTitle("Post", for: .normal)
        submitCommentButton.addTarget(self, action: #selector(didTapSubmitCommentButton), for: .touchUpInside)

        commentContainerView.addSubview(commentTextField)
        commentContainerView.addSubview(submitCommentButton)

        contentTextView.font = UIFont.systemFont(ofSize: 16)
        contentTextView.isEditable = false
        contentTextView.isScrollEnabled = false
        
        likesLabel.textColor = .gray
        commentsLabel.textColor = .gray
        projectNameLabel.textColor = .gray
        postDateLabel.textColor = .gray

        commentsTableView.delegate = self
        commentsTableView.dataSource = self
        commentsTableView.register(CommentTableViewCell.self, forCellReuseIdentifier: "CommentCell")

        setupConstraints()
    }

    func setupConstraints() {
        userProfileImageView.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        projectNameLabel.translatesAutoresizingMaskIntoConstraints = false
        postDateLabel.translatesAutoresizingMaskIntoConstraints = false
        postImageView.translatesAutoresizingMaskIntoConstraints = false
        contentTextView.translatesAutoresizingMaskIntoConstraints = false
        likesLabel.translatesAutoresizingMaskIntoConstraints = false
        commentsLabel.translatesAutoresizingMaskIntoConstraints = false
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        followButton.translatesAutoresizingMaskIntoConstraints = false
        commentsTableView.translatesAutoresizingMaskIntoConstraints = false
        commentContainerView.translatesAutoresizingMaskIntoConstraints = false
        commentTextField.translatesAutoresizingMaskIntoConstraints = false
        submitCommentButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            userProfileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            userProfileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            userProfileImageView.widthAnchor.constraint(equalToConstant: 50),
            userProfileImageView.heightAnchor.constraint(equalToConstant: 50),

            usernameLabel.centerYAnchor.constraint(equalTo: userProfileImageView.centerYAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: userProfileImageView.trailingAnchor, constant: 10),
            usernameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),

            postDateLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            postDateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            postDateLabel.widthAnchor.constraint(equalToConstant: 100),

            projectNameLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 2),
            projectNameLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
            projectNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),

            postImageView.topAnchor.constraint(equalTo: projectNameLabel.bottomAnchor, constant: 10),
            postImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            postImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            postImageView.heightAnchor.constraint(equalToConstant: 200),

            contentTextView.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 10),
            contentTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            contentTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),

            likeButton.topAnchor.constraint(equalTo: contentTextView.bottomAnchor, constant: 10),
            likeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            likeButton.widthAnchor.constraint(equalToConstant: 30),
            likeButton.heightAnchor.constraint(equalToConstant: 30),

            likesLabel.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
            likesLabel.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 10),

            followButton.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
            followButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            followButton.widthAnchor.constraint(equalToConstant: 30),
            followButton.heightAnchor.constraint(equalToConstant: 30),

            commentsLabel.centerYAnchor.constraint(equalTo: likesLabel.centerYAnchor),
            commentsLabel.leadingAnchor.constraint(equalTo: likesLabel.trailingAnchor, constant: 20),

            commentsTableView.topAnchor.constraint(equalTo: likeButton.bottomAnchor, constant: 10),
            commentsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            commentsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            commentsTableView.bottomAnchor.constraint(equalTo: commentContainerView.topAnchor),

            commentContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            commentContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            commentTextField.leadingAnchor.constraint(equalTo: commentContainerView.leadingAnchor, constant: 10),
            commentTextField.trailingAnchor.constraint(equalTo: submitCommentButton.leadingAnchor, constant: -10),
            commentTextField.centerYAnchor.constraint(equalTo: commentContainerView.centerYAnchor),
            submitCommentButton.trailingAnchor.constraint(equalTo: commentContainerView.trailingAnchor, constant: -10),
            submitCommentButton.centerYAnchor.constraint(equalTo: commentTextField.centerYAnchor),
            submitCommentButton.widthAnchor.constraint(equalToConstant: 50),

  
            commentContainerView.heightAnchor.constraint(equalToConstant: 50)
        ])


        commentContainerBottomConstraint = commentContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        commentContainerBottomConstraint.isActive = true
    }

    // MARK: - Follow Button Configuration
    func configureFollowButton(for post: UserPost) {
        if let userType = UserDefaults.standard.string(forKey: "userType"), userType == "guest" {
            followButton.isHidden = true
        } else if let currentUsername = UserDefaults.standard.string(forKey: "username"), currentUsername == post.username {
            followButton.isHidden = true
        } else {
            followButton.isHidden = false
            let followImage = UIImage(systemName: isFollowed ? "checkmark.circle.fill" : "plus.circle")
            followButton.setImage(followImage, for: .normal)
            followButton.tintColor = isFollowed ? .blue : .gray
        }
    }

    // MARK: - Actions
    @objc func didTapLikeButton() {
        isLiked.toggle()
        let heartImage = UIImage(systemName: isLiked ? "heart.fill" : "heart")
        likeButton.setImage(heartImage, for: .normal)
        likeButton.tintColor = isLiked ? .red : .gray
        likeCount += isLiked ? 1 : -1
        likesLabel.text = "Likes: \(likeCount)"
    }

    @objc func didTapFollowButton() {
        isFollowed.toggle()
        let followImage = UIImage(systemName: isFollowed ? "checkmark.circle.fill" : "plus.circle")
        followButton.setImage(followImage, for: .normal)
        followButton.tintColor = isFollowed ? .blue : .gray
    }

    @objc func didTapSubmitCommentButton() {
        guard let text = commentTextField.text, !text.isEmpty else { return }

        let username = UserDefaults.standard.string(forKey: "username") ?? "Anonymous"
        let userID = currentUserID
        let userURL = UserDefaults.standard.string(forKey: "userURL") ?? ""

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let commentDate = dateFormatter.string(from: Date())

        let newComment = Comment(
            commentDate: commentDate,
            commentID: (comments.last?.commentID ?? 0) + 1,
            content: text,
            userID: userID,
            userURL: userURL,
            username: username
        )

        comments.append(newComment)
        commentsTableView.reloadData()

        commentsLabel.text = "Comments: \(comments.count)"

        commentTextField.text = ""
        commentTextField.resignFirstResponder()
    }

    // MARK: - Delete Comment
    func deleteComment(at indexPath: IndexPath) {
        let comment = comments[indexPath.row]
        if comment.userID == currentUserID {
            comments.remove(at: indexPath.row)
            commentsTableView.deleteRows(at: [indexPath], with: .automatic)
            commentsLabel.text = "Comments: \(comments.count)"
        }
    }

    // MARK: - Keyboard Handling
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            let tabBarHeight = tabBarController?.tabBar.frame.height ?? 0


            commentContainerBottomConstraint.constant = -keyboardHeight + tabBarHeight

            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        commentContainerBottomConstraint.constant = 0
        commentsTableView.contentInset = .zero
        commentsTableView.scrollIndicatorInsets = .zero

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func loadImage(from urlString: String, into imageView: UIImageView) {
        guard let url = URL(string: urlString) else { return }
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    imageView.image = image
                }
            }
        }
    }
}


extension ThirteenViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as? CommentTableViewCell else {
            return UITableViewCell()
        }

        let comment = comments[indexPath.row]
        cell.configure(with: comment)
        
        return cell
    }

    // Enable swipe to delete for comments
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteComment(at: indexPath)
        }
    }
}
