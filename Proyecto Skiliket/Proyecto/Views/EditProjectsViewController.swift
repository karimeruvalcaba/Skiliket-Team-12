import UIKit

class EditProjectsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource, EditProject2TableViewControllerDelegate {

    @IBOutlet weak var editProjectsScrollView: UIScrollView!
    
    @IBOutlet weak var selectProjectButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationPickerView: UIPickerView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var topicTextField: UITextField!
    @IBOutlet weak var targetGroupLabel: UILabel!
    @IBOutlet weak var targetGroupTable: UITableView!
    @IBOutlet weak var monitoredVariablesLabel: UILabel!
    @IBOutlet weak var monitoredVariablesTable: UITableView!
    @IBOutlet weak var challengesLabel: UILabel!
    @IBOutlet weak var challengesTable: UITableView!
    @IBOutlet weak var objectivesLabel: UILabel!
    @IBOutlet weak var objectivesTable: UITableView!
    @IBOutlet weak var solutionsLabel: UILabel!
    @IBOutlet weak var solutionsTable: UITableView!
    
    @IBOutlet weak var saveChangesButton: UIButton!
    
    var selectedProject: Project?

    var targetGroups: [String] = []
    var monitoredVariables: [String] = []
    var challenges: [String] = []
    var objectives: [String] = []
    var solutions: [String] = []

    let locations = ["Mexico City", "Monterrey", "Guadalajara", "Toronto"]

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()

        targetGroupTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        monitoredVariablesTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        challengesTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        objectivesTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        solutionsTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        adjustYPositions()
        lockScrollViewToVertical()

        locationPickerView.delegate = self
        locationPickerView.dataSource = self

        addBorderToTextView(descriptionTextView)
        setupTableViews()

        saveChangesButton.addTarget(self, action: #selector(saveChangesButtonTapped), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
            editProjectsScrollView.contentInset = contentInsets
            editProjectsScrollView.scrollIndicatorInsets = contentInsets
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        editProjectsScrollView.contentInset = contentInsets
        editProjectsScrollView.scrollIndicatorInsets = contentInsets
    }


    // MARK: - Setup Navigation Bar
    func setupNavigationBar() {
        self.title = "Edit Projects"
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func addButtonTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let newProjectVC = storyboard.instantiateViewController(withIdentifier: "NewProjectViewController") as? NewProjectViewController {
            navigationController?.pushViewController(newProjectVC, animated: true)
        }
    }

