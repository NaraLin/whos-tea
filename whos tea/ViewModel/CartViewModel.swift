//
//  CartViewModel.swift
//  whos tea
//
//  Created by 林靖芳 on 2024/7/30.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class CartViewModel {
    
    private var orderDetail: [GetOrderRecords]?
    private(set) var consolidatedOrder: [ConsolidateOrderRecords] = []
    
    private var orderPrice: Int? {
        didSet{
            onOrderUpdated?()
        }
    }
    
    private var orderQty: Int?
    
    var totalPriceText: String {
        "$ \(orderPrice ?? 0)"
    }
    
    var totalQtyText: String {
        "共計 \(orderQty ?? 0) 杯"
    }
    
    
    private var user: String?
    
    var onOrderUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    
    func fetchOrderFromAPI() {
        
        FetchDataManager.shared.fetchData(url: GetUrl.order) { [weak self] result in
            
            guard let strongSelf = self else {
                return
            }
            
            switch result{
                case .success(let data):
                    let decoder = JSONDecoder()
                    guard let orderData = try? decoder.decode(GetOrder.self, from: data) else {
                        strongSelf.onError?("解碼失敗")
                        return
                    }
                    
                    let allOrder = orderData.records
                    
                    //篩選出該位使用者的訂單
                    strongSelf.orderDetail = allOrder.filter { $0.fields.name == strongSelf.user
                    }
                    
                    if let orderDetail = strongSelf.orderDetail {
                        strongSelf.consolidatedOrder = strongSelf.consolidateOrder(orders: orderDetail).sorted()
                        
                    }
                    
                    print(strongSelf.consolidatedOrder)
                    
                    DispatchQueue.main.async {
                        //更新tableView＆總total的Label
                        strongSelf.calculate()
                        strongSelf.onOrderUpdated?()
                    }
                    
                case .failure(let error):
                    strongSelf.onError?("\(error.localizedDescription)")
            }
        }
        
    }
    
    func fetchOrder(){
        
        getCurrentUser { [weak self] user in
            
            guard let strongSelf = self,
                  let user else { return }
            
            strongSelf.user = user
            strongSelf.fetchOrderFromAPI()
            
        }
        
       
    }

    
    func calculate(){

        orderPrice = consolidatedOrder.reduce(0) { result, order in
            return result + order.fields.totalPrice
        }
        
        orderQty = consolidatedOrder.reduce(0) { result, order in
            return result + order.fields.qty
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
    
    
    func checkout(completion: @escaping (Result<Void, Error>) -> Void) {
        
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
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"\(error.localizedDescription)"])))
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    if !(200...299).contains(httpResponse.statusCode) {
                       completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"HttpResponse Error:\(httpResponse.statusCode)"])))
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
                    
                    self.deleteOrderFromAPI(recordIDs: deleteID)
                    
                    DispatchQueue.main.async {
                        completion(.success(()))
                    }
                } else {
                   completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"No Data"])))
                }
            }.resume()
        }
        
    }
    
    
    func deleteOrder(row: Int) {
        let id = self.consolidatedOrder[row].id
        consolidatedOrder.remove(at: row)
        deleteOrderFromAPI(recordIDs: id)
        calculate()
    }
    
    func deleteOrderFromAPI(recordIDs:[String]){
        if var component = URLComponents(string: "https://api.airtable.com/v0/appvC935PME75LZRT/order"){
            
            var queryItems = [URLQueryItem]()
            for id in recordIDs {
                queryItems.append(URLQueryItem(name: "records[]", value: id))
            }
            component.queryItems = queryItems
            guard let url = component.url else {
                onError?("url error")
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            request.setValue("Bearer \(APIKey.default)", forHTTPHeaderField: "Authorization")
            print(url)
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error {
                    self.onError?("\(error.localizedDescription)")
                    return
                }
                if let httpResponse = response as? HTTPURLResponse {
                    if !(200...299).contains(httpResponse.statusCode) {
                        self.onError?("HttpResponse Error:\(httpResponse.statusCode)")
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
    
    
}

