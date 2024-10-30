import UIKit

class ThirtyThreeCollectionViewCell: UICollectionViewCell {

    var topicLabel: UILabel!
    var topicImageView: UIImageView!
    var participantsLabel: UILabel!
    var postsLabel: UILabel!

    var reportsIconImageView: UIImageView!
    var participantsIconImageView: UIImageView!
    
    var reportsLabel: UILabel!
    var participantsLabelWithIcon: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        topicLabel = UILabel()
        topicLabel.font = UIFont.boldSystemFont(ofSize: 16)
        topicLabel.numberOfLines = 0
        topicLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(topicLabel)

        topicImageView = UIImageView()
        topicImageView.contentMode = .scaleAspectFit
        topicImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(topicImageView)

        reportsLabel = UILabel()
        reportsLabel.font = UIFont.systemFont(ofSize: 8)
        reportsLabel.textColor = .darkGray

        participantsLabelWithIcon = UILabel()
        participantsLabelWithIcon.font = UIFont.systemFont(ofSize: 8)
        participantsLabelWithIcon.textColor = .darkGray

        reportsIconImageView = UIImageView()
        reportsIconImageView.contentMode = .scaleAspectFit
        reportsIconImageView.translatesAutoresizingMaskIntoConstraints = false
        reportsIconImageView.widthAnchor.constraint(equalToConstant: 8).isActive = true
        reportsIconImageView.heightAnchor.constraint(equalToConstant: 8).isActive = true

        participantsIconImageView = UIImageView()
        participantsIconImageView.contentMode = .scaleAspectFit
        participantsIconImageView.translatesAutoresizingMaskIntoConstraints = false
        participantsIconImageView.widthAnchor.constraint(equalToConstant: 8).isActive = true
        participantsIconImageView.heightAnchor.constraint(equalToConstant: 8).isActive = true

        let reportsStackView = UIStackView(arrangedSubviews: [reportsIconImageView, reportsLabel])
        reportsStackView.axis = .horizontal
        reportsStackView.spacing = 2
        reportsStackView.alignment = .center

        let participantsStackView = UIStackView(arrangedSubviews: [participantsIconImageView, participantsLabelWithIcon])
        participantsStackView.axis = .horizontal
        participantsStackView.spacing = 2
        participantsStackView.alignment = .center

        let iconsStackView = UIStackView(arrangedSubviews: [reportsStackView, participantsStackView])
        iconsStackView.axis = .horizontal
        iconsStackView.spacing = 2
        iconsStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(iconsStackView)

        NSLayoutConstraint.activate([
            topicLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            topicLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            topicLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),

            topicImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            topicImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            topicImageView.topAnchor.constraint(equalTo: topicLabel.bottomAnchor, constant: 8),
            topicImageView.heightAnchor.constraint(equalToConstant: 80), // Set the height of the image

            iconsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            iconsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            iconsStackView.topAnchor.constraint(equalTo: topicImageView.bottomAnchor, constant: 8),
            iconsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    func configure(topic: String, participants: Int, posts: Int, imageUrl: String) {
        topicLabel.text = topic
        participantsLabelWithIcon.text = "\(participants) Participants"
        reportsLabel.text = "\(posts) Reports"
        loadImage(from: imageUrl, into: topicImageView)

        loadImage(from: "https://cdn-icons-png.flaticon.com/512/3887/3887601.png", into: reportsIconImageView)
        loadImage(from: "https://i.pinimg.com/474x/15/4f/1e/154f1ea2dead9d5794389515d99be2c0.jpg", into: participantsIconImageView)
    }

    private func loadImage(from url: String, into imageView: UIImageView) {
        guard let imageURL = URL(string: url) else { return }
        let task = URLSession.shared.dataTask(with: imageURL) { data, response, error in
            if let data = data, error == nil {
                DispatchQueue.main.async {
                    imageView.image = UIImage(data: data)
                }
            }
        }
        task.resume()
    }
}
