//
//  LoginViewModel.swift
//  whos tea
//
//  Created by 林靖芳 on 2024/7/26.
//

import Foundation
import FirebaseAuth
import GoogleSignIn
import FirebaseCore

class LoginViewModel {
    
    func signInWithGoogle(presentingViewController: UIViewController, completion: @escaping (Result<User, FirebaseError>  ) -> Void){
        
        //google sign in setting
        //clientID: Firebase 提供的唯一識別碼，用於識別你的APP
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            completion(.failure(.unknownError("no client ID")))
            return
        }
        
        // 設定Google登入的配置
        //.sharedInstance 用來處理Google登入流程
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        //Google登入流程
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { result, error in
            
            //處理登入error
            guard error == nil else{
                completion(.failure(.signInFail(error?.localizedDescription ?? "unknown error")))
                return
            }
            
            //檢查登入結果和ID Token
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                completion(.failure(.signInFail("Google登入失敗，無法獲得使用者資訊")))
                return
            }
            
            //建立Firebase憑證
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
            
            
            //使用Firebase憑證登入
            Auth.auth().signIn(with: credential) { result, error in
                
                guard error == nil else {
                    completion(.failure(.signInFail(error?.localizedDescription ?? "unkown")))
                    return
                }
                
                //result = Firebase 登入後的資料，(result.user = Firebase user)
                guard let result else {
                    completion(.failure(.signInFail("Firebase登入失敗")))
                    return
                }
                
                
                //登入成功後，可以使用user取得使用者基本資料(from google)
                let name = user.profile?.name ?? ""
                let email = user.profile?.email ?? ""
                let uid = result.user.uid
                
                let firebaseUser = User(name: name, phoneNumber: "google account", emailAddress: email, password: "google account", uid: uid)
                
                DatabaseManager.share.userExistsWithEmail(with: email) { exist in
                    if !exist {
                        DatabaseManager.share.insertUser(with: firebaseUser)
                    }
                }
                
                completion(.success(firebaseUser))
                
            }
            
        }
    }
    
    func signInWithEmail(email:String, password:String, completion: @escaping (Result<Void, FirebaseError>)->Void){
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { result, error in
            
            

            //Email登入失敗
            guard error == nil else {
                completion(.failure(.signInFail(error?.localizedDescription ?? "unknown error")))
                return
            }
            
            
            if let currentUser = FirebaseAuth.Auth.auth().currentUser {
                
                //檢查認證，確認Mail有效性
                if currentUser.isEmailVerified {
                    
                    //登入成功
                    completion(.success(()))
                    
                    //關掉登入畫面、收鍵盤
                }
                
                else {
                    completion(.failure(.signInFail("電子郵件未認證")))
                }
            }
        }
        
    }
    
    
}
