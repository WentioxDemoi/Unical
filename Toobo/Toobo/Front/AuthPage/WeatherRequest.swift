//
//  WeatherRequest.swift
//  Toobo
//
//  Created by Rémi Desbordes on 03/06/2024.
//

import Foundation

struct WeatherRequest: Codable {
    let token: String
    let latitude: Double
    let longitude: Double
}
