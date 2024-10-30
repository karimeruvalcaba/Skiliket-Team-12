//
//  UserDetailViewController.swift
//  Proyecto
//
//  Created by Usuario on 08/10/24.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var zoneTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var SignOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        userImageView.layer.cornerRadius = self.userImageView.frame.size.width / 2

        emailTextField.placeholder = UserDefaults.standard.string(forKey: "userEmail") ?? "Email not available"
        passwordTextField.placeholder = "Enter password"
        usernameTextField.placeholder = UserDefaults.standard.string(forKey: "username") ?? "Username not available"
        addressTextField.placeholder = UserDefaults.standard.string(forKey: "userAddress") ?? "Address not available"
        zoneTextField.placeholder = UserDefaults.standard.string(forKey: "userCity") ?? "City not available"
        
        if let userAge = UserDefaults.standard.integer(forKey: "userAge") as Int? {
            ageTextField.placeholder = "\(userAge)"
        } else {
            ageTextField.placeholder = "Age not available"
        }

        if let imageURLString = UserDefaults.standard.string(forKey: "userURL"), let imageURL = URL(string: imageURLString) {
            loadImage(from: imageURL)
        }
        
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

    private func loadImage(from url: URL) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.userImageView.image = image
                }
            }
        }
    }
    
    @IBAction func signOutTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let loginNavigationController = storyboard.instantiateViewController(withIdentifier: "LoginNavigationController") as? UINavigationController {
            UserDefaults.standard.removeObject(forKey: "userEmail")
            UserDefaults.standard.removeObject(forKey: "userAddress")
            UserDefaults.standard.removeObject(forKey: "userAge")
            UserDefaults.standard.removeObject(forKey: "userCity")
            UserDefaults.standard.removeObject(forKey: "userCountry")
            UserDefaults.standard.removeObject(forKey: "userFollowers")
            UserDefaults.standard.removeObject(forKey: "userFollowing")
            UserDefaults.standard.removeObject(forKey: "username")
            UserDefaults.standard.removeObject(forKey: "userURL")
            
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavigationController)
        } else {
            print("Error signing out")
        }
    }
}
