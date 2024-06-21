//
//  DatabaseManager.swift
//  whos tea
//
//  Created by 林靖芳 on 2024/6/20.
//

import Foundation
import FirebaseDatabase

//使用final:不會被其他類別繼承，property & function不能被覆寫
final class DatabaseManager{
    
    static let share = DatabaseManager()
    
    private let database = Database.database().reference()
    

}

//Account Management
extension DatabaseManager {
    
    public func userExistsWithEmail(with email: String, 
                                    completion: @escaping ((Bool) -> Void)) {
        //(child:) Must be not contain '.' '#' '$' '[' or ']'
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
       // safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        //snapShot.value 得到數據，型別為any，需轉換型別使用
        database.child(safeEmail).observeSingleEvent(of: .value) { snapShot in
            guard let foundEmail = snapShot.value as? String else {
                completion(false)
                return
            }
            completion(true)
        }
        
    }
    
    
    //insert new user to database
    public func insertUser(with user: User){
        //insert databae: child(JSON)
        database.child(user.safeEmail).setValue([
            "name": user.name,
            "phoneNumber": user.phoneNumber,
            "password": user.password
        ])
    }
}


struct User {
    
    let name: String
    let phoneNumber: String
    let emailAddress: String
    let password: String
    
    var safeEmail: String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
      //  safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
}

