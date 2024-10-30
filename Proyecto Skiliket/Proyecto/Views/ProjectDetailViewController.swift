import UIKit

extension UIFont {
    static func boldItalicSystemFont(ofSize fontSize: CGFloat) -> UIFont? {
        let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body)
            .withSymbolicTraits([.traitBold, .traitItalic])
        return descriptor.map { UIFont(descriptor: $0, size: fontSize) }
    }
}


class ProjectDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var projects: [Project] = []
    var topic: String = ""

    private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Projects"

        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ProjectDetailCell")
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        setupTableHeaderView()
    }

    private func setupTableHeaderView() {
        let headerView = UIView()
        
        let topicLabel = UILabel()
        topicLabel.text = topic
        topicLabel.font = UIFont.boldSystemFont(ofSize: 24)
        topicLabel.textAlignment = .center
        topicLabel.numberOfLines = 0
        topicLabel.translatesAutoresizingMaskIntoConstraints = false

        headerView.addSubview(topicLabel)

        NSLayoutConstraint.activate([
            topicLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            topicLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            topicLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 16),
            topicLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -16)
        ])

        let headerHeight = topicLabel.sizeThatFits(CGSize(width: tableView.frame.width - 32, height: CGFloat.greatestFiniteMagnitude)).height + 32
        
        headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: headerHeight)

        tableView.tableHeaderView = headerView
    }

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectDetailCell", for: indexPath)

        let project = projects[indexPath.row]

        cell.contentView.subviews.forEach { $0.removeFromSuperview() }

        let projectLabel = UILabel()
        projectLabel.numberOfLines = 0
        projectLabel.translatesAutoresizingMaskIntoConstraints = false

        let attributedText = NSMutableAttributedString(
            string: "\(project.name)\n", //
            attributes: [
                .font: UIFont.boldItalicSystemFont(ofSize: 16) ?? UIFont.systemFont(ofSize: 16)
            ]
        )

        let objectivesText = NSAttributedString(
            string: project.description, 
            attributes: [
                .font: UIFont.systemFont(ofSize: 14),
                .foregroundColor: UIColor.darkGray
            ]
        )

        attributedText.append(objectivesText)

        projectLabel.attributedText = attributedText

        let reportsIconUrl = "https://cdn-icons-png.flaticon.com/512/3887/3887601.png"
        let participantsIconUrl = "https://i.pinimg.com/474x/15/4f/1e/154f1ea2dead9d5794389515d99be2c0.jpg"
        
        let reportsIcon = createIconImageView(from: reportsIconUrl)
        let participantsIcon = createIconImageView(from: participantsIconUrl)

        let reportsLabel = UILabel()
        reportsLabel.text = "\(project.communityInvolvement.posts) Reports"
        reportsLabel.font = UIFont.systemFont(ofSize: 14)
        
        let participantsLabel = UILabel()
        participantsLabel.text = "\(project.communityInvolvement.participants) Participants"
        participantsLabel.font = UIFont.systemFont(ofSize: 14)

        let reportsStackView = UIStackView(arrangedSubviews: [reportsIcon, reportsLabel])
        reportsStackView.axis = .horizontal
        reportsStackView.spacing = 8
        reportsStackView.alignment = .center

        let participantsStackView = UIStackView(arrangedSubviews: [participantsIcon, participantsLabel])
        participantsStackView.axis = .horizontal
        participantsStackView.spacing = 8
        participantsStackView.alignment = .center

        let horizontalStackView = UIStackView(arrangedSubviews: [reportsStackView, participantsStackView])
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 16
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false

        cell.contentView.addSubview(projectLabel)
        cell.contentView.addSubview(horizontalStackView)

        NSLayoutConstraint.activate([
            projectLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
            projectLabel.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
            projectLabel.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 16),

            horizontalStackView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
            horizontalStackView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
            horizontalStackView.topAnchor.constraint(equalTo: projectLabel.bottomAnchor, constant: 16),
            horizontalStackView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -16)
        ])

        return cell
    }

    private func createIconImageView(from urlString: String) -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.contentMode = .scaleAspectFit

        guard let url = URL(string: urlString) else {
            imageView.image = UIImage(systemName: "photo")
            return imageView
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, error == nil {
                DispatchQueue.main.async {
                    imageView.image = UIImage(data: data)
                }
            } else {
                DispatchQueue.main.async {
                    imageView.image = UIImage(systemName: "photo")
                }
            }
        }
        task.resume()

        return imageView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedProject = projects[indexPath.row]

        let postsViewController = _35ViewController()
        postsViewController.projectID = selectedProject.id
        postsViewController.projectName = selectedProject.name

        navigationController?.pushViewController(postsViewController, animated: true)
    }
}
