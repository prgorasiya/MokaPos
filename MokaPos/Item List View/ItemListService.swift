//
//  ItemListService.swift
//  MokaPos
//
//  Created by paras gorasiya on 24/1/19.
//  Copyright © 2019 paras gorasiya. All rights reserved.
//

import Foundation

class ItemListService {
    
    //Get items from API
    func getItemsData( _ callBack:@escaping ([[String: Any]]?) -> Void){
        let url = MyAPI.kService_Get_Items
        ApiManager.sharedInstance.getData(url) { (response) in
            DispatchQueue.main.async {
                guard let data = response else {
                    callBack(nil)
                    return
                }
                callBack(data)
            }
        }
    }
}
