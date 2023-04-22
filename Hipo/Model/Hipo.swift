//
//  Hipo.swift
//  Hipo
//
//  Created by ahmet kardesseven on 22.04.2023.
//

import Foundation

struct Hipo : Codable {
    let position : String!
    let years_in_hipo : Int!
    
    enum CodingKeys: String, CodingKey {
        
        case position = "position"
        case years_in_hipo = "years_in_hipo"
    }
    
}
