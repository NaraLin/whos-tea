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
    

    var orderDetail: [GetOrderRecords]?
    var consolidatedOrder: [ConsolidateOrderRecords] = []
    var orderPrice: Int?
    var orderQty: Int?
    var user: String?
    
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
        
        fetchOrder()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "mainColor")
        
        //subviews
        view.addSubview(tableView)
        view.addSubview(footerView)
        footerView.addSubview(checkoutButton)
        footerView.addSubview(priceLabel)
        footerView.addSubview(totalPriceLabel)
        footerView.addSubview(totalQtyLabel)
        
        
        //delegate
        tableView.delegate = self
        tableView.dataSource = self
        
        
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
        
        //register cell
        tableView.register(CartTableViewCell.self, forCellReuseIdentifier: "cartCell")
        
        //fetch currentUser and order
        getCurrentUser { user in
            if let user {
                self.user = user
                self.fetchOrder()
            }
        }
        
        
        //
        priceLabel.text = "總金額"
        
        
        checkoutButton.addTarget(self, action: #selector(checkout), for: .touchUpInside)
        
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        checkoutButton.layer.cornerRadius = checkoutButton.bounds.width * 0.2
        if footerView.layer.mask == nil || checkoutButton.layer.mask == nil {
            footerView.roundCorners(coners: [.topLeft, .topRight], radius: 20)
           
        }
        
    }
    
    //ConsolidatedOrderRecords -> OrderRecords
    //一次得到一個OrderRecords(剔除id)
    func convertToOrderRecords(consolidateOrderRecord: ConsolidateOrderRecords) -> OrderRecords{
        return OrderRecords(fields: consolidateOrderRecord.fields)
    }
    
    //ConsolidatedOrder -> Order (records型別不同要轉換)
    //先取得ConsolidatedOrder，record型別改從ConsolidatedOrderRecords -> OrderRecords
    func convertToOrders(consoliatedOrder: ConsolidateOrder) -> Orders{
        Orders(records: consoliatedOrder.records.map { convertToOrderRecords(consolidateOrderRecord: $0) })
    }
    
    
    func getCurrentUser(completion: @escaping (String?) -> Void) {
        
        if let currentUser = FirebaseAuth.Auth.auth().currentUser {
            if let usrEmail = currentUser.email {
                let safeEmail = usrEmail.replacingOccurrences(of: ".", with: "-")
                FirebaseDatabase.Database.database().reference().child(safeEmail).observeSingleEvent(of: .value) { snapshot  in
                    
                    let value = snapshot.value as? NSDictionary
                    let username = value?["name"] as? String ?? "userError"
                    
                    completion(username)
                    
                    
                }
            }
        }
        completion(nil)
    }
    
    @objc func checkout(){
        
        if let url = URL(string: "https://api.airtable.com/v0/appvC935PME75LZRT/checkout") {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.setValue("Bearer \(APIKey.default)", forHTTPHeaderField: "Authorization")
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
           
            let consolidateOrder = ConsolidateOrder(records: consolidatedOrder)
            let uploadData = convertToOrders(consoliatedOrder: consolidateOrder)
            let body = try? JSONEncoder().encode(uploadData)
            urlRequest.httpBody = body
            
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
                    }
                    
                    var deleteID: [String] = []
                    for i in consolidateOrder.records {
                        let ids = i.id
                        deleteID.append(contentsOf: ids)
                    }
                    
                    self.deleteOrder(recordIDs: deleteID)
                    
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "訂單已送出", message: "", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alert, animated: true, completion: self.fetchOrder)
                    }
                }
            }.resume()
        }
        
        
        
    }
    
    func calculate(){

        orderPrice = consolidatedOrder.reduce(0) { result, order in
            return result + order.fields.totalPrice
        }
        
        orderQty = consolidatedOrder.reduce(0) { result, order in
            return result + order.fields.qty
        }

        totalPriceLabel.text = "$ \(orderPrice ?? 0)"
        totalQtyLabel.text = "共計 \(orderQty ?? 0) 杯"
 
    }
    
    
    func fetchOrder(){
        
        if let url = URL(string: "https://api.airtable.com/v0/appvC935PME75LZRT/order") {
            var request = URLRequest(url: url)
            request.setValue("Bearer \(APIKey.default)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                
                guard let strongSelf = self else {
                    return
                }
                
                if let error {
                    print(error.localizedDescription)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    return
                }
                
                if let data {
                    
                    let decoder = JSONDecoder()
                    
                    do {
                        let orderData = try decoder.decode(GetOrder.self, from: data)
                        let allOrder = orderData.records

                        let orderByPerson = allOrder.filter { $0.fields.name == strongSelf.user
                        }
                        
                        strongSelf.orderDetail = orderByPerson

                        if let orderDetail = strongSelf.orderDetail {
                            strongSelf.consolidatedOrder = strongSelf.consolidateOrder(orders: orderDetail).sorted()
                            
                        }
                        
                        print(strongSelf.consolidatedOrder)
                        
                        DispatchQueue.main.async {
                            strongSelf.tableView.reloadData()
                            strongSelf.calculate()
                        }
                        
                    }
                    catch{
                        print("error")
                    }
                    
                }
            }.resume()
            
        }
    
    }
    
    func consolidateOrder(orders: [GetOrderRecords]) -> [ConsolidateOrderRecords] {
        
        var orderDict = [GetOrderRecords:ConsolidateOrderRecords]()
        
        //迴圈整理資料，把重複的array整理成一個，id集合成新array for刪除資料使用
        for order in orders {
            if let existOrder = orderDict[order] {
                var updatedOrder = existOrder
                updatedOrder.fields.qty += order.fields.qty
                updatedOrder.id.append(order.id)
                orderDict[order] = updatedOrder
            } else {
                orderDict[order] = ConsolidateOrderRecords(id: [order.id], fields: order.fields)
            }
        }
        
        return Array(orderDict.values)
    }
    
    
    func deleteOrder(recordIDs:[String]){
        if var component = URLComponents(string: "https://api.airtable.com/v0/appvC935PME75LZRT/order"){
            
            var queryItems = [URLQueryItem]()
            for id in recordIDs {
                queryItems.append(URLQueryItem(name: "records[]", value: id))
            }
            component.queryItems = queryItems
            guard let url = component.url else {
                print("url error")
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            request.setValue("Bearer \(APIKey.default)", forHTTPHeaderField: "Authorization")
            print(url)
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error {
                    print(error)
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
                    let dic = try? JSONDecoder().decode(DeleteOrder.self, from: data)
                    print(dic ?? "nil")
                }
                          
            }.resume()
        }
        
    }
    

    
    
    //購物車刪除
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "刪除訂單") { action, view, completion in
           
            let id = self.consolidatedOrder[indexPath.row].id
            self.consolidatedOrder.remove(at: indexPath.row)
            print(id)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.deleteOrder(recordIDs: id)
            self.calculate()
            
            completion(true)
        }
        deleteAction.backgroundColor = .red
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        return config
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        consolidatedOrder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.separatorStyle = .none
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath) as! CartTableViewCell
        
        let order = consolidatedOrder[indexPath.row]
        
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

//擴展view畫圓角
extension UIView {
    
    func roundCorners(coners: UIRectCorner, radius: CGFloat){
        
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: coners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        
    }
}
