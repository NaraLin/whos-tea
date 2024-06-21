//
//  MenuViewController.swift
//  whos tea
//
//  Created by 林靖芳 on 2024/6/20.
//

import UIKit
import FirebaseAuth

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue.withAlphaComponent(0.6)
//        DatabaseManager.share.test()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //檢查是否有登入
        validationAuth()
    }
    
    
    private func validationAuth(){
        
        if FirebaseAuth.Auth.auth().currentUser == nil {
            
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true)
            
        }
        
        
        
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
