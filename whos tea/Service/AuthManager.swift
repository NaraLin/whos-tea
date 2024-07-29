//
//  AuthManager.swift
//  whos tea
//
//  Created by 林靖芳 on 2024/7/27.
//

import Foundation
import FirebaseAuth

class AuthManager {
    
    static let shared = AuthManager()
    
    private init() {}
    
    func checkAuthStatus(completion: @escaping (Bool) -> Void) {
        
        if let currentUser = FirebaseAuth.Auth.auth().currentUser {
            
            let isGoogleSignIn = currentUser.providerID == "google.com"
            
            if isGoogleSignIn {
                
                completion(true)
                
            } else {
                
                if currentUser.isEmailVerified {
                    //已認證＆已登入
                    completion(true)
                }
                
                else {
                    
                    do{
                        //未認證，登出
                        try FirebaseAuth.Auth.auth().signOut()
                        completion(false)
                    }
                    catch{
                        //登出失敗
                        print("登出失敗：\(error.localizedDescription)")
                        completion(false)
                    }
                }
                
            }
        } else {
                //未登入
                completion(false)
        }
    }
    
}
