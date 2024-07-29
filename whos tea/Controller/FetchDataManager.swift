//
//  FetchDataManager.swift
//  whos tea
//
//  Created by 林靖芳 on 2024/7/1.
//

import Foundation


enum FetchDataError: Error {
    
    case urlError(String)
    case sessionError(String)
    case decodeError(String)
    
}


class FetchDataManager {
    
    static let shared = FetchDataManager()
    
    func fetchData(completion: @escaping (Result<Menu,FetchDataError>) -> Void) {
        
        guard let url = URL(string: "https://api.airtable.com/v0/appvC935PME75LZRT/menu") else {
            //url error
            completion(.failure(.urlError("api URL error")))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        urlRequest.setValue("Bearer \(APIKey.default)", forHTTPHeaderField: "Authorization")

        let decoder = JSONDecoder()
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
 
            if let error {
                completion(.failure(.sessionError(error.localizedDescription)))
                return
            }

            if let data {
                print("data exist")
                
                do {
                    let drinkData = try decoder.decode(Menu.self, from: data)
                    completion(.success(drinkData))

                }
                
                catch {
                    completion(.failure(.decodeError("decode error")))
                }
            }

        }.resume()
             
        
    }
    
    
}
