//
//  NetworkTableViewController.swift
//  Proyecto
//
//  Created by Iñaki Odriozola on 16/10/24.
//

import UIKit

class NetworkTableViewController: UITableViewController {
    var hosts:[Response] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Skiliket Network"

        Task {
            do {
                let tokenPTT = try await Welcome.getToken()
                let hostList = try await Welcome.getHosts(token: tokenPTT!)
                updateUI(with:hostList)
                
            } catch {
                displayError(WelcomeError.HostsNotFound, title: "Error al recuperar los hosts")
            }
        }
    }
    func updateUI(with hosts:[Response]) {
        DispatchQueue.main.async {
            self.hosts = hosts
            self.tableView.reloadData()
       }
    }
    func displayError(_ error: Error, title: String) {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hosts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HostIdentifier", for: indexPath)

        let host = hosts[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = "\(host.hostName) network:\(host.connectedNetworkDeviceName)"
        content.secondaryText = host.hostIP
        if host.pingStatus == "SUCCESS"{
            cell.backgroundColor = UIColor.green.withAlphaComponent(0.3)
        }
        else{
            cell.backgroundColor = UIColor.red.withAlphaComponent(0.3)
        }
        cell.contentConfiguration = content

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextView = segue.destination as! NetworkViewController
        let index = tableView.indexPathForSelectedRow
        let currentHost = hosts[index!.row]
        nextView.selectedHost = currentHost
    }
    

}