    @objc func saveChangesButtonTapped() {
        let alert = UIAlertController(title: "Success", message: "Changes saved", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }

    // MARK: - Add border to UITextView
    func addBorderToTextView(_ textView: UITextView) {
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 8.0
        textView.clipsToBounds = true
    }

    // MARK: - Adjust Y Positions
    func adjustYPositions() {
        let padding: CGFloat = 20
        var currentY: CGFloat = padding
        let scrollViewWidth = editProjectsScrollView.frame.width - 2 * padding

        selectProjectButton.frame = CGRect(x: padding, y: currentY, width: scrollViewWidth, height: selectProjectButton.frame.height)
        currentY += selectProjectButton.frame.height + padding
        
        nameLabel.frame = CGRect(x: padding, y: currentY, width: scrollViewWidth, height: nameLabel.frame.height)
        currentY += nameLabel.frame.height + 8
        
        nameTextField.frame = CGRect(x: padding, y: currentY, width: scrollViewWidth, height: nameTextField.frame.height)
        currentY += nameTextField.frame.height + padding

        locationLabel.frame = CGRect(x: padding, y: currentY, width: scrollViewWidth, height: locationLabel.frame.height)
        currentY += locationLabel.frame.height + 8
        
        locationPickerView.frame = CGRect(x: padding, y: currentY, width: scrollViewWidth, height: locationPickerView.frame.height)
        currentY += locationPickerView.frame.height + padding

        descriptionLabel.frame = CGRect(x: padding, y: currentY, width: scrollViewWidth, height: descriptionLabel.frame.height)
        currentY += descriptionLabel.frame.height + 8
        
        descriptionTextView.frame = CGRect(x: padding, y: currentY, width: scrollViewWidth, height: descriptionTextView.frame.height)
        currentY += descriptionTextView.frame.height + padding

        topicLabel.frame = CGRect(x: padding, y: currentY, width: scrollViewWidth, height: topicLabel.frame.height)
        currentY += topicLabel.frame.height + 8

        topicTextField.frame = CGRect(x: padding, y: currentY, width: scrollViewWidth, height: topicTextField.frame.height)
        currentY += topicTextField.frame.height + padding

        targetGroupLabel.frame = CGRect(x: padding, y: currentY, width: scrollViewWidth, height: targetGroupLabel.frame.height)
        currentY += targetGroupLabel.frame.height + 8

        targetGroupTable.frame = CGRect(x: padding, y: currentY, width: scrollViewWidth, height: targetGroupTable.frame.height)
        currentY += targetGroupTable.frame.height + padding

        monitoredVariablesLabel.frame = CGRect(x: padding, y: currentY, width: scrollViewWidth, height: monitoredVariablesLabel.frame.height)
        currentY += monitoredVariablesLabel.frame.height + 8

        monitoredVariablesTable.frame = CGRect(x: padding, y: currentY, width: scrollViewWidth, height: monitoredVariablesTable.frame.height)
        currentY += monitoredVariablesTable.frame.height + padding

        challengesLabel.frame = CGRect(x: padding, y: currentY, width: scrollViewWidth, height: challengesLabel.frame.height)
        currentY += challengesLabel.frame.height + 8

        challengesTable.frame = CGRect(x: padding, y: currentY, width: scrollViewWidth, height: challengesTable.frame.height)
        currentY += challengesTable.frame.height + padding

        objectivesLabel.frame = CGRect(x: padding, y: currentY, width: scrollViewWidth, height: objectivesLabel.frame.height)
        currentY += objectivesLabel.frame.height + 8

        objectivesTable.frame = CGRect(x: padding, y: currentY, width: scrollViewWidth, height: objectivesTable.frame.height)
        currentY += objectivesTable.frame.height + padding

        solutionsLabel.frame = CGRect(x: padding, y: currentY, width: scrollViewWidth, height: solutionsLabel.frame.height)
        currentY += solutionsLabel.frame.height + 8

        solutionsTable.frame = CGRect(x: padding, y: currentY, width: scrollViewWidth, height: solutionsTable.frame.height)
        currentY += solutionsTable.frame.height + padding
    }

    // MARK: - Lock Scroll View to Vertical Scrolling Only
    func lockScrollViewToVertical() {
        editProjectsScrollView.contentSize = CGSize(width: editProjectsScrollView.frame.width, height: solutionsTable.frame.maxY + 20)
        editProjectsScrollView.showsHorizontalScrollIndicator = false
        editProjectsScrollView.alwaysBounceHorizontal = false
    }

    // MARK: - Setup Table Views
    func setupTableViews() {
        targetGroupTable.delegate = self
        targetGroupTable.dataSource = self
        monitoredVariablesTable.delegate = self
        monitoredVariablesTable.dataSource = self
        challengesTable.delegate = self
        challengesTable.dataSource = self
        objectivesTable.delegate = self
        objectivesTable.dataSource = self
        solutionsTable.delegate = self
        solutionsTable.dataSource = self
    }

    // MARK: - Show Alert to Add Row
    func showAddItemAlert(for tableView: UITableView) {
        let alert = UIAlertController(title: "Add New Item", message: "Enter a new item", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "New item"
        }
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            if let text = alert.textFields?.first?.text, !text.isEmpty {
                self.addItem(to: tableView, item: text)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }

    // MARK: - Button Actions to Add Rows to Tables
    @objc func addTargetGroupTapped() {
        showAddItemAlert(for: targetGroupTable)
    }
    
    @objc func addMonitoredVariableTapped() {
        showAddItemAlert(for: monitoredVariablesTable)
    }
    
    @objc func addChallengeTapped() {
        showAddItemAlert(for: challengesTable)
    }
    
    @objc func addObjectiveTapped() {
        showAddItemAlert(for: objectivesTable)
    }
    
    @objc func addSolutionTapped() {
        showAddItemAlert(for: solutionsTable)
    }

    // MARK: - Add new row to table
    func addItem(to tableView: UITableView, item: String) {
        let formattedItem = item.replacingOccurrences(of: "_", with: " ").capitalized
        if tableView == targetGroupTable {
            targetGroups.append(formattedItem)
        } else if tableView == monitoredVariablesTable {
            monitoredVariables.append(formattedItem)
        } else if tableView == challengesTable {
            challenges.append(formattedItem)
        } else if tableView == objectivesTable {
            objectives.append(formattedItem)
        } else if tableView == solutionsTable {
            solutions.append(formattedItem)
        }
        tableView.reloadData()
    }

    // MARK: - UITableViewDelegate: Handle "+" button tap and swipe-to-delete
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemCount = tableView == targetGroupTable ? targetGroups.count : tableView == monitoredVariablesTable ? monitoredVariables.count : tableView == challengesTable ? challenges.count : tableView == objectivesTable ? objectives.count : solutions.count

        if indexPath.row == itemCount {
            if tableView == targetGroupTable {
                addTargetGroupTapped()
            } else if tableView == monitoredVariablesTable {
                addMonitoredVariableTapped()
            } else if tableView == challengesTable {
                addChallengeTapped()
            } else if tableView == objectivesTable {
                addObjectiveTapped()
            } else if tableView == solutionsTable {
                addSolutionTapped()
            }
        }
    }

    // MARK: - UITableViewDataSource: Required Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = tableView == targetGroupTable ? targetGroups.count : tableView == monitoredVariablesTable ? monitoredVariables.count : tableView == challengesTable ? challenges.count : tableView == objectivesTable ? objectives.count : solutions.count
        return count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == (tableView == targetGroupTable ? targetGroups.count : tableView == monitoredVariablesTable ? monitoredVariables.count : tableView == challengesTable ? challenges.count : tableView == objectivesTable ? objectives.count : solutions.count) {
            let addButtonCell = UITableViewCell(style: .default, reuseIdentifier: "addButtonCell")
            addButtonCell.textLabel?.text = "+"
            addButtonCell.textLabel?.textAlignment = .center
            addButtonCell.textLabel?.textColor = .systemBlue
            return addButtonCell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            if tableView == targetGroupTable {
                cell.textLabel?.text = targetGroups[indexPath.row].replacingOccurrences(of: "_", with: " ").capitalized
            } else if tableView == monitoredVariablesTable {
                cell.textLabel?.text = monitoredVariables[indexPath.row].replacingOccurrences(of: "_", with: " ").capitalized
            } else if tableView == challengesTable {
                cell.textLabel?.text = challenges[indexPath.row].replacingOccurrences(of: "_", with: " ").capitalized
            } else if tableView == objectivesTable {
                cell.textLabel?.text = objectives[indexPath.row].replacingOccurrences(of: "_", with: " ").capitalized
            } else if tableView == solutionsTable {
                cell.textLabel?.text = solutions[indexPath.row].replacingOccurrences(of: "_", with: " ").capitalized
            }
            return cell
        }
    }

