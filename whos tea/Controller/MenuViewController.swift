//
//  MenuViewController.swift
//  whos tea
//
//  Created by 林靖芳 on 2024/6/20.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class MenuViewController: UIViewController {
 
    private let viewModel = MenuViewModel()
    
    
    private let tableView: UITableView = {
        let tableview = UITableView()
        tableview.translatesAutoresizingMaskIntoConstraints = false
        return tableview
    }()
    
    
    private var drinkSegCtrl: UISegmentedControl = {
        
        let segCtrl = UISegmentedControl()
        segCtrl.translatesAutoresizingMaskIntoConstraints = false
        
        let normalAttributes: [NSAttributedString.Key : Any] = [.foregroundColor : UIColor.lightGray, .font : UIFont(name: "NatsuzemiMaruGothic-Black", size: 14)!]
        let selectedAttributes: [NSAttributedString.Key : Any] = [.foregroundColor : UIColor.black, .font : UIFont(name: "NatsuzemiMaruGothic-Black", size: 20)!]
        segCtrl.setTitleTextAttributes(normalAttributes, for: .normal)
        segCtrl.setTitleTextAttributes(selectedAttributes, for: .selected)
        
        segCtrl.backgroundColor = UIColor(named: "mainColor")
        return segCtrl
    }()
    
    private var segctrlScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "mainColor")
        tableView.rowHeight = UITableView.automaticDimension
        
        //fetchData, update drinks & filterDrinks
        viewModel.fetchData { [weak self] result in
            
            guard let strongSelf = self else {return}
            
            switch result {
                case .success:
                    DispatchQueue.main.async{
                        strongSelf.viewModel.setupSegctrl(segCtrl: strongSelf.drinkSegCtrl)
                        strongSelf.tableView.reloadData()
                    }
                    
                case .failure(let error):
                    switch error{
                        case .decodeError(let errorMessage):
                            print("Decode Error:\(errorMessage)")
                        case .sessionError(let errorMessage):
                            print("Session Error:\(errorMessage)")
                        case .urlError(let errorMessage):
                            print("URL Error:\(errorMessage)")
                    }
                   
                    
            }
        }
        
        
        //delegate, datasource
        tableView.delegate = self
        tableView.dataSource = self
        
        //subview
        view.addSubview(tableView)
        view.addSubview(segctrlScrollView)
        segctrlScrollView.addSubview(drinkSegCtrl)
   
        
        //auto layout
        autoLayoutSetting()
        
        //cell register
        tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: "menu cell")
        

        //addTarget
        drinkSegCtrl.addTarget(self, action: #selector(segmentChange), for: .valueChanged)
       
    }
    
   
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.addAuthStateListener(viewController: self)
        
    }
    
    
    //移除監聽
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.removeAuthStateListener()
    }
    
    func autoLayoutSetting(){
        
        NSLayoutConstraint.activate([
            
            drinkSegCtrl.leadingAnchor.constraint(equalTo: segctrlScrollView.contentLayoutGuide.leadingAnchor),
            drinkSegCtrl.trailingAnchor.constraint(equalTo: segctrlScrollView.contentLayoutGuide.trailingAnchor),
            drinkSegCtrl.centerYAnchor.constraint(equalTo: segctrlScrollView.centerYAnchor),
            
            segctrlScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            segctrlScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            segctrlScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            segctrlScrollView.heightAnchor.constraint(equalTo: drinkSegCtrl.heightAnchor, multiplier: 2),

            
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: segctrlScrollView.bottomAnchor, constant: 16),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
    

    
    @objc func segmentChange(sender: UISegmentedControl) {
        
        viewModel.segmentChange(segCtrl: sender)
        self.tableView.reloadData()
        
    }
    
    
    
    
    
    
    
//    private func validationAuth(){
//
//        if currentUser == nil {
//
//            let vc = LoginViewController()
//            let nav = UINavigationController(rootViewController: vc)
//            nav.modalPresentationStyle = .fullScreen
//            present(nav, animated: true)
//
//        }
//
//    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}


extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filterDrinks.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = DrinkOrderViewController()
        vc.drinks = viewModel.filterDrinks[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath) as! MenuTableViewCell
        vc.image = cell.drinkImageView.image
        
        
        present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "menu cell", for: indexPath) as! MenuTableViewCell
        let drink = viewModel.filterDrinks[indexPath.row]
        cell.drink = drink
        cell.drinkNameLabel.text = "----    " + viewModel.filterDrinks[indexPath.row].fields.name + "    ----"
        cell.drinkImageView.image = nil
        
        //fetchImage
        if let imageURL = drink.fields.image {
            
            viewModel.fetchImage(url: imageURL) { image in
                DispatchQueue.main.async {
                    if cell.drink?.fields.name == drink.fields.name {
                        cell.drinkImageView.image = image
                    }
                    
                }
                //(其他做法)得到cell的位置，目前cell的位置＝抓照片時的cell才更新圖片，避免錯誤顯示
                //if let currentIndexPath = self.tableView.indexPath(for: cell),
                // currentIndexPath == indexPath { cell.drinkImageView.image = image }
            }
        }
        
        
        
        return cell
        
        
    }
}
