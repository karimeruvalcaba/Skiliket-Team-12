import UIKit

protocol EditProject2TableViewControllerDelegate: AnyObject {
    func didSelectProject(_ project: Project)
}

class EditProject2TableViewController: UITableViewController {
    
    var projectsList = [Project]()
    var selectedProjectIndex: IndexPath?
    weak var delegate: EditProject2TableViewControllerDelegate?

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
        headerLabel.text = "Select a project"
        headerLabel.textAlignment = .center
        headerLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        headerView.addSubview(headerLabel)
        tableView.tableHeaderView = headerView
    }

    private func setupTableFooterView() {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60))
        
        let nextButton = UIButton(type: .system)
        nextButton.setTitle("Next", for: .normal)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.frame = CGRect(x: 20, y: 10, width: tableView.frame.width - 40, height: 40)
        nextButton.layer.cornerRadius = 20
        nextButton.clipsToBounds = true
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        
        addGradientToButton(nextButton)
        
        footerView.addSubview(nextButton)
        tableView.tableFooterView = footerView
    }

    private func addGradientToButton(_ button: UIButton) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = button.bounds
        gradientLayer.colors = [UIColor.systemPurple.cgColor, UIColor.systemBlue.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.cornerRadius = 20

        button.layer.insertSublayer(gradientLayer, at: 0)
    }

    @objc private func nextButtonTapped() {
        if let selectedIndex = selectedProjectIndex {
            let selectedProject = projectsList[selectedIndex.row]
            delegate?.didSelectProject(selectedProject)
            navigationController?.popViewController(animated: true)
        }
    }

    func updateGUI(projects: [Project]) {
        Task { @MainActor in
            self.projectsList = projects
            self.tableView.reloadData()
        }
    }

    // MARK: - TableView DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projectsList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EditProject2TableViewCell", for: indexPath) as! EditProject2TableViewCell
        let project = projectsList[indexPath.row]
        
        cell.projectLabel.text = project.name
        cell.isChecked = (indexPath == selectedProjectIndex)
        
        return cell
    }

    // MARK: - TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedIndex = selectedProjectIndex, selectedIndex != indexPath {
            let previousCell = tableView.cellForRow(at: selectedIndex) as? EditProject2TableViewCell
            previousCell?.isChecked = false
        }

        let cell = tableView.cellForRow(at: indexPath) as? EditProject2TableViewCell
        cell?.isChecked = true
        selectedProjectIndex = indexPath
    }
}
