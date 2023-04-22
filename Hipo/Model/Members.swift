//
//  Members.swift
//  Hipo
//
//  Created by ahmet kardesseven on 22.04.2023.
//

import Foundation

struct Members : Codable {
    var name : String!
    var github : String!
    var hipo : Hipo
    
    enum CodingKeys: String, CodingKey {
        
        case name = "name"
        case github = "github"
        case hipo = "hipo"
    }
}
