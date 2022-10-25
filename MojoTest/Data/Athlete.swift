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
}

extension Athlete: Decodable {
    
}
