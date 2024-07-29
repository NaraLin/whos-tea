//
//  RegisterViewModel.swift
//  whos tea
//
//  Created by 林靖芳 on 2024/7/27.
//

import Foundation
import FirebaseAuth

class RegisterViewModel {
    
    var name:String = ""
    var phone:String = ""
    var mail:String = ""
    var password:String = ""
    
    func register(completion: @escaping (Result<String, RegisterError>) -> Void) {
        
        guard !name.isEmpty,
              !phone.isEmpty,
              !password.isEmpty,
              !mail.isEmpty else {
            
            //註冊資訊未完整
            completion(.failure(.incompleteInformation))
            return
        }
        
        
        
        DatabaseManager.share.userExistsWithEmail(with: mail) { [weak self] exist in
            
            guard let strongSelf = self else {
                return
            }
            
            
            guard exist == false else{
                //用戶已存在
                completion(.failure(.userAlreadyExist))
                return
            }
            
            
            //用戶不存在，建立帳號
            FirebaseAuth.Auth.auth().createUser(withEmail: strongSelf.mail, password: strongSelf.password) { result, error in
                
                if let error {
                    completion(.failure(.registrationFailed(error.localizedDescription)))
                }
                
                guard let currentUser = FirebaseAuth.Auth.auth().currentUser else {
                    completion(.failure(.registrationFailed("無法獲取currentUser")))
                    return
                }
                
                currentUser.sendEmailVerification { error in
                    if let error {
                        completion(.failure(.registrationFailed(error.localizedDescription)))
                    }
                    
                    let uid = currentUser.uid
                    let user = User(name: strongSelf.name, phoneNumber: strongSelf.phone, emailAddress: strongSelf.mail, password: strongSelf.password, uid: uid)
                    
                    //建立帳號連接database
                    DatabaseManager.share.insertUser(with: user)
                    
                    //認證信發出alert
                    completion(.success("帳號申請成功"))
                    
                    //檢查認證，確認Mail有效性
                    if currentUser.isEmailVerified {
                        //登入成功
                        completion(.success(("登入成功")))
                        
                        //關掉登入畫面
                        
                    }
                    
                    else {
                        completion(.failure(.emailVertificationFailes))
                    }
                    
                    
                }
            }
        }
        
    }
}
