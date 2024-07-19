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
    
    var drinks = [Records]()
    var categories = [String]()
    var filterDrinks = [Records]()
    var handle: AuthStateDidChangeListenerHandle?
    
    //NSCache類似dictionary，有key&Value，型別都必須是物件，只能傳入 class 定義的型別(所以不能URL，只能NSURL)
    //NSCache 比較不會造成記憶體的問題，因為當系統記憶體不夠時，它會自動將東西從 cache 裡移除，也可以限制它可以儲存的東西數量(設定它的 countLimit)
    let imageCache = NSCache<NSURL, UIImage>()
    
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
        fetchData()
        
        
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
        
        //segmentcontrol setting
        setupSegctrl()
       
    }
    
   
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //監聽登入狀態
        handle = Auth.auth().addStateDidChangeListener { [weak self] auth, fireUser in
            
            guard let strongSelf = self else {
                return
            }
            
            guard fireUser != nil else {
                let vc = LoginViewController()
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                strongSelf.present(nav, animated: true)
                return
            }
        }
       
        
    }
    
    
    //移除監聽
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handle!)
        
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
    
    
    func fetchData(){
        
        FetchDataManager.shared.fetchData { [weak self] result in
            
            guard let strongSelf = self else {
                return
            }

            switch result {
                case .success(let data):
                    strongSelf.drinks = data.records
                    
                    //.map : $0 = records 第一個array，由裡面的特定值組成一個新 array
                    let allCategory = data.records.map {$0.fields.type }
                    
                    //Set去重複
                    let allCategorySet = Set(allCategory)
                    //Set -> Array + sorted排序
                    let allCategorySorted = Array(allCategorySet).sorted()
                    
                    strongSelf.categories = allCategorySorted
                    print(strongSelf.categories)
                    
                    DispatchQueue.main.async {
                        strongSelf.setupSegctrl()
                        strongSelf.tableView.reloadData()
                    }
                    
                case .failure(let error):
                    switch error {
                        case .decodeError(let message):
                            print("decode Error : \(message)")
                        case .sessionError(let message):
                            print("session Error : \(message)")
                        case .urlError(let message):
                            print("url Error : \(message)")
                    }
            }
        }
        
    }
    
    func setupSegctrl(){
        
        // 清空之前的 segments
        drinkSegCtrl.removeAllSegments()
        
        //segment setting
        for (index, category) in categories.enumerated() {
            drinkSegCtrl.insertSegment(withTitle: category, at: index, animated: false)
        }
        
        drinkSegCtrl.selectedSegmentIndex = 0
        
        //初始filterDrinks
        filterDrinks = drinks.filter { $0.fields.type == "原味茶"}
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        drinkSegCtrl.addTarget(self, action: #selector(segmentChange), for: .valueChanged)
        
        
        
    }
  
    @objc func segmentChange(sender: UISegmentedControl) {
        
        let selectCategory = categories[sender.selectedSegmentIndex]
        
        //update filterDrinks
        filterDrinks = drinks.filter { $0.fields.type == selectCategory}
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func fetchImage(url: URL, completionHandler: @escaping (UIImage?) -> Void) {
        
        //如果cache有圖，直接讀取cache裡的圖片
    
        if let image = imageCache.object(forKey: url as NSURL) {
            completionHandler(image)
            return
        }
        //cache沒有圖，從網路上抓取
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            guard let strongSelf = self else {
                return
            }
            
            if let data = data,
                let image = UIImage(data: data) {
               
                //將圖片存到cache
                strongSelf.imageCache.setObject(image, forKey: url as NSURL)
                completionHandler(image)
            } else {
                completionHandler(nil)
            }
        }.resume()
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
        return filterDrinks.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = DrinkOrderViewController()
        vc.drinks = filterDrinks[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath) as! MenuTableViewCell
        vc.image = cell.drinkImageView.image
        
        
        present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "menu cell", for: indexPath) as! MenuTableViewCell
        let drink = filterDrinks[indexPath.row]
        cell.drink = drink
        cell.drinkNameLabel.text = "----    " + filterDrinks[indexPath.row].fields.name + "    ----"
        cell.drinkImageView.image = nil
        
        //fetchImage
        if let imageURL = drink.fields.image {
            
            fetchImage(url: imageURL) { image in
                
                DispatchQueue.main.async {
                    
                    if cell.drink?.fields.name == drink.fields.name {
                        cell.drinkImageView.image = image
                    }
                    
                    //(其他做法)得到cell的位置，目前cell的位置＝抓照片時的cell才更新圖片，避免錯誤顯示
                    //if let currentIndexPath = self.tableView.indexPath(for: cell),
                    // currentIndexPath == indexPath { cell.drinkImageView.image = image }
                }
            }
            
        }
        
        return cell
        
        
    }
}
