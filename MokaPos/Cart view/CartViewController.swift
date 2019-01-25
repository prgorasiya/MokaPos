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
    @IBOutlet weak var emptyCartLabel: UILabel!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var chargeButton: UIButton!
    @IBOutlet weak var tableBottomConstraint: NSLayoutConstraint!
    
    static let cellId: String = "CartTableViewCell"
    weak var delegate: OptionsListViewDelegate?
    var cartItems: [Cart]?
    var viewModal: CartViewModal?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Shopping Cart"
        self.tableView.tableFooterView = UIView()
        self.viewModal = CartViewModal(delegate: self)
        self.viewModal?.fetchCartItems()
    }
    
    
    @IBAction func clearCartTapped(_ sender: Any) {
        self.viewModal?.emptyCart()
    }
}


extension CartViewController: CartViewModalDelegate {
    func setCartItems(data: [Cart]) {
        self.tableView.isHidden = false
        self.emptyCartLabel.isHidden = true
        self.clearButton.isHidden = false
        self.chargeButton.isHidden = false
        self.cartItems = data
        self.tableBottomConstraint.constant = 115
        self.tableView.reloadData()
    }
    
    func setEmptyCart() {
        self.cartItems?.removeAll()
        self.tableView.isHidden = true
        self.emptyCartLabel.isHidden = false
        self.clearButton.isHidden = true
        self.chargeButton.isHidden = true
        self.tableBottomConstraint.constant = 0
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


extension CartViewController: AddEditPopupDelegate {
    func itemUpdatedWith(productId: Int, quantity: Int, discountId: Int) {
        
    }
}
