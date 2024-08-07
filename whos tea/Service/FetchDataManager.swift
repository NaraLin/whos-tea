//
//  FetchDataManager.swift
//  whos tea
//
//  Created by 林靖芳 on 2024/7/1.
//

import Foundation



class FetchDataManager {
    
    static let shared = FetchDataManager()
    
    func fetchData(url: GetUrl, completion: @escaping (Result<Data,Error>) -> Void) {
        
        guard let url = URL(string: url.rawValue) else {
            //url error
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"api URL error"])))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        urlRequest.setValue("Bearer \(APIKey.default)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
 
            if let error {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"\(error.localizedDescription)"])))
                return
            }
            
            if let data {
                print("data exist")
                completion(.success(data))
            }
            
        }.resume()
        
        
    }
    
    
}
