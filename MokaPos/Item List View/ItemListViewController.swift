//
//  ItemListViewController.swift
//  MokaPos
//
//  Created by paras gorasiya on 24/1/19.
//  Copyright © 2019 paras gorasiya. All rights reserved.
//

import Foundation
import UIKit

protocol SelectItemDelegate: class {
    var isUpdatingCartItem: Bool {get set}
    func didSelectItemWith(productId: Int, quantity: Int, discountId: Int)
}


class ItemListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    
    weak var delegate: SelectItemDelegate?
    static let cellId: String = "ItemTableViewCell"
    var items: [Item]?
    var viewModal: ItemListViewModal?
    var service: ItemListService = ItemListService()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "All Items"
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: OptionsListViewController.cellId)
        self.viewModal = ItemListViewModal(service: service, delegate: self)
        self.viewModal?.fetchAllItems()
    }
}


extension ItemListViewController: ItemListViewModalDelegate {
    func startLoading() {
        activityIndicator!.startAnimating()
    }
    
    func finishLoading() {
        activityIndicator!.stopAnimating()
    }
    
    func setItems(data: [Item]) {
        self.items = data
        self.tableView.reloadData()
    }
    
    func setEmptyItems() {
        
    }
}


extension ItemListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentOption = self.items![indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ItemListViewController.cellId, for: indexPath) as! ItemTableViewCell
        cell.updateCellWith(data: currentOption)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selected = self.items![indexPath.row]
        self.delegate?.isUpdatingCartItem = false
        self.delegate?.didSelectItemWith(productId: Int(selected.id), quantity: 1, discountId: 0)
    }
}
