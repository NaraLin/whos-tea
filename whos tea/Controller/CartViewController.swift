//
//  CartViewController.swift
//  whos tea
//
//  Created by 林靖芳 on 2024/7/4.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    var viewModel = CartViewModel()
    
    private var tableView: UITableView = {
        let TV = UITableView()
        TV.translatesAutoresizingMaskIntoConstraints = false
        TV.backgroundColor = UIColor(named: "mainColor")
        return TV
    }()
    
    private var footerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 242/255, green: 227/255, blue: 239/255, alpha: 1)
        view.clipsToBounds = true
        return view
    }()
    
    private var checkoutButton: UIButton = {
        let bt = UIButton()
   //     bt.setTitle("送出訂單", for: .normal)
        let normalAttributedString: [NSAttributedString.Key : Any] = [.font : UIFont(name: "NatsuzemiMaruGothic-Black", size: 20)!, .foregroundColor : UIColor.white]
        
        bt.setAttributedTitle(NSAttributedString(string: "送出訂單", attributes: normalAttributedString), for: .normal)
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.backgroundColor = UIColor(named: "mainColor")
        bt.clipsToBounds = true
        return bt
    }()
    
    private var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "NatsuzemiMaruGothic-Black", size: 20)
        return label
    }()
    
    
    private var totalPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "GillSans-SemiBold", size: 24)
        return label
    }()
    
    private var totalQtyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "GillSans-SemiBold", size: 16)
        label.textColor = .gray
        return label
    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchOrder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UI setup
        setupUI()
        
        //delegate
        tableView.delegate = self
        tableView.dataSource = self
        
        //register cell
        tableView.register(CartTableViewCell.self, forCellReuseIdentifier: "cartCell")
            
        checkoutButton.addTarget(self, action: #selector(checkout), for: .touchUpInside)
        
        //closure callback function setup
        setupBindings()
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        checkoutButton.layer.cornerRadius = checkoutButton.bounds.width * 0.2
        if footerView.layer.mask == nil || checkoutButton.layer.mask == nil {
            footerView.roundCorners(coners: [.topLeft, .topRight], radius: 20)
           
        }
        
    }
    
    func setupUI() {
        view.backgroundColor = UIColor(named: "mainColor")
        
        //subviews
        view.addSubview(tableView)
        view.addSubview(footerView)
        footerView.addSubview(checkoutButton)
        footerView.addSubview(priceLabel)
        footerView.addSubview(totalPriceLabel)
        footerView.addSubview(totalQtyLabel)
        
        //autolayout
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: footerView.topAnchor),
            
         
            footerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            footerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 80),
            
            checkoutButton.widthAnchor.constraint(equalToConstant: 100),
            checkoutButton.heightAnchor.constraint(equalToConstant: 60),
            checkoutButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -16),
            checkoutButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
            
            priceLabel.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 16),
            priceLabel.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 12),
            
            totalPriceLabel.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 4),
            totalPriceLabel.bottomAnchor.constraint(equalTo: priceLabel.bottomAnchor),

            totalQtyLabel.leadingAnchor.constraint(equalTo: priceLabel.leadingAnchor),
            totalQtyLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor),
            totalQtyLabel.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: -12)

            
        ])
        
        
        priceLabel.text = "總金額"
    }
    
    
    func showTotalPriceAndQty() {
        totalPriceLabel.text = viewModel.totalPriceText
        totalQtyLabel.text = viewModel.totalQtyText
    }
    
    private func setupBindings(){
        
        
        viewModel.onOrderUpdated = { [weak self] in
            DispatchQueue.main.async{
                self?.tableView.reloadData()
                self?.showTotalPriceAndQty()
            }
        }
        
        viewModel.onError = { [weak self] message in
            DispatchQueue.main.async{
                self?.showAlert(title: "Error", message: message)
            }
        }
    }
    
    
   
    
    @objc func checkout(){
        
        viewModel.checkout { success in
            DispatchQueue.main.async {
                switch success{
                    case .success:
                        self.showAlert(title: "訂單已送出", message: "", completion: self.viewModel.fetchOrderFromAPI)
                    case .failure(let error):
                        self.showAlert(title: "Error", message: "\(error.localizedDescription)")
                }
            }
        }
        
        
    }
   
    
    func showAlert(title:String, message:String, completion:(()->Void)? = nil){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default,handler: { _ in
            completion?()
        }))
        self.present(alert, animated: true)
    }
    
    //購物車刪除
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "刪除訂單") { action, view, completion in
           
            self.viewModel.deleteOrder(row: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        deleteAction.backgroundColor = .red
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        return config
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.consolidatedOrder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.separatorStyle = .none
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath) as! CartTableViewCell
        
        let order = viewModel.consolidatedOrder[indexPath.row]
        
        let drink = order.fields.drink
        let ice = order.fields.ice
        let sugar = order.fields.sugar
        let name = order.fields.name
        let price = order.fields.price
        let qty = order.fields.qty
        let totalPrice = order.fields.totalPrice
        
        cell.drinkLabel.text = drink
        cell.nameLabel.text = "訂購者 : " + name
        cell.qtyLabel.text = "數量 : " + String(qty) + " / "
        cell.totalPriceLabel.text = "$ " + String(totalPrice)
        cell.unitPriceLabel.text = "單價 : " + String(price)
        cell.sugarIceLabel.text = sugar + "  /  " + ice
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
         
    }
    
    
}


