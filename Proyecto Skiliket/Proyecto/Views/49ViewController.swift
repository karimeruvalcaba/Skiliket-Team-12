import UIKit

class FortyNineViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func goToNewPost(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let newPostVC = storyboard.instantiateViewController(withIdentifier: "NewPostViewController") as? NewPostViewController {
            newPostVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(newPostVC, animated: true)
        }
    }
    
    @IBAction func goToEditProjects(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let editProjectsVC = storyboard.instantiateViewController(withIdentifier: "EditProjectsViewController") as? EditProjectsViewController {
            editProjectsVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(editProjectsVC, animated: true)
        }
    }
}
