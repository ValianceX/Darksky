//
//  History.swift
//  Darksky
//
//  Created by Sydney Karimi on 11/12/20.
//

import Foundation

class History {
    struct Weather: Codable {
        let main: String
        let description: String
        let icon: String
    }
    struct Current: Codable {
        let temp: Float
        let weather: [Weather]
    }
    
    struct HistoryModel: Codable {
        let current: Current
    }
}
