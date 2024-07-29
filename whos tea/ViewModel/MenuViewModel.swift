//
//  MenuViewModel.swift
//  whos tea
//
//  Created by 林靖芳 on 2024/7/26.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class MenuViewModel {
    
    var drinks = [Records]()
    var categories = [String]()
    var filterDrinks = [Records]()
    var handle: AuthStateDidChangeListenerHandle?
   
    //NSCache類似dictionary，有key&Value，型別都必須是物件，只能傳入 class 定義的型別(所以不能URL，只能NSURL)
    //NSCache 比較不會造成記憶體的問題，因為當系統記憶體不夠時，它會自動將東西從 cache 裡移除，也可以限制它可以儲存的東西數量(設定它的 countLimit)
    let imageCache = NSCache<NSURL, UIImage>()
    
    
    func fetchData(completion: @escaping (Result<Void, FetchDataError>) -> Void){
        
        FetchDataManager.shared.fetchData { [weak self] result in
            
            guard let strongSelf = self else {
                return
            }
            
            switch result {
                case .success(let data):
                    strongSelf.drinks = data.records
                    
                    //.map : $0 = records 第一個array，由裡面的特定值組成一個新 array
                    //for segCtrl use
                    let allCategory = data.records.map {$0.fields.type}
                    //Set去重複
                    let allCategorySet = Set(allCategory)
                    //Set -> Array + sorted排序
                    let allCategorySorted = Array(allCategorySet).sorted()
                    
                    strongSelf.categories = allCategorySorted
                    //第一個segment飲料
                    strongSelf.filterDrinks = strongSelf.drinks.filter{ $0.fields.type == "原味茶" }
                    
                    completion(.success(()))
                    
                    
                case .failure(let error):
                    completion(.failure(error))
            }
            
        }
   
    }
    
    
    
    func setupSegctrl(segCtrl: UISegmentedControl){
        
        // 清空之前的 segments
        segCtrl.removeAllSegments()
        
        //segment setting
        for (index, category) in categories.enumerated() {
            segCtrl.insertSegment(withTitle: category, at: index, animated: false)
        }
        
        segCtrl.selectedSegmentIndex = 0

    }
    
    func segmentChange(segCtrl: UISegmentedControl) {

        let selectCategory = categories[segCtrl.selectedSegmentIndex]
        
        //update filterDrinks
        filterDrinks = drinks.filter { $0.fields.type == selectCategory}
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
    
    
    func addAuthStateListener(viewController: UIViewController){
        
        //監聽登入狀態
        handle = Auth.auth().addStateDidChangeListener { auth, fireUser in
            
            guard fireUser == nil else {
                return
            }
            
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            viewController.present(nav, animated: true)
            
        }
    }
    
    //移除監聽
    func removeAuthStateListener() {
            if let handle = handle {
                Auth.auth().removeStateDidChangeListener(handle)
            }
        }
    
    
    
}


