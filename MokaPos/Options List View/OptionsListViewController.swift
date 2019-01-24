//
//  OptionsListViewController.swift
//  MokaPos
//
//  Created by paras gorasiya on 24/1/19.
//  Copyright © 2019 paras gorasiya. All rights reserved.
//

import Foundation
import UIKit

protocol OptionsListViewDelegate: class {
    func didSelectOptionAt(index: Int)
}


class OptionsListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    static let cellId: String = "OptionsTableViewCell"
    weak var delegate: OptionsListViewDelegate?
    var posOptions: [OptionsModel]?
    var viewModal: OptionsViewModal?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.viewModal = OptionsViewModal(delegate: self)
        self.viewModal?.createOptionsModel()
    }
}


extension OptionsListViewController: OptionsViewModalDelegate {
    
    func setOptions(data: [OptionsModel]) {
        self.posOptions = data
        self.tableView.reloadData()
    }
}


extension OptionsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posOptions?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentOption = self.posOptions![indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: OptionsListViewController.cellId, for: indexPath)
        cell.textLabel?.text = currentOption.title
        cell.imageView?.image = UIImage(named: currentOption.imageName)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.didSelectOptionAt(index: indexPath.row)
    }
}
