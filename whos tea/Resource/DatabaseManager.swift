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
    
    
    
    //驗證是否user已存在
    public func userExistsWithEmail(with email: String,
                                    completion: @escaping ((Bool) -> Void)) {
        //(child:) Must be not contain '.' '#' '$' '[' or ']'
        let safeEmail = email.replacingOccurrences(of: ".", with: "-")

        //of: .value:當路徑下的任何資料發生變化時觸發
        database.child(safeEmail).observeSingleEvent(of: .value) { snapShot in
            
            let value = snapShot.value as? NSDictionary
            
            guard value != nil else {
                completion(false)
                return
            }
            //用戶已存在，執行true completion
            completion(true)
        }
    }
    
    
    //insert new user to database
    public func insertUser(with user: User){
        //insert databae: child(JSON)
        database.child(user.safeEmail).setValue([
            "name": user.name,
            "phoneNumber": user.phoneNumber,
            "password": user.password,
            "uid": user.uid
        ])
    }
}


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

