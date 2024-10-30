//
//  NetworkViewController.swift
//  Proyecto
//
//  Created by Usuario on 10/10/24.
//

import UIKit

class NetworkViewController: UIViewController {

    var selectedHost:Response = Response(connectedAPMACAddress: "", connectedAPName: "", connectedInterfaceName: "", connectedNetworkDeviceIPAddress: "", connectedNetworkDeviceName: "", hostIP: "", hostMAC: "", hostName: "", hostType: "", id: "", lastUpdated: "", pingStatus: "", vlanID: "")
    
    @IBOutlet weak var hostName: UILabel!
    
    @IBOutlet weak var hostIpAddress: UILabel!
    
    @IBOutlet weak var hostLocalization: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        hostName.text = selectedHost.hostName
        hostIpAddress.text = selectedHost.connectedInterfaceName
        hostLocalization.text = selectedHost.hostIP
    }
}

