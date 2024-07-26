//
//  Drinks.swift
//  whos tea
//
//  Created by 林靖芳 on 2024/6/28.
//

import Foundation


struct Menu: Codable {
    let records: [Records]
}

struct Records: Codable {
    let fields: Fields
}

struct Fields: Codable {
    let type: String
    let name: String
    let mediumSizePrice: String?
    let largeSizePrice: String?
    let teaKind: [String]?
    let image: URL?
    
}


//sugar
enum sugarChoice: String, CaseIterable {
    
    case full = "全糖"
    case half = "半糖"
    case quarter = "微糖"
    case low = "一分糖"
    case none = "無糖"
    
}

//ice
enum iceChoice: String, CaseIterable {
    
    case full = "正常冰"
    case less = "少冰"
    case none = "去冰"
}


enum orderSection: String, CaseIterable {
    
    case section1 = "您的飲料"
    case section2 = "選擇冰塊"
    case section3 = "選擇甜度"
    
}
