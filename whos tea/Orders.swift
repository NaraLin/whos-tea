//
//  Orders.swift
//  whos tea
//
//  Created by 林靖芳 on 2024/7/4.
//

import Foundation

//GET
struct GetOrder: Codable {
    let records: [GetOrderRecords]
}

struct GetOrderRecords: Codable, Hashable {
    
    var id: String
    var fields: OrderFields
    
    //equatable function
    static func == (lhs: GetOrderRecords, rhs: GetOrderRecords) -> Bool {
        return lhs.fields.name == rhs.fields.name &&
        lhs.fields.drink == rhs.fields.drink &&
        lhs.fields.sugar == rhs.fields.sugar &&
        lhs.fields.ice == rhs.fields.ice
    }
    
    //hashable function，讓自訂型別可以當作dictionary的key型別，利用hashvalue判斷是否有重複的element
    //name, drink, sugar 和 ice 屬性的值组合成一個hash值
    func hash(into hasher: inout Hasher) {
        hasher.combine(fields.name)
        hasher.combine(fields.sugar)
        hasher.combine(fields.ice)
        hasher.combine(fields.drink)
    }
    
    
}

//Consolidate Get Order
struct ConsolidateOrder: Codable {
    let records: [ConsolidateOrderRecords]
}

struct ConsolidateOrderRecords: Codable, Comparable {
    
    var id: [String]
    var fields: OrderFields
    
    //comparable function，可sorted()排序
    static func < (lhs: ConsolidateOrderRecords, rhs: ConsolidateOrderRecords) -> Bool {
        
        if lhs.fields.drink == rhs.fields.drink {
                if lhs.fields.totalPrice == rhs.fields.totalPrice {
                    if lhs.fields.ice == rhs.fields.ice {
                        if lhs.fields.sugar == rhs.fields.sugar {
                            return lhs.fields.name < rhs.fields.name
                        }
                        return lhs.fields.sugar < rhs.fields.sugar
                    }
                    return lhs.fields.ice < rhs.fields.ice
                }
                return lhs.fields.totalPrice < rhs.fields.totalPrice
            }
            return lhs.fields.drink < rhs.fields.drink
        
    }
    
    //equatable function
    static func == (lhs: ConsolidateOrderRecords, rhs: ConsolidateOrderRecords) -> Bool {
        return lhs.fields.name == rhs.fields.name &&
        lhs.fields.drink == rhs.fields.drink &&
        lhs.fields.sugar == rhs.fields.sugar &&
        lhs.fields.ice == rhs.fields.ice
    }
    
  
}



//POST
struct Orders: Codable{
    let records: [OrderRecords]
}

struct OrderRecords: Codable {
    var fields: OrderFields
}

//common
struct OrderFields: Codable{
    let name: String
    let drink: String
    let sugar: String
    let ice: String
    let price: Int
    var qty: Int
    var totalPrice: Int{
        qty * price
    }
}

//POST response
struct OrderResponse:Decodable{
    let records: [OrderResponseRecords]
}

struct OrderResponseRecords: Decodable {  
    let id: String
}

//Delete Response
struct DeleteOrder:Decodable {
    let records: [DeleteRecord]
}

struct DeleteRecord:Decodable {
    let deleted: Bool
    let id: String
    
}
