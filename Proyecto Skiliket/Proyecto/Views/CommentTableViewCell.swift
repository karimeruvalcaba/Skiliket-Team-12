import UIKit

class CommentTableViewCell: UITableViewCell {
    
    // MARK: - UI Elements
    let userProfileImageView = UIImageView()
    let commentLabel = UILabel()
    let commentDateLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func setupUI() {

        userProfileImageView.contentMode = .scaleAspectFit
        userProfileImageView.layer.cornerRadius = 20
        userProfileImageView.clipsToBounds = true

        commentLabel.numberOfLines = 0
        commentLabel.font = UIFont.systemFont(ofSize: 14)

        commentDateLabel.font = UIFont.systemFont(ofSize: 12)
        commentDateLabel.textColor = .gray

        contentView.addSubview(userProfileImageView)
        contentView.addSubview(commentLabel)
        contentView.addSubview(commentDateLabel)

        userProfileImageView.translatesAutoresizingMaskIntoConstraints = false
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        commentDateLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            userProfileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            userProfileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            userProfileImageView.widthAnchor.constraint(equalToConstant: 40),
            userProfileImageView.heightAnchor.constraint(equalToConstant: 40),
            
            commentLabel.leadingAnchor.constraint(equalTo: userProfileImageView.trailingAnchor, constant: 10),
            commentLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            commentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            commentDateLabel.topAnchor.constraint(equalTo: commentLabel.bottomAnchor, constant: 5),
            commentDateLabel.leadingAnchor.constraint(equalTo: commentLabel.leadingAnchor),
            commentDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            commentDateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }

    func configure(with comment: Comment) {
        let attributedText = NSMutableAttributedString(
            string: "\(comment.username)\n",
            attributes: [.font: UIFont.boldSystemFont(ofSize: 14)]
        )
        let contentText = NSAttributedString(
            string: comment.content,
            attributes: [.font: UIFont.systemFont(ofSize: 14)]
        )
        attributedText.append(contentText)
        
        commentLabel.attributedText = attributedText
        commentDateLabel.text = comment.commentDate
        loadImage(from: comment.userURL, into: userProfileImageView)
    }

    private func loadImage(from urlString: String, into imageView: UIImageView) {
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
