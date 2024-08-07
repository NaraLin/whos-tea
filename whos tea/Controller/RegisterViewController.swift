//
//  RegisterViewController.swift
//  whos tea
//
//  Created by 林靖芳 on 2024/6/20.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController, UITextFieldDelegate {

    private let scrollView:UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    private let registerlabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "註冊"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "姓名"
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private let nameTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "請輸入姓名"
        field.layer.borderColor = UIColor.white.cgColor
        field.layer.borderWidth = 4
        field.layer.cornerRadius = 10
        field.returnKeyType = .done
        field.textColor = .white
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        return field
    }()
    
    
    private let phoneLabel: UILabel = {
        let label = UILabel()
        label.text = "手機號碼"
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private let phoneTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "請輸入手機號碼"
        field.layer.borderColor = UIColor.white.cgColor
        field.layer.borderWidth = 4
        field.keyboardType = .phonePad
        field.layer.cornerRadius = 10
        field.textColor = .white
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        field.numberpadReturn()
        return field
    }()
    
    
    private let mailLabel: UILabel = {
        let label = UILabel()
        label.text = "電子信箱"
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private let mailTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "請輸入電子信箱"
        field.layer.borderColor = UIColor.white.cgColor
        field.layer.borderWidth = 4
        field.keyboardType = .emailAddress
        field.autocapitalizationType = .none
        field.returnKeyType = .done
        field.layer.cornerRadius = 10
        field.textColor = .white
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        return field
    }()
    
    private let passwordlLabel: UILabel = {
        let label = UILabel()
        label.text = "密碼"
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private let passwordTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "請輸入密碼"
        field.layer.borderColor = UIColor.white.cgColor
        field.layer.borderWidth = 4
        field.keyboardType = .default
        field.isSecureTextEntry = true
        field.textContentType = .oneTimeCode
        field.returnKeyType = .done
        field.layer.cornerRadius = 10
        field.textColor = .white
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        return field
    }()
    
    
    let nameStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.spacing = 8
        stackview.distribution = .fill
        stackview.translatesAutoresizingMaskIntoConstraints = false
        return stackview
    }()
    
    
    let phoneStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.spacing = 8
        stackview.distribution = .fill
        stackview.translatesAutoresizingMaskIntoConstraints = false
        return stackview
    }()
    
    
    let emailStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.spacing = 8
        stackview.distribution = .fill
        stackview.translatesAutoresizingMaskIntoConstraints = false
        return stackview
    }()
    
    let passwordStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.spacing = 8
        stackview.distribution = .fill
        stackview.translatesAutoresizingMaskIntoConstraints = false
        return stackview
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 114/255, green: 131/255, blue: 186/255, alpha: 1)
        button.layer.cornerRadius = 10
        button.setTitleColor(.white, for: .normal)
        button.setTitle("註冊", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = UIColor(named: "mainColor")
        
        //stackview setting
        nameStackView.addArrangedSubview(nameLabel)
        nameStackView.addArrangedSubview(nameTextField)
        phoneStackView.addArrangedSubview(phoneLabel)
        phoneStackView.addArrangedSubview(phoneTextField)
        emailStackView.addArrangedSubview(mailLabel)
        emailStackView.addArrangedSubview(mailTextField)
        passwordStackView.addArrangedSubview(passwordlLabel)
        passwordStackView.addArrangedSubview(passwordTextField)
        
        //subview
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(registerButton)
        contentView.addSubview(registerlabel)
        contentView.addSubview(nameStackView)
        contentView.addSubview(phoneStackView)
        contentView.addSubview(emailStackView)
        contentView.addSubview(passwordStackView)
        
        //delegate
        nameTextField.delegate = self
        phoneTextField.delegate = self
        mailTextField.delegate = self
        passwordTextField.delegate = self
        
        //send register
        registerButton.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
        
        
        //autolayout setting
        NSLayoutConstraint.activate([
            
           
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            
            registerlabel.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 40),
            registerlabel.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 0),
            registerlabel.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: 0),
            registerlabel.heightAnchor.constraint(equalToConstant: 80),
            
            
            
            nameStackView.topAnchor.constraint(equalTo: registerlabel.bottomAnchor, constant: 40),
            nameStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 20),
            nameStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -20),
            nameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            
            phoneStackView.topAnchor.constraint(equalTo: nameStackView.bottomAnchor, constant: 20),
            phoneStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 20),
            phoneStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -20),
            phoneTextField.heightAnchor.constraint(equalToConstant: 50),
            
            emailStackView.topAnchor.constraint(equalTo: phoneStackView.bottomAnchor, constant: 20),
            emailStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 20),
            emailStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -20),
            mailTextField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordStackView.topAnchor.constraint(equalTo: emailStackView.bottomAnchor, constant: 20),
            passwordStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 20),
            passwordStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            registerButton.topAnchor.constraint(equalTo: passwordStackView.bottomAnchor, constant: 30),
            registerButton.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 20),
            registerButton.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -20),
            registerButton.heightAnchor.constraint(equalToConstant: 60),
            registerButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
            ])
        
        //點空白處收鍵盤
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapHideKeyBoard))
        view.addGestureRecognizer(gesture)
        
    }
    
    @objc func tapHideKeyBoard(){
        view.endEditing(true)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //kb
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @objc func showKeyboard(noti: NSNotification){
        
        guard let keyboardSize = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {return}
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + 8, right: 0)
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset

    }
    
    
    @objc func hideKeyboard(){
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    @objc func didTapRegister(){
        
        nameTextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()
        mailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        guard let name = nameTextField.text, !name.isEmpty,
              let phone = phoneTextField.text, !phone.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let email = mailTextField.text, !email.isEmpty else {
            
            print("註冊資訊不完整")
            //待加alert
            alertMessage(message: "請輸入完整資訊")
            
            return
        }
        
        
        
        DatabaseManager.share.userExistsWithEmail(with: email) { [weak self] exist in
        
            guard let strongSelf = self else {
                return
            }
            
            print(exist)
            
            guard exist == false else{
                //用戶已存在
                strongSelf.alertMessage(message: "用戶已存在")
                return
            }

                
                //用戶不存在，建立帳號
                FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { result, error in
                    
                    guard result != nil, error == nil else {
                        if let errorDescription = error?.localizedDescription {
                            print("帳號申請失敗:\(errorDescription)")
                        }
                        return
                    }
                    
                    FirebaseAuth.Auth.auth().currentUser?.sendEmailVerification(completion: { error in
                        if let error {
                            print(error)
                        }
                        else {
                            print("email send")
                        }
                    
                    })
                    
                    guard let currentUser = FirebaseAuth.Auth.auth().currentUser else {
                        return
                    }
                    
                    let uid = currentUser.uid
                    
                    
                    //建立帳號連接database
                    DatabaseManager.share.insertUser(with: User(name: name, phoneNumber: phone, emailAddress: email, password: password, uid: uid))
                    
                    //認證信發出通知
                    strongSelf.registerSuccessMessage()
                        
                    //檢查認證，確認Mail有效性
                    if currentUser.isEmailVerified {
                        
                        //登入成功，關掉登入畫面
                        strongSelf.dismiss(animated: true)
                        
                        //收鍵盤
                        strongSelf.nameTextField.resignFirstResponder()
                        strongSelf.phoneTextField.resignFirstResponder()
                        strongSelf.mailTextField.resignFirstResponder()
                        strongSelf.passwordTextField.resignFirstResponder()
                    }
                    
                    else {
                        
                        let alert = UIAlertController(title: "電子郵件未認證", message: "請至信箱收取認證信認證", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        strongSelf.present(alert, animated: true)
                        
                    }
                    
                    
                }
            }
        }
        
      
        
    func registerSuccessMessage() {
        let alert = UIAlertController(title: "認證信已發出，請認證後重新登入", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            
        }))
                        
        present(alert, animated: true)
    }
    
    
    func alertMessage(message: String){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default))
        present(alert, animated: true)
   
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == nameTextField {
            phoneTextField.becomeFirstResponder()
        }
        else if textField == phoneTextField {
            mailTextField.becomeFirstResponder()
        }
        else if textField == mailTextField {
            passwordTextField.becomeFirstResponder()
        }
        else if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
        }
        
        return true
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        nameTextField.becomeFirstResponder()
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
