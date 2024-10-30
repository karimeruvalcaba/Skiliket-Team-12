import UIKit

class ProjectTableViewCell: UITableViewCell {

    var checkboxButton: UIButton!
    var projectLabel: UILabel!
    var stackView: UIStackView!

    var isChecked: Bool = false {
        didSet {
            addGradientToCheckbox(isChecked: isChecked)
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCheckboxButton()
        setupProjectLabel()
        setupStackView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCheckboxButton()
        setupProjectLabel()
        setupStackView()
    }

    private func setupCheckboxButton() {
        checkboxButton = UIButton(type: .custom)
        checkboxButton.frame = CGRect(x: 15, y: 10, width: 30, height: 30)
        checkboxButton.layer.cornerRadius = 15
        checkboxButton.clipsToBounds = true
        checkboxButton.addTarget(self, action: #selector(toggleCheckbox), for: .touchUpInside)
        addGradientToCheckbox(isChecked: isChecked)
        contentView.addSubview(checkboxButton)
    }

    private func setupProjectLabel() {
        projectLabel = UILabel()
        projectLabel.font = UIFont.systemFont(ofSize: 16)
        projectLabel.numberOfLines = 0
        projectLabel.lineBreakMode = .byWordWrapping
        projectLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(projectLabel)

        NSLayoutConstraint.activate([
            projectLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 60),
            projectLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            projectLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10)
        ])
    }

    private func setupStackView() {
        let postsIcon = UIImageView()
        let participantsIcon = UIImageView()

        postsIcon.contentMode = .scaleAspectFit
        participantsIcon.contentMode = .scaleAspectFit
        postsIcon.translatesAutoresizingMaskIntoConstraints = false
        participantsIcon.translatesAutoresizingMaskIntoConstraints = false
        postsIcon.widthAnchor.constraint(equalToConstant: 24).isActive = true
        postsIcon.heightAnchor.constraint(equalToConstant: 24).isActive = true
        participantsIcon.widthAnchor.constraint(equalToConstant: 24).isActive = true
        participantsIcon.heightAnchor.constraint(equalToConstant: 24).isActive = true

        let postsLabel = UILabel()
        postsLabel.font = UIFont.systemFont(ofSize: 14)
        postsLabel.textColor = .darkGray

        let participantsLabel = UILabel()
        participantsLabel.font = UIFont.systemFont(ofSize: 14)
        participantsLabel.textColor = .darkGray

        stackView = UIStackView(arrangedSubviews: [postsIcon, postsLabel, participantsIcon, participantsLabel])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 60),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            stackView.topAnchor.constraint(equalTo: projectLabel.bottomAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
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

    func setIconsAndText(posts: Int, participants: Int) {
        (stackView.arrangedSubviews[1] as? UILabel)?.text = "\(posts) posts"
        (stackView.arrangedSubviews[3] as? UILabel)?.text = "\(participants) participants"

        loadImage(from: "https://icones.pro/wp-content/uploads/2022/01/icone-de-commentaire-et-de-retroaction-violet.png", into: stackView.arrangedSubviews[0] as! UIImageView)
        loadImage(from: "https://cdn-icons-png.flaticon.com/512/5087/5087579.png", into: stackView.arrangedSubviews[2] as! UIImageView)
    }

    @objc private func toggleCheckbox() {
        isChecked.toggle()
    }

    private func addGradientToCheckbox(isChecked: Bool) {
        checkboxButton.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = checkboxButton.bounds
        gradientLayer.cornerRadius = 15

        if isChecked {
            gradientLayer.colors = [
                UIColor.systemPurple.cgColor,
                UIColor.systemBlue.cgColor
            ]
        } else {
            gradientLayer.colors = [
                UIColor.lightGray.cgColor,
                UIColor.white.cgColor
            ]
        }

        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)

        checkboxButton.layer.insertSublayer(gradientLayer, at: 0)
    }
}
