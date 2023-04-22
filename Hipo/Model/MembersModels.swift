//
//  MembersModels.swift
//  Hipo
//
//  Created by ahmet kardesseven on 19.04.2023.
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

struct Hipo : Codable {
    let position : String!
    let years_in_hipo : Int!
    
    enum CodingKeys: String, CodingKey {
        
        case position = "position"
        case years_in_hipo = "years_in_hipo"
    }
    
}
struct Repository : Codable {
    let name : String?
    let updatedAt : String?
    let stargazersCount : Int?
    let language : String?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case updatedAt = "updated_at"
        case stargazersCount = "stargazers_count"
        case language = "language"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        stargazersCount = try values.decodeIfPresent(Int.self, forKey: .stargazersCount)
        language = try values.decodeIfPresent(String.self, forKey: .language)
    }
    
}