    // MARK: - Swipe to delete rows
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let itemCount = tableView == targetGroupTable ? targetGroups.count : tableView == monitoredVariablesTable ? monitoredVariables.count : tableView == challengesTable ? challenges.count : tableView == objectivesTable ? objectives.count : solutions.count

        if indexPath.row == itemCount {
            return
        }

        if editingStyle == .delete {
            if tableView == targetGroupTable {
                targetGroups.remove(at: indexPath.row)
            } else if tableView == monitoredVariablesTable {
                monitoredVariables.remove(at: indexPath.row)
            } else if tableView == challengesTable {
                challenges.remove(at: indexPath.row)
            } else if tableView == objectivesTable {
                objectives.remove(at: indexPath.row)
            } else if tableView == solutionsTable {
                solutions.remove(at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    // MARK: - Populate initial data when a project is selected
    func didSelectProject(_ project: Project) {
        selectedProject = project
        
        nameTextField.text = project.name
        descriptionTextView.text = project.description
        topicTextField.text = project.topic

        if let location = project.location.first?.city, let index = locations.firstIndex(of: location) {
            locationPickerView.selectRow(index, inComponent: 0, animated: true)
        }

        targetGroups = project.communityInvolvement.targetGroups
        monitoredVariables = project.monitoredVariables
        challenges = project.challenges
        objectives = project.objectives
        solutions = project.solutions

        targetGroupTable.reloadData()
        monitoredVariablesTable.reloadData()
        challengesTable.reloadData()
        objectivesTable.reloadData()
        solutionsTable.reloadData()
    }

    // MARK: - UIPickerView DataSource & Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return locations.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return locations[row]
    }

    // MARK: - Button Action for Selecting Project
    @IBAction func selectProjectButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let editProject2VC = storyboard.instantiateViewController(withIdentifier: "EditProject2TableViewController") as? EditProject2TableViewController {
            editProject2VC.delegate = self
            navigationController?.pushViewController(editProject2VC, animated: true)
        }
    }
}
