//
//  TicketResponse.swift
//  Proyecto
//
//  Created by Iñaki Odriozola on 16/10/24.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let ticketResponse = try? JSONDecoder().decode(TicketResponse.self, from: jsonData)

import Foundation

// MARK: - TicketResponse
class TicketResponse: Codable {
    let response: ResponsePTT
    let version: String

    init(response: ResponsePTT, version: String) {
        self.response = response
        self.version = version
    }
}

// MARK: - Response
class ResponsePTT: Codable {
    let idleTimeout: Int
    let serviceTicket: String
    let sessionTimeout: Int

    init(idleTimeout: Int, serviceTicket: String, sessionTimeout: Int) {
        self.idleTimeout = idleTimeout
        self.serviceTicket = serviceTicket
        self.sessionTimeout = sessionTimeout
    }
}
