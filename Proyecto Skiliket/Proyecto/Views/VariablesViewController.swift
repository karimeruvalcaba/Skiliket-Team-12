import UIKit

class VariablesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!

    var allVariableNames: Set<String> = []

    var selectedVariables: Set<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allVariableNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VariableCell", for: indexPath)
        let variableName = Array(allVariableNames)[indexPath.row]

        cell.textLabel?.text = variableName

        cell.accessoryType = selectedVariables.contains(variableName) ? .checkmark : .none
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let variableName = Array(allVariableNames)[indexPath.row]

        if selectedVariables.contains(variableName) {
            selectedVariables.remove(variableName)
        } else {
            selectedVariables.insert(variableName)
        }

        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

    @IBAction func doneButtonTapped(_ sender: UIButton) {
        NotificationCenter.default.post(name: Notification.Name("VariablesSelected"), object: selectedVariables)
        dismiss(animated: true, completion: nil)
    }
}
