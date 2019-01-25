//
//  CartViewController.swift
//  MokaPos
//
//  Created by paras gorasiya on 24/1/19.
//  Copyright © 2019 paras gorasiya. All rights reserved.
//

import Foundation
import UIKit

class CartViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    static let cellId: String = "CartTableViewCell"
    weak var delegate: OptionsListViewDelegate?
    var cartItems: [Cart]?
    var viewModal: CartViewModal?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.viewModal = CartViewModal(delegate: self)
    }
}


extension CartViewController: CartViewModalDelegate {
    func setCartItems(data: [Cart]) {
        self.cartItems = data
        
        let cart1 = Cart()
        cart1.productName = "Subtotal"
        cart1.price = 1000
        
        let cart2 = Cart()
        cart2.productName = "Discount"
        cart2.price = 100
        
        self.cartItems?.append(cart1)
        self.cartItems?.append(cart2)
    }
    
    func setEmptyCart() {
        
    }
}


extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cartItems?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentOption = self.cartItems![indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CartViewController.cellId, for: indexPath) as! CartTableViewCell
        cell.updateCellWith(data: currentOption)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
