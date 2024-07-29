//
//  Error.swift
//  whos tea
//
//  Created by 林靖芳 on 2024/7/26.
//

import Foundation


enum FirebaseError: Error{
    case unknownError(String)
    case signInFail(String)
}

enum RegisterError: Error{
    
    case incompleteInformation
    case userAlreadyExist
    case registrationFailed(String)
    case emailVertificationFailes
    
    var message:String {
        switch self {
            case .incompleteInformation:
                return "請輸入完整資訊"
            case .userAlreadyExist:
                return "用戶已存在"
            case .registrationFailed(let description):
                return "帳號申請失敗：\(description)"
            case .emailVertificationFailes:
                return "請至信箱收取認證信認證"
                
        }
        
    }
    
    
    
}
