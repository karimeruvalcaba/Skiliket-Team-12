import UIKit

class ProjectsTableViewController: UITableViewController {

    var projectsList = [Project]()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableHeaderView()

        setupTableFooterView()

        Task {
            do {
                let projects = try await ProjectsPT.fetchProjectPT()
                self.updateGUI(projects: projects.projects)
            } catch {
                print("Fetch Projects failed with error: \(error.localizedDescription)")
            }
        }
    }

    private func setupTableHeaderView() {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        let headerLabel = UILabel(frame: CGRect(x: 20, y: 10, width: tableView.frame.width - 40, height: 30))
        headerLabel.text = "Select 5 minimum"
        headerLabel.textAlignment = .center
        headerLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        headerView.addSubview(headerLabel)
        tableView.tableHeaderView = headerView
    }

    private func setupTableFooterView() {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 120))

        let nextButton = UIButton(type: .system)
        nextButton.setTitle("Next", for: .normal)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.frame = CGRect(x: 20, y: 10, width: tableView.frame.width - 40, height: 40)
        nextButton.layer.cornerRadius = 20
        nextButton.clipsToBounds = true
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)

        addGradientToButton(nextButton)

        let skipButton = UIButton(type: .system)
        skipButton.setTitle("Skip", for: .normal)
        skipButton.setTitleColor(.white, for: .normal)
        skipButton.backgroundColor = .systemGray
        skipButton.layer.cornerRadius = 20
        skipButton.clipsToBounds = true
        skipButton.frame = CGRect(x: 20, y: 60, width: tableView.frame.width - 40, height: 40)
        skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)

        footerView.addSubview(nextButton)
        footerView.addSubview(skipButton)
        tableView.tableFooterView = footerView
    }

    private func addGradientToButton(_ button: UIButton) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = button.bounds
        gradientLayer.colors = [
            UIColor.systemPurple.cgColor,
            UIColor.systemBlue.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.cornerRadius = 20

        button.layer.insertSublayer(gradientLayer, at: 0)
    }

    @objc public func nextButtonTapped() {
        let selectedProjectsCount = projectsList.filter { $0.isChecked }.count
        
        if selectedProjectsCount < 5 {
            let alertController = UIAlertController(
                title: "Selection Error",
                message: "Please select at least 5 projects to proceed.",
                preferredStyle: .alert
            )
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            present(alertController, animated: true)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")

            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
        }
    }

    @objc private func skipButtonTapped() {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")

        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
    }

    func updateGUI(projects: [Project]) {
        Task { @MainActor in
            self.projectsList = projects
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projectsList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectTableViewCell", for: indexPath) as! ProjectTableViewCell
        let project = projectsList[indexPath.row]

        let attributedText = NSMutableAttributedString(
            string: "\(project.name)\n",
            attributes: [
                .font: UIFont.boldSystemFont(ofSize: 16)
            ]
        )

        let descriptionText = NSAttributedString(
            string: project.description,
            attributes: [
                .font: UIFont.systemFont(ofSize: 14),
                .foregroundColor: UIColor.darkGray
            ]
        )

        attributedText.append(descriptionText)

        cell.projectLabel.attributedText = attributedText

        cell.setIconsAndText(posts: project.communityInvolvement.posts, participants: project.communityInvolvement.participants)

        cell.isChecked = project.isChecked

        cell.checkboxButton.addTarget(self, action: #selector(checkboxTapped(_:)), for: .touchUpInside)
        cell.checkboxButton.tag = indexPath.row

        return cell
    }

    @objc func checkboxTapped(_ sender: UIButton) {
        let projectIndex = sender.tag
        projectsList[projectIndex].isChecked.toggle()

        tableView.reloadRows(at: [IndexPath(row: projectIndex, section: 0)], with: .none)
    }
}
