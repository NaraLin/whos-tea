//
//  DrinkOrderViewController.swift
//  whos tea
//
//  Created by 林靖芳 on 2024/7/1.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth



class DrinkOrderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var selectQty: Int = 1
    var drinks: Records!
    var image: UIImage?
    
    //[section:selected row]
    var selectOption: [Int : Int] = [:]
    let footerView = UIView()
    var cartInfo:[OrderRecords]?
    var uploadOrder: Orders?
    var currentUser: String?
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "mainColor")
        headerView.isUserInteractionEnabled = false
        
        let headerLabel = UILabel()
        headerLabel.text = orderSection.allCases[section].rawValue
        headerLabel.textColor = .white
        headerLabel.font = UIFont(name: "NatsuzemiMaruGothic-Black", size: 24)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(headerLabel)
        
        NSLayoutConstraint.activate([
            
            headerLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 8),
            headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 12),
            headerLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8)
        ])
        
        return headerView
        
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        60
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
            case 0:
                return 1
            case 1:
                return iceChoice.allCases.count
            case 2:
                return sugarChoice.allCases.count
            default :
                return 1
                
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectOption[indexPath.section] = indexPath.row
        
        //更新指定的section
        tableView.reloadSections(IndexSet(integer: indexPath.section), with: .none)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let iceSugarCell = tableView.dequeueReusableCell(withIdentifier: "iceAndSugarCell", for: indexPath) as! IceSugarTableViewCell
        
        let drinkCell = tableView.dequeueReusableCell(withIdentifier: "drinkCell", for: indexPath) as! OrderDrinkTableViewCell
        
        
        tableView.separatorStyle = .none
        
        iceSugarCell.radioButton.isSelected = selectOption[indexPath.section] == indexPath.row
        
        switch indexPath.section {
            case 0:
                drinkCell.drinkLabel.text = drinks.fields.name
                drinkCell.drinkImageView.image = image
                drinkCell.isUserInteractionEnabled = false
                
                return drinkCell
            
            case 1:
                iceSugarCell.iceSugarLabel.text = iceChoice.allCases[indexPath.row].rawValue
               return iceSugarCell
                
            case 2:
                iceSugarCell.iceSugarLabel.text = sugarChoice.allCases[indexPath.row].rawValue
                return iceSugarCell
                
        
            default:
                return iceSugarCell
        }
        
    }
    

    private var tableView: UITableView = {
        let tableview = UITableView()
        tableview.translatesAutoresizingMaskIntoConstraints = false
        return tableview
    }()
    
    
    private var qtyStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "mainColor")
        view.axis = .horizontal
        view.distribution = .fillProportionally
        view.alignment = .fill
        view.spacing = 16
        return view
        
    }()
    
    private var priceStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "mainColor")
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .fill
        view.spacing = 4
        return view
        
    }()
    
    private var cartLeftStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "mainColor")
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .leading
        view.spacing = 12
        return view
        
    }()
    
    private var cartStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "mainColor")
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .center
        view.spacing = 8
        
        return view
        
    }()
    
    private var priceLabel: UILabel = {
        let label = UILabel()
        label.text = "總金額 ：＄"
        label.font = UIFont(name: "NatsuzemiMaruGothic-Black", size: 20)
        label.textColor = .white
        
        return label
    }()
    
    private lazy var selectPriceLabel: UILabel = {
        let label = UILabel()
        let price = drinks.fields.largeSizePrice
        label.text = price
        label.font = UIFont(name: "GillSans-SemiBold", size: 24)
        label.textColor = .yellow
        
        return label
    }()
    
    private var QTYLabel: UILabel = {
        let label = UILabel()
        label.text = "數量 ："
        label.font = UIFont(name: "NatsuzemiMaruGothic-Black", size: 20)
        label.textColor = .white
        
        return label
    }()
    
    private var selectQTYLabel: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.font = UIFont(name: "GillSans-SemiBold", size: 24)
        label.textColor = .yellow
        
        return label
    }()
    
    private var QTYStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.stepValue = 1
        stepper.minimumValue = 1
        stepper.value = 1
        stepper.backgroundColor = UIColor.white
        stepper.layer.cornerRadius = 12
        stepper.clipsToBounds = true
        return stepper
        
    }()
    
    private var addToCartButton: UIButton = {
        let button = UIButton()
       // button.setTitle("加到購物車", for: .normal)
        let normalAttributedString: [NSAttributedString.Key : Any] = [.font : UIFont(name: "NatsuzemiMaruGothic-Black", size: 20)!, .foregroundColor : UIColor.white]
        button.setAttributedTitle(NSAttributedString(string: "加到購物車", attributes: normalAttributedString), for: .normal)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //registercell
        tableView.register(IceSugarTableViewCell.self, forCellReuseIdentifier: "iceAndSugarCell")
        tableView.register(OrderDrinkTableViewCell.self, forCellReuseIdentifier: "drinkCell")
        
        
        //delegate
        tableView.dataSource = self
        tableView.delegate = self
        
        //subview
        view.addSubview(tableView)
        view.addSubview(footerView)
        
        qtyStackView.addArrangedSubview(QTYLabel)
        qtyStackView.addArrangedSubview(selectQTYLabel)
        qtyStackView.addArrangedSubview(QTYStepper)
        
        priceStackView.addArrangedSubview(priceLabel)
        priceStackView.addArrangedSubview(selectPriceLabel)
        
        cartLeftStackView.addArrangedSubview(qtyStackView)
        cartLeftStackView.addArrangedSubview(priceStackView)
        
        cartStackView.addArrangedSubview(cartLeftStackView)
        cartStackView.addArrangedSubview(addToCartButton)
        
        footerView.addSubview(cartStackView)
        footerView.translatesAutoresizingMaskIntoConstraints = false
        footerView.backgroundColor = UIColor(named: "mainColor")
        
        
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: footerView.topAnchor),
            
            footerView.heightAnchor.constraint(equalToConstant: 120),
            footerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
           
            cartStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            cartStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            cartStackView.centerYAnchor.constraint(equalTo: footerView.centerYAnchor)
            
            
        ])
        
        //取得用戶名
        getCurrentUser()
        
        //addTarget
        QTYStepper.addTarget(self, action: #selector(stepperValueChange), for: .valueChanged)
        addToCartButton.addTarget(self, action: #selector(addToCart), for: .touchUpInside)
        
        
    }
    
    @objc func stepperValueChange(sender: UIStepper) {
        
        let value = Int(sender.value)
        selectQTYLabel.text = "\(value)"
        let drinkPrice = Int(drinks.fields.largeSizePrice!)!
        let drinkPriceTotal = drinkPrice * value
        selectPriceLabel.text = "\(drinkPriceTotal)"

    }
    
    
    func getCurrentUser(){
        
        if let currentUser = FirebaseAuth.Auth.auth().currentUser {
            if let usrEmail = currentUser.email {
                let safeEmail = usrEmail.replacingOccurrences(of: ".", with: "-")
                FirebaseDatabase.Database.database().reference().child(safeEmail).observeSingleEvent(of: .value) { snapshot  in
                    
                    let value = snapshot.value as? NSDictionary
                    let username = value?["name"] as? String ?? "unknownuser"
                    self.currentUser = username
                    print(username)
                    
                }
            }
        }
    }
    
    @objc func addToCart() {

        if selectOption[1] != nil &&
            selectOption[2] != nil {
            
            addToCartButton.isSelected = true
            
            let addCartDrink = drinks.fields.name
            let iceSelected = iceChoice.allCases[selectOption[1]!].rawValue
            let sugarSelected = sugarChoice.allCases[selectOption[2]!].rawValue
            let qtySelected = Int(QTYStepper.value)
            let priceTotal = qtySelected * Int(drinks.fields.largeSizePrice!)!
            getCurrentUser()
            if let currentUser {
                self.uploadOrder = Orders(records: [OrderRecords(fields: OrderFields(name: currentUser, drink: addCartDrink, sugar: sugarSelected, ice: iceSelected, price: priceTotal, qty: qtySelected))])
                print(self.uploadOrder!)
                self.uploadCartOrder()
                
            }
 
        } else {
            let alert = UIAlertController(title: "請選擇甜度冰塊", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            addToCartButton.isSelected = false
        }
        
    }
    
    func uploadCartOrder(){
        
        if let url = URL(string: "https://api.airtable.com/v0/appvC935PME75LZRT/order") {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.setValue("Bearer \(APIKey.default)", forHTTPHeaderField: "Authorization")
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let uploadData = try? JSONEncoder().encode(uploadOrder)
            urlRequest.httpBody = uploadData
            
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                
                if let error {
                    print(error.localizedDescription)
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    if !(200...299).contains(httpResponse.statusCode) {
                        print(httpResponse.statusCode)
                        print("httpresponse error")
                        return
                    }
                    
                }
                
                if let data {
                    
                    let decoder = JSONDecoder()
                    if let createDataResponse = try? decoder.decode(OrderResponse.self, from: data) {
                        print(createDataResponse)
                        
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "已成功加入購物車", message: "", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default))
                            self.present(alert, animated: true)
        
                        }
                        
                    }
                    
                }
            }.resume()
                
                
            }
            
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




