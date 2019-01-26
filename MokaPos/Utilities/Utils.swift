//
//  Utils.swift
//  MokaPos
//
//  Created by paras gorasiya on 24/1/19.
//  Copyright © 2019 paras gorasiya. All rights reserved.
//


import Foundation
import UIKit

struct StaticKeys {
    static let allDiscounts = "AllDiscounts"
    static let productId = "productId"
    static let price = "price"
    static let quantity = "quantity"
    static let discountId = "discountId"
    static let discountValue = "discountValue"
    static let productName = "productName"
}


struct MyDelegate {
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
}


struct MyAPI {
    static let kBaseUrl: String = "https://jsonplaceholder.typicode.com"
    static let kService_Get_Items: String = "photos?_limit=50"
}


let imageCache = NSCache<NSString, UIImage>()
extension UIImageView {
    //UIImageView extension method for image caching
    func loadImageUsingCache(withUrl urlString : String?) {
        if urlString == nil || !Network.isConnected() {
            self.image = UIImage().coloredImage(color: .lightGray)
            return
        }
        let url = URL(string: urlString!)
        if url == nil {return}
        self.image = nil
        
        // check cached image
        if let cachedImage = imageCache.object(forKey: urlString! as NSString)  {
            self.image = cachedImage
            return
        }
        
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView.init(style: .gray)
        addSubview(activityIndicator)
        activityIndicator.startAnimating()
        activityIndicator.center = self.center
        
        // if not, download image from url
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: urlString! as NSString)
                    self.image = image
                    activityIndicator.removeFromSuperview()
                }
            }
        }).resume()
    }
}


extension UIImage {
    public func coloredImage(color: UIColor) -> UIImage? {
        return coloredImage(color: color, size: CGSize(width: 1, height: 1))
    }
    
    
    //Creating colored placeholder image
    public func coloredImage(color: UIColor, size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(origin: CGPoint(), size: size))
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return image
    }
}


extension UserDefaults {
    //Generic UserDefaults extension method to save data after encoding
    //Using JSONEncoder here to encode (Can use NSKeyedArchiever as well)
    func save<T:Encodable>(customObject object: T, inKey key: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(object) {
            self.set(encoded, forKey: key)
        }
    }
    
    
    //Generic UserDefaults extension method to retrieve data
    func retrieve<T:Decodable>(object type:T.Type, fromKey key: String) -> T? {
        if let data = self.data(forKey: key) {
            let decoder = JSONDecoder()
            if let object = try? decoder.decode(type, from: data) {
                return object
            }
            else {
                print("Couldnt decode object")
                return nil
            }
        }
        else {
            print("Couldnt find key")
            return nil
        }
    }
    
}
