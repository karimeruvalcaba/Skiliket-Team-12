import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        if let items = tabBar.items {
            for item in items {
                item.image = item.image?.withRenderingMode(.alwaysOriginal)
                item.selectedImage = item.selectedImage?.withRenderingMode(.alwaysOriginal)
            }
        }
        
        let unselectedColor = UIColor.gray
        let selectedColor = UIColor.purple
        
        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: unselectedColor], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: selectedColor], for: .selected)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let userType = UserDefaults.standard.string(forKey: "userType") ?? ""
        
        if let navController = viewController as? UINavigationController,
           let rootVC = navController.viewControllers.first {
            
            if rootVC is DataSelectionViewController {
                handleDataSelectionRedirection()
                return false
            }
            
            if rootVC is NewPostSelectionViewController {
                handleNewPostSelectionRedirection()
                return false
            }
            
            if rootVC is FortyFiveViewController {
                if userType == "guest" {
                    userRedirection()
                    return false
                }
            }
        }
        return true
    }
    
    func handleDataSelectionRedirection() {
        let userType = UserDefaults.standard.string(forKey: "userType") ?? ""
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if userType == "admin" {
            if let dataAdminVC = storyboard.instantiateViewController(withIdentifier: "DataAdminViewController") as? UIViewController {
                dataAdminVC.hidesBottomBarWhenPushed = true
                let navController = self.selectedViewController as? UINavigationController
                navController?.setNavigationBarHidden(false, animated: false)
                navController?.pushViewController(dataAdminVC, animated: true)
            }
        } else {
            if let graphsVC = storyboard.instantiateViewController(withIdentifier: "GraphsViewController") as? UIViewController {
                graphsVC.hidesBottomBarWhenPushed = true
                let navController = self.selectedViewController as? UINavigationController
                navController?.setNavigationBarHidden(false, animated: false)
                navController?.pushViewController(graphsVC, animated: true)
            }
        }
    }
    
    func userRedirection() {
           let userType = UserDefaults.standard.string(forKey: "userType") ?? ""
           let storyboard = UIStoryboard(name: "Main", bundle: nil)
           
           if userType == "guest" {
               if let guestVC = storyboard.instantiateViewController(withIdentifier: "GuestViewController") as? UIViewController {
                   guestVC.hidesBottomBarWhenPushed = true
                   let navController = self.selectedViewController as? UINavigationController
                   navController?.setNavigationBarHidden(false, animated: false)
                   navController?.pushViewController(guestVC, animated: true)
               }
           }
       }

    func handleNewPostSelectionRedirection() {
        let userType = UserDefaults.standard.string(forKey: "userType") ?? ""
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if userType == "admin" {
            if let fortyNineVC = storyboard.instantiateViewController(withIdentifier: "FortyNineViewController") as? UIViewController {
                fortyNineVC.hidesBottomBarWhenPushed = true
                let navController = self.selectedViewController as? UINavigationController
                navController?.setNavigationBarHidden(false, animated: false)
                navController?.pushViewController(fortyNineVC, animated: true)
            }
        } else if userType == "guest" {
            if let guestVC = storyboard.instantiateViewController(withIdentifier: "GuestViewController") as? UIViewController {
                guestVC.hidesBottomBarWhenPushed = true
                let navController = self.selectedViewController as? UINavigationController
                navController?.setNavigationBarHidden(false, animated: false)
                navController?.pushViewController(guestVC, animated: true)
            }
        } else {
                if let newPostVC = storyboard.instantiateViewController(withIdentifier: "NewPostViewController") as? UIViewController {
                    newPostVC.hidesBottomBarWhenPushed = true
                    let navController = self.selectedViewController as? UINavigationController
                    navController?.setNavigationBarHidden(false, animated: false)
                    navController?.pushViewController(newPostVC, animated: true)
                }
            }
        }
    }
