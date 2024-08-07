//
//  ProfileViewController.swift
//  whos tea
//
//  Created by 林靖芳 on 2024/6/22.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class ProfileViewController: UIViewController {

    let data = ["Log Out"]
    
    private let tableView: UITableView = {
        let tableview = UITableView()
        tableview.translatesAutoresizingMaskIntoConstraints = false
        return tableview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //subview
        view.addSubview(tableView)

        //delegate
        tableView.delegate = self
        tableView.dataSource = self
        
        // auto layout setting
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "cell")
        
        
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

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .red
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //unhighlight the cell
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        do{
            try FirebaseAuth.Auth.auth().signOut()
            
            let VC = LoginViewController()
            VC.modalPresentationStyle = .fullScreen
            present(VC, animated: true)
            
        }
        catch{
            //Error
        }
    }
}
