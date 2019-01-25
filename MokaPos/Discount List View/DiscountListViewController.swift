//
//  DiscountListViewController.swift
//  MokaPos
//
//  Created by paras gorasiya on 24/1/19.
//  Copyright © 2019 paras gorasiya. All rights reserved.
//

import Foundation
import UIKit

class DiscountListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    static let cellId: String = "DiscountTableViewCell"
    var discounts: [DiscountModel]?
    var viewModal: DiscountListViewModal?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "All Discounts"
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: DiscountListViewController.cellId)
        self.viewModal = DiscountListViewModal(delegate: self)
        self.viewModal?.getDiscountList()
    }
}


extension DiscountListViewController: DiscountListModalDelegate {
    func setDiscounts(data: [DiscountModel]) {
        self.discounts = data
        self.tableView.reloadData()
    }
}


extension DiscountListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.discounts?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentOption = self.discounts![indexPath.row]
        
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: DiscountListViewController.cellId)
        cell.textLabel?.text = currentOption.title
        cell.detailTextLabel?.text = String(format: "%.2f%%", currentOption.value)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
