//
//  ViewController.swift
//  whos tea
//
//  Created by 林靖芳 on 2024/6/19.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    private let scrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let label:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "登入"
        label.textColor = .white
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailField: UITextField = {
        let emailField = UITextField()
        emailField.placeholder = "請輸入電子信箱"
        emailField.layer.borderWidth = 2
        emailField.layer.borderColor = UIColor.black.cgColor
        emailField.backgroundColor = .white
        emailField.layer.cornerRadius = 10
        emailField.translatesAutoresizingMaskIntoConstraints = false
        //首字不自動大寫
        emailField.autocapitalizationType = .none
        emailField.leftViewMode = .always
        emailField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        return emailField
    }()
    
    
    private let passwordField: UITextField = {
        let passwordField = UITextField()
        passwordField.placeholder = "請輸入密碼"
        passwordField.layer.borderWidth = 2
        passwordField.layer.borderColor = UIColor.black.cgColor
        passwordField.isSecureTextEntry = true
        passwordField.backgroundColor = .white
        passwordField.layer.cornerRadius = 10
        passwordField.autocapitalizationType = .none
        passwordField.leftViewMode = .always
        passwordField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.textContentType = .oneTimeCode
        return passwordField
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 114/255, green: 131/255, blue: 186/255, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("登入", for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let createAccountButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.clear
        button.setTitleColor(.white, for: .normal)
        button.setTitle("沒有帳號嗎？點這裡申請", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    
    private let signOutButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 114/255, green: 131/255, blue: 186/255, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("登出", for: .normal)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "mainColor")
        
        
        //subviews
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(label)
        contentView.addSubview(emailField)
        contentView.addSubview(passwordField)
        contentView.addSubview(button)
        contentView.addSubview(createAccountButton)
        
        //delegate
        emailField.delegate = self
        passwordField.delegate = self
        
        //按空白處收鍵盤
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        //登入確認
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        
        //跳到註冊頁面
        createAccountButton.addTarget(self, action: #selector(didTapCreateAccount), for: .touchUpInside)
        
        
        //如果已登入(使用者存在)
        if FirebaseAuth.Auth.auth().currentUser != nil {
            label.isHidden = true
            emailField.isHidden = true
            passwordField.isHidden = true
            button.isHidden = true
            
            view.addSubview(signOutButton)
            signOutButton.frame = CGRect(x: 20, y: 150, width: view.frame.size.width - 40, height: 52)
            
            signOutButton.addTarget(self, action: #selector(logOutTap), for: .touchUpInside)
        }
        

        
        //設定autolayout
        let contentViewHeightAnchor = contentView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor)
        contentViewHeightAnchor.priority = UILayoutPriority(rawValue: 1)
        
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor),
   
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            label.heightAnchor.constraint(equalToConstant: 80),
            
            
            emailField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 40),
            emailField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            emailField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            emailField.heightAnchor.constraint(equalToConstant: 50),
            
            
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 40),
            passwordField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            passwordField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            passwordField.heightAnchor.constraint(equalToConstant: 50),
            
            
            button.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 30),
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            button.heightAnchor.constraint(equalToConstant: 60),
            
            
            createAccountButton.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 20),
            createAccountButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            createAccountButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            createAccountButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            createAccountButton.heightAnchor.constraint(equalToConstant: 20)
            
            
        ])
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //讓kb不擋textfield
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification){
        
        guard let keyboardSize =
                notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {return}
        
        
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + 8, right: 0)
        
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHide(){
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
    //跳轉註冊畫面
    @objc func didTapCreateAccount(){
        let VC = RegisterViewController()
        VC.modalPresentationStyle = .popover
        present(VC, animated: true)
        
    }
    
    
    @objc func logOutTap(){
        do{
            try FirebaseAuth.Auth.auth().signOut()
            label.isHidden = false
            emailField.isHidden = false
            passwordField.isHidden = false
            button.isHidden = false
            
            signOutButton.removeFromSuperview()
        }
        catch{
          print("登出有問題")
        }
    }
    
    
    
    @objc func didTapButton(){
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty else {
            print("請輸入email & password")
            return
        }
        
        //Get auth instance
        //attempt sign in
        //if failure, present alert to creat account
        //if user continues, create account
        
        //check sign in on app launch
        //allow user to sign out with button
        
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            
            guard let strongSelf = self else {
                return
            }
            
            //登入失敗跳alert，申請新帳號
            guard error == nil else {
                strongSelf.showCreateAccount(email: email, password: password)
                return
            }
            
            //登入成功，關掉登入畫面
            strongSelf.dismiss(animated: true)
            
            //收鍵盤
            strongSelf.emailField.resignFirstResponder()
            strongSelf.passwordField.resignFirstResponder()
            
        }
        
        
    }
    
    
    func showCreateAccount(email: String, password: String){
        let alert = UIAlertController(title: "帳號不存在", message: "是否要申請帳號？", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "continue", style: .default, handler: {[weak self] _ in
            
            guard let strongSelf = self else { return }
            
            //跳到register頁面建立帳號
            strongSelf.didTapCreateAccount()
            
            //收鍵盤
            strongSelf.emailField.resignFirstResponder()
            strongSelf.passwordField.resignFirstResponder()
        }
                                     ))
        
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { _ in
            
        }))
        
        present(alert, animated: true)
        
    }
    
    //畫面出現後即跳出emailtextfield的鍵盤
    override func viewDidAppear(_ animated: Bool) {
        
        if FirebaseAuth.Auth.auth().currentUser == nil {
            emailField.becomeFirstResponder()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField {
            passwordField.resignFirstResponder()
        }
        
        return true
    }
    
}

