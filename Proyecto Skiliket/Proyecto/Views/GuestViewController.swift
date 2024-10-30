//
//  GuestViewController.swift
//  Proyecto
//
//  Created by Iñaki Odriozola on 14/10/24.
//

import UIKit

class GuestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
