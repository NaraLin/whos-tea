//
//  DrinkOrderViewModel.swift
//  whos tea
//
//  Created by 林靖芳 on 2024/7/29.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase

class DrinkOrderViewModel {
 
    //class沒有初始值，要寫init
    var drinks: Records
    var image: UIImage?
    
    //[section:selected row]
    private var selectOption: [Int : Int] = [:]
    var cartInfo:[OrderRecords]?
    var uploadOrder: Orders?
    var currentUser: String?
    
    //closure for callback
    //數量或金額更新時，更新drinkviewcontroller顯示的label
    var onQtyUpdated: ((Int) -> Void)?
    var onPriceUpdated: ((Int) -> Void)?
    
    private var totalPrice:Int = 0
    
    var selectQty: Int = 1 {
        didSet{
            //數量改變時，更新總金額
            updatePrice()
            onQtyUpdated?(selectQty)
        }
    }

    //有drinks&image才能創建DrinkOrderViewModel，確保ViewModel在創建時就有了必要的數據(drinks)和option的圖片(非必需)
    //在初始化時調用getCurrentUser()，確保用戶資訊在ViewModel創建後盡快被獲取
    init(drinks: Records, image: UIImage?){
        self.drinks = drinks
        self.image = image
        getCurrentUser()
    }

    //UIStepper.value是Double
    func updateQty(value: Int){
        selectQty = value
    }
    
    func updatePrice(){
        if let drinkPrice = drinks.fields.largeSizePrice,
           let price = Int(drinkPrice) {
            totalPrice = price * selectQty
            onPriceUpdated?(totalPrice)
        }
    }
    
    
    func updateSelectOption(section: Int, row:Int) {
        selectOption[section] = row
    }
    
    func isOptionSelected(section: Int, row:Int) -> Bool {
        return selectOption[section] == row
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
    
    
    func addToCart(completion: @escaping (Result<Void, AddToCartError>) -> Void) {
        
        guard selectOption[1] != nil &&
                selectOption[2] != nil else {
            completion(.failure(.iceOrSugarNoChoose("未選擇甜度／冰塊")))
            return
        }
        

        let addCartDrink = drinks.fields.name
        let iceSelected = iceChoice.allCases[selectOption[1]!].rawValue
        let sugarSelected = sugarChoice.allCases[selectOption[2]!].rawValue
        let qtySelected = selectQty
        let priceTotal = totalPrice
        
        guard let currentUser else {
            completion(.failure(.noCurrentUser("無法取得用戶資訊")))
            return
        }
        
        self.uploadOrder = Orders(records: [OrderRecords(fields: OrderFields(name: currentUser, drink: addCartDrink, sugar: sugarSelected, ice: iceSelected, price: priceTotal, qty: qtySelected))])
        completion(.success(()))
    }
    
    
    func uploadCartOrder(completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let url = URL(string: "https://api.airtable.com/v0/appvC935PME75LZRT/order") else {
            
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"無法創建URL"])))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(APIKey.default)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let uploadData = try? JSONEncoder().encode(uploadOrder) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"編碼失敗"])))
            return
        }
        
        urlRequest.httpBody = uploadData
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
            if let error {
                print(error.localizedDescription)
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"\(error.localizedDescription)"])))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if !(200...299).contains(httpResponse.statusCode) {
                    print(httpResponse.statusCode)
                    print("httpresponse error")
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"HttpResponse Error: \(httpResponse.statusCode)"])))
                    return
                }
                
            }
            
            guard let data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"無法獲取data"])))
                return
            }
            
            let decoder = JSONDecoder()
            if let createDataResponse = try? decoder.decode(OrderResponse.self, from: data) {
                print(createDataResponse)
                completion(.success(()))
            } else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"解碼失敗"])))
            }
            
        }.resume()
        
    }
    
}


