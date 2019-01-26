//
//  ApiManager.swift
//  MokaPos
//
//  Created by paras gorasiya on 24/1/19.
//  Copyright © 2019 paras gorasiya. All rights reserved.
//

import Foundation
import UIKit


class ApiManager: NSObject {
    
    static let sharedInstance: ApiManager = {
        let instance = ApiManager()
        return instance
    }()
    
    
    func getWebServiceUrl(serviceName: String) -> String{
        return String(format: "%@/%@", MyAPI.kBaseUrl, serviceName)
    }
    
    
    func getData(_ urlString: String, withCompletion completion: @escaping ([[String: Any]]?) -> Void) {
        if Network.isConnected() {
            let url = self.getWebServiceUrl(serviceName: urlString)
            let urlRequest = URLRequest(url: URL(string: url)!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 60.0)
            URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                guard error == nil else {
                    completion(nil)
                    return
                }

                guard let responseData = data else {
                    completion(nil)
                    return
                }

                // parsing the result as JSON
                do {
                    guard let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [[String: Any]] else {
                        completion(nil)
                        return
                    }
                    completion(json)
                } catch  {
                    print("error trying to convert data to JSON")
                }
                }.resume()
        }
        else{
            DispatchQueue.main.async {
                let alert = UIAlertController(title: nil, message: "No Internet!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                MyDelegate.appDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
            }
            completion(nil)
        }
    }
}
