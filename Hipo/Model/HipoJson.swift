//
//  HipoJson.swift
//  Hipo
//
//  Created by ahmet kardesseven on 22.04.2023.
//

import Foundation

struct HipoJson : Codable {
    let company : String!
    let team : String!
    var members : [Members]
    
    enum CodingKeys: String, CodingKey {
        
        case company = "company"
        case team = "team"
        case members = "members"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        company = try values.decodeIfPresent(String.self, forKey: .company)
        team = try values.decodeIfPresent(String.self, forKey: .team)
        members = try values.decodeIfPresent([Members].self, forKey: .members)!
    }
}

