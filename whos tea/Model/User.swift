//
//  User.swift
//  whos tea
//
//  Created by 林靖芳 on 2024/7/29.
//

import Foundation

struct User: Codable {
    
    let name: String
    let phoneNumber: String
    let emailAddress: String
    let password: String
    let uid: String
    
    var safeEmail: String {
        let safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
      
        return safeEmail
    }
    
}
