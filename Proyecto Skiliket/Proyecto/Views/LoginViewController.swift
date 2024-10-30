import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        EmailTextField.delegate = self
        PasswordTextField.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            self.view.frame.origin.y = -keyboardHeight / 2
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("Keyboard should appear for \(textField.placeholder ?? "")")
    }

    
    @IBAction func Login(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
        guard let email = EmailTextField.text, let password = PasswordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let e = error {
                print("Error: \(e.localizedDescription)")
                self?.showAlert(message:"E-mail or password is incorrect")
            } else {
                Task {
                    if let user = try? await UsersPT.fetchUser(byEmail: email) {
                        UserDefaults.standard.set(user.address, forKey: "userAddress")
                        UserDefaults.standard.set(user.age, forKey: "userAge")
                        UserDefaults.standard.set(user.city, forKey: "userCity")
                        UserDefaults.standard.set(user.country, forKey: "userCountry")
                        UserDefaults.standard.set(user.email, forKey: "userEmail")
                        UserDefaults.standard.set(user.followers, forKey: "userFollowers")
                        UserDefaults.standard.set(user.following, forKey: "userFollowing")
                        UserDefaults.standard.set(user.username, forKey: "username")
                        UserDefaults.standard.set(user.userURL, forKey: "userURL")
                        UserDefaults.standard.set(user.userType, forKey: "userType")
                        
                        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
                    } else {
                        print("User not found")
                        self?.showAlert(message:"User not found")
                    }
                }
            }
        }
    }
}
