import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func guestButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
        
        UserDefaults.standard.set("", forKey: "userEmail")
        UserDefaults.standard.set("", forKey: "userAddress")
        UserDefaults.standard.set("", forKey: "userAge")
        UserDefaults.standard.set("", forKey: "username")
        UserDefaults.standard.set("", forKey: "userCity")
        UserDefaults.standard.set("", forKey: "userCountry")
        UserDefaults.standard.set(0, forKey: "userFollowers")
        UserDefaults.standard.set([], forKey: "userFollowing")
        UserDefaults.standard.set("guest", forKey: "userType")

        UserDefaults.standard.set("", forKey: "userURL")
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
    }
}
