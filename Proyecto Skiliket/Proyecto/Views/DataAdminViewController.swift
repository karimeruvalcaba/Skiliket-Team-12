//
//  DataAdminViewController.swift
//  Proyecto
//
//  Created by Usuario on 10/10/24.
//

import UIKit

class DataAdminViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func goToGraphs(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let graphsVC = storyboard.instantiateViewController(withIdentifier: "GraphsViewController") as? GraphsViewController {
            graphsVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(graphsVC, animated: true)
        }
    }
    
    @IBAction func goToNetwork(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let networkVC = storyboard.instantiateViewController(withIdentifier: "NetworkTableViewController") as? NetworkTableViewController {
            networkVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(networkVC, animated: true)
        }
    }

}
