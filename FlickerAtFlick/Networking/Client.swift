//
//  Client.swift
//  FlickerAtFlick
//
//  Created by sriharshay on 28/09/19.
//  Copyright © 2019 harsha. All rights reserved.
//

import Foundation

class Client {
    
    func requestResource(urlString: String, dataHandler: @escaping (_ data: Data) -> Void, errorHandler: @escaping (_ error: Error) -> Void) {
        guard let requestUrl = URL(string:urlString) else { return }
        var request = URLRequest(url:requestUrl)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if error != nil {
                DispatchQueue.main.async {
                    errorHandler(error!)
                }
            }
            if let usableData = data {
                DispatchQueue.main.async {
                    dataHandler(usableData)
                }
            }
        }
        task.resume()
    }
    

}
