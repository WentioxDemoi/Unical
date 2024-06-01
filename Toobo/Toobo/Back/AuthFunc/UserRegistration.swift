//
//  UserRegistration.swift
//  Toobo
//
//  Created by Rémi Desbordes on 01/06/2024.
//

import Foundation

struct UserRegistration: Codable {
    let username: String
    let email: String
    let password: String
    let role: String
}
