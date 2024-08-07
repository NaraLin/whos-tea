//
//  Observable.swift
//  whos tea
//
//  Created by 林靖芳 on 2024/7/31.
//

import Foundation

class Observable<T> {
    
    var value: T{
        didSet{
            listener?(value)
        }
        
    }
    
    private var listener: ((T) -> Void)?
    
    init(_ value:T){
        self.value = value
    }
    
    func bind(listener: @escaping (T) -> Void) {
        listener(value)
        self.listener = listener
        
    }
}



