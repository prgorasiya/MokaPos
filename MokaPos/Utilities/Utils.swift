//
//  Utils.swift
//  MokaPos
//
//  Created by paras gorasiya on 24/1/19.
//  Copyright © 2019 paras gorasiya. All rights reserved.
//

import Foundation
import UIKit


struct MyDelegate {
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
}


struct MyAPI {
    static let kBaseUrl: String = "https://jsonplaceholder.typicode.com"
    static let kService_Get_Items: String = "photos?_limit=50"
}


struct DeviceSize {
    static let deviceWidth = UIScreen.main.bounds.width
    static let deviceHeight = UIScreen.main.bounds.height
}


let imageCache = NSCache<NSString, UIImage>()
extension UIImageView {
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
    
    
    public func coloredImage(color: UIColor, size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(origin: CGPoint(), size: size))
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return image
    }
}
