//
//  URLExtension.swift
//  Sniff
//
//  Created by Andrea Ferrando on 14/10/2016.
//  Copyright © 2016 Matchbyte. All rights reserved.
//

import Foundation

extension URL {
    
    func getDataFromUrl(completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: self) {
            (data, response, error) in
            completion(data, response, error)
        }.resume()
    }
    
}
