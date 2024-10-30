import UIKit

class PostTableViewCell: UITableViewCell {
    
    // MARK: - UI Elements
    let userProfileImageView = UIImageView()
    let usernameLabel = UILabel()
    let projectNameLabel = UILabel()
    let postDateLabel = UILabel()
    let postImageView = UIImageView()
    let contentLabel = UILabel()
    let likesLabel = UILabel()
    let commentsLabel = UILabel()
    let likeButton = UIButton()
    let followButton = UIButton()
    
    var isLiked = false
    var likeCount: Int = 0
    var isFollowed = false
    
    var followButtonAction: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - UI Setup
    func setupUI() {
        userProfileImageView.contentMode = .scaleAspectFit
        postImageView.contentMode = .scaleAspectFill
        postImageView.clipsToBounds = true
        contentLabel.numberOfLines = 0
        
        projectNameLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
        projectNameLabel.textColor = .gray
        postDateLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        postDateLabel.textColor = .lightGray
        postDateLabel.textAlignment = .right
        likesLabel.font = UIFont.systemFont(ofSize: 14)
        likesLabel.textColor = .gray
        commentsLabel.font = UIFont.systemFont(ofSize: 14)
        commentsLabel.textColor = .gray

        let heartImage = UIImage(systemName: "heart")
        likeButton.setImage(heartImage, for: .normal)
        likeButton.tintColor = .gray
        likeButton.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)

        followButton.addTarget(self, action: #selector(didTapFollowButton), for: .touchUpInside)
        followButton.tintColor = .gray
        followButton.layer.cornerRadius = 15
        followButton.layer.borderWidth = 1
        followButton.layer.borderColor = UIColor.gray.cgColor
        
        contentView.addSubview(userProfileImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(projectNameLabel)
        contentView.addSubview(postDateLabel)
        contentView.addSubview(postImageView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(likesLabel)
        contentView.addSubview(commentsLabel)
        contentView.addSubview(likeButton)
        contentView.addSubview(followButton)

        userProfileImageView.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        projectNameLabel.translatesAutoresizingMaskIntoConstraints = false
        postDateLabel.translatesAutoresizingMaskIntoConstraints = false
        postImageView.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        likesLabel.translatesAutoresizingMaskIntoConstraints = false
        commentsLabel.translatesAutoresizingMaskIntoConstraints = false
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        followButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            userProfileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            userProfileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            userProfileImageView.widthAnchor.constraint(equalToConstant: 50),
            userProfileImageView.heightAnchor.constraint(equalToConstant: 50),
            
            usernameLabel.centerYAnchor.constraint(equalTo: userProfileImageView.centerYAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: userProfileImageView.trailingAnchor, constant: 10),
            usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            postDateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            postDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            postDateLabel.widthAnchor.constraint(equalToConstant: 100),
            
            projectNameLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 2),
            projectNameLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
            projectNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            postImageView.topAnchor.constraint(equalTo: projectNameLabel.bottomAnchor, constant: 10),
            postImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            postImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            postImageView.heightAnchor.constraint(equalToConstant: 200),
            
            contentLabel.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 10),
            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            likeButton.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 10),
            likeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            likeButton.widthAnchor.constraint(equalToConstant: 30),
            likeButton.heightAnchor.constraint(equalToConstant: 30),
            
            likesLabel.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
            likesLabel.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 10),
            
            commentsLabel.centerYAnchor.constraint(equalTo: likesLabel.centerYAnchor),
            commentsLabel.leadingAnchor.constraint(equalTo: likesLabel.trailingAnchor, constant: 20),
            commentsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

            followButton.centerYAnchor.constraint(equalTo: commentsLabel.centerYAnchor),
            followButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            followButton.widthAnchor.constraint(equalToConstant: 30),
            followButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    func configure(with userPost: UserPost, projectName: String, isFollowed: Bool) {
        usernameLabel.text = userPost.username
        contentLabel.text = userPost.content
        projectNameLabel.text = projectName
        postDateLabel.text = userPost.postDate
        likeCount = userPost.likes
        likesLabel.text = "Likes: \(likeCount)"
        commentsLabel.text = "Comments: \(userPost.comments.count)"
        self.isFollowed = isFollowed

        if let userType = UserDefaults.standard.string(forKey: "userType"), userType == "guest" {
            likeButton.isHidden = true
            followButton.isHidden = true
        } else {
            likeButton.isHidden = false

            if let currentUsername = UserDefaults.standard.string(forKey: "username"), currentUsername == userPost.username {
                followButton.isHidden = true
            } else {
                followButton.isHidden = false
                let followImage = UIImage(systemName: isFollowed ? "checkmark.circle.fill" : "plus.circle")
                followButton.setImage(followImage, for: .normal)
                followButton.tintColor = isFollowed ? .blue : .gray
            }
        }

        loadImage(from: userPost.userURL, into: userProfileImageView)
        loadImage(from: userPost.postURL, into: postImageView)
    }
    
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
        followButtonAction?()
    }
    
    func loadImage(from urlString: String, into imageView: UIImageView) {
        guard let url = URL(string: urlString) else { return }
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    imageView.image = image
                }
            }
        }
    }
}
