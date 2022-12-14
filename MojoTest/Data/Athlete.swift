//
//  Athlete.swift
//  MojoTest
//
//  Created by Nano Anderson on 10/24/22.
//

import Foundation


struct Athlete {
    /// In some cases, this will represent "First name + all 'middle' names". E.g. when we have to manually parse a "Name" field that represents a full name. It will be `nil` in cases where we parse a "Name" field that only contains a single word
    let firstName: String?
    /// Not allowing lastName to be nil. This will cause empty names to throw an error
    let lastName: String
    let headShotUrl: String?
    let team: Team?
    let playingNow: Bool?
    
    // MARK: - Helpers
    
    /// Returns the Athlete's first character in their first name.
    /// If they are missing a first name, returns a blank string
    ///
    /// > Note: Does not include a "." (period) following the initial
    var firstInitial: String {
        return "\(firstName?.first ?? Character(""))"
    }
    
    var firstInitialWithPeriod: String {
        if firstInitial.count > 0 {
            return "\(firstInitial)."
        }
        else {
            return ""
        }
    }
    
    var fullName: String {
        return "\(firstName ?? "") \(lastName)".trimmingCharacters(in: .whitespaces)
    }
}

extension Athlete: Decodable {
    enum CodingKeys: String, CodingKey {
        case name
        case firstName
        case lastName
        case headShotUrl = "espnHeadshotUrl"
        case playingNow
        case team
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let fullName = try container.decodeIfPresent(String.self, forKey: .name) {
            let parsedNames = try Athlete.parsedNames(from: fullName)
            firstName = parsedNames.firstName
            lastName = parsedNames.lastName
        }
        else {
            firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
            lastName = try container.decodeIfPresent(String.self, forKey: .lastName)!
        }
        
        headShotUrl = try container.decodeIfPresent(String.self, forKey: .headShotUrl)
        playingNow =  try container.decodeIfPresent(Bool.self, forKey: .playingNow)
        team = try container.decodeIfPresent(Team.self, forKey: .team)
    }
}

extension Athlete {
    static func parsedNames(from name: String) throws -> (firstName: String, lastName: String) {
        let names = name.trimmingCharacters(in: .whitespaces).split(separator: " ")
        if names.count == 0 {
            throw AthleteError.runtimeError("No names found")
        }
        else if names.count == 1 {
            return ("", String(names.last!))
        }
        else {
            return (names[0..<names.count-1].joined(separator: " ").trimmingCharacters(in: .whitespaces), String(names.last!))
        }
    }
}

extension Athlete: Identifiable, Hashable {
    static func == (lhs: Athlete, rhs: Athlete) -> Bool {
        return lhs.fullName == rhs.fullName
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(fullName)
    }
    
    var id: String {
        return fullName
    }
}

enum AthleteError: Error {
    case runtimeError(String)
}
