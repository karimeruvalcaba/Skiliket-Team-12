//
//  HostJSON.swift
//  Proyecto
//
//  Created by Iñaki Odriozola on 16/10/24.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
class Welcome: Codable {
    let response: [Response]
    let version: String

    init(response: [Response], version: String) {
        self.response = response
        self.version = version
    }
}
enum WelcomeError: Error, LocalizedError{
    case HostsNotFound
    case TokenGenerationError
}
// MARK: - Response
class Response: Codable {
    let connectedAPMACAddress, connectedAPName, connectedInterfaceName, connectedNetworkDeviceIPAddress: String
    let connectedNetworkDeviceName, hostIP, hostMAC, hostName: String
    let hostType, id, lastUpdated, pingStatus: String
    let vlanID: String?

    enum CodingKeys: String, CodingKey {
        case connectedAPMACAddress = "connectedAPMacAddress"
        case connectedAPName, connectedInterfaceName
        case connectedNetworkDeviceIPAddress = "connectedNetworkDeviceIpAddress"
        case connectedNetworkDeviceName
        case hostIP = "hostIp"
        case hostMAC = "hostMac"
        case hostName, hostType, id, lastUpdated, pingStatus
        case vlanID = "vlanId"
    }

    init(connectedAPMACAddress: String, connectedAPName: String, connectedInterfaceName: String, connectedNetworkDeviceIPAddress: String, connectedNetworkDeviceName: String, hostIP: String, hostMAC: String, hostName: String, hostType: String, id: String, lastUpdated: String, pingStatus: String, vlanID: String?) {
        self.connectedAPMACAddress = connectedAPMACAddress
        self.connectedAPName = connectedAPName
        self.connectedInterfaceName = connectedInterfaceName
        self.connectedNetworkDeviceIPAddress = connectedNetworkDeviceIPAddress
        self.connectedNetworkDeviceName = connectedNetworkDeviceName
        self.hostIP = hostIP
        self.hostMAC = hostMAC
        self.hostName = hostName
        self.hostType = hostType
        self.id = id
        self.lastUpdated = lastUpdated
        self.pingStatus = pingStatus
        self.vlanID = vlanID
    }
}

extension Welcome{
    static func getToken() async throws->String?{
        let url="http://localhost:58001/api/v1/ticket"
        var retorno="TokenError"
        let baseURL = URL(string: url)
        var request = URLRequest(url: baseURL!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let parametros: [String: String] = [
            "username": "cisco",
            "password": "cisco123!"
        ]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parametros, options: [])

            request.httpBody = jsonData

            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
                throw WelcomeError.TokenGenerationError
            }
            let ticketResponse = try? JSONDecoder().decode(TicketResponse.self, from: data)
            retorno = ticketResponse?.response.serviceTicket ?? "TokenError"
            
            return retorno

        } catch {
           print("Error al obtener token: \(error)")
        }
        return retorno
    }
    static func getHosts(token:String) async throws->[Response]{
        let url="http://localhost:58001/api/v1/host"
        let baseURL = URL(string: url)
        var request = URLRequest(url: baseURL!)
        request.addValue(token, forHTTPHeaderField: "X-Auth-Token")
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw WelcomeError.HostsNotFound
        }
        let welcomeInstance = try JSONDecoder().decode(Welcome.self, from: data)
        return welcomeInstance.response
        
    }
}
