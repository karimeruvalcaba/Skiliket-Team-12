//
//  Projects.swift
//  Projects
//
//  Created by user264340 on 9/30/24.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let projects = try? JSONDecoder().decode(Projects.self, from: jsonData)

import Foundation

// MARK: - Projects
class Projects: Codable {
    let projects: [Project]

    init(projects: [Project]) {
        self.projects = projects
    }
}

// MARK: - Project
class Project: Codable {
    let challenges: [String]
    let communityInvolvement: CommunityInvolvement
    let description, endDate: String
    let id: Int
    let location: [Location]
    let monitoredVariables: [String]
    let name: String
    let objectives, solutions: [String]
    let startDate, status: String
    let technologiesUsed: TechnologiesUsed
    var isChecked: Bool
    let topic: String
    let urlTopic: String
    
    enum CodingKeys: String, CodingKey {
        case challenges
        case communityInvolvement = "community_involvement"
        case description
        case endDate = "end_date"
        case id, location
        case monitoredVariables = "monitored_variables"
        case name, objectives, solutions
        case startDate = "start_date"
        case status
        case technologiesUsed = "technologies_used"
        case topic
        case urlTopic = "url_topic"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.challenges = try container.decode([String].self, forKey: .challenges)
        self.communityInvolvement = try container.decode(CommunityInvolvement.self, forKey: .communityInvolvement)
        self.description = try container.decode(String.self, forKey: .description)
        self.endDate = try container.decode(String.self, forKey: .endDate)
        self.id = try container.decode(Int.self, forKey: .id)
        self.location = try container.decode([Location].self, forKey: .location)
        self.monitoredVariables = try container.decode([String].self, forKey: .monitoredVariables)
        self.name = try container.decode(String.self, forKey: .name)
        self.objectives = try container.decode([String].self, forKey: .objectives)
        self.solutions = try container.decode([String].self, forKey: .solutions)
        self.startDate = try container.decode(String.self, forKey: .startDate)
        self.status = try container.decode(String.self, forKey: .status)
        self.technologiesUsed = try container.decode(TechnologiesUsed.self, forKey: .technologiesUsed)
        self.topic = try container.decode(String.self, forKey: .topic)
                self.urlTopic = try container.decode(String.self, forKey: .urlTopic)
        self.isChecked = false
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(challenges, forKey: .challenges)
        try container.encode(communityInvolvement, forKey: .communityInvolvement)
        try container.encode(description, forKey: .description)
        try container.encode(endDate, forKey: .endDate)
        try container.encode(id, forKey: .id)
        try container.encode(location, forKey: .location)
        try container.encode(monitoredVariables, forKey: .monitoredVariables)
        try container.encode(name, forKey: .name)
        try container.encode(objectives, forKey: .objectives)
        try container.encode(solutions, forKey: .solutions)
        try container.encode(startDate, forKey: .startDate)
        try container.encode(status, forKey: .status)
        try container.encode(technologiesUsed, forKey: .technologiesUsed)
        try container.encode(topic, forKey: .topic)
        try container.encode(urlTopic, forKey: .urlTopic)
    }

    init(challenges: [String], communityInvolvement: CommunityInvolvement, description: String, endDate: String, id: Int, location: [Location], monitoredVariables: [String], name: String, objectives: [String], solutions: [String], startDate: String, status: String, technologiesUsed: TechnologiesUsed, topic: String, urlTopic: String, isChecked: Bool = false)  {
        self.challenges = challenges
        self.communityInvolvement = communityInvolvement
        self.description = description
        self.endDate = endDate
        self.id = id
        self.location = location
        self.monitoredVariables = monitoredVariables
        self.name = name
        self.objectives = objectives
        self.solutions = solutions
        self.startDate = startDate
        self.status = status
        self.technologiesUsed = technologiesUsed
        self.isChecked = isChecked
        self.topic = topic
        self.urlTopic = urlTopic
    }
}

// MARK: - CommunityInvolvement
class CommunityInvolvement: Codable {
    let participants, posts: Int
    let targetGroups: [String]

    enum CodingKeys: String, CodingKey {
        case participants
        case posts
        case targetGroups = "target_groups"
    }

    init(participants: Int, posts: Int, targetGroups: [String]) {
        self.participants = participants
        self.posts = posts
        self.targetGroups = targetGroups
    }
}


// MARK: - Location
class Location: Codable {
    let city: String
    let country: Country
    let devicesDeployed: Int

    enum CodingKeys: String, CodingKey {
        case city, country
        case devicesDeployed = "devices_deployed"
    }

    init(city: String, country: Country, devicesDeployed: Int) {
        self.city = city
        self.country = country
        self.devicesDeployed = devicesDeployed
    }
}

enum Country: String, Codable {
    case canadá = "Canadá"
    case méxico = "México"
}

// MARK: - TechnologiesUsed
class TechnologiesUsed: Codable {
    let ioTDevices, mobileApp, webPlatform, gisMapping: Bool?
    let drones, airQualitySensors, cameraTraps, droneSurveillance: Bool?
    let eLearningPlatform: Bool?

    enum CodingKeys: String, CodingKey {
        case ioTDevices = "IoT_devices"
        case mobileApp = "mobile_app"
        case webPlatform = "web_platform"
        case gisMapping = "GIS_mapping"
        case drones
        case airQualitySensors = "air_quality_sensors"
        case cameraTraps = "camera_traps"
        case droneSurveillance = "drone_surveillance"
        case eLearningPlatform = "e-learning_platform"
    }

    init(ioTDevices: Bool?, mobileApp: Bool?, webPlatform: Bool?, gisMapping: Bool?, drones: Bool?, airQualitySensors: Bool?, cameraTraps: Bool?, droneSurveillance: Bool?, eLearningPlatform: Bool?) {
        self.ioTDevices = ioTDevices
        self.mobileApp = mobileApp
        self.webPlatform = webPlatform
        self.gisMapping = gisMapping
        self.drones = drones
        self.airQualitySensors = airQualitySensors
        self.cameraTraps = cameraTraps
        self.droneSurveillance = droneSurveillance
        self.eLearningPlatform = eLearningPlatform
    }
}
