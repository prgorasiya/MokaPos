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
    
    weak var delegate: OptionsListViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


extension OptionsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.didSelectOptionAt(index: indexPath.row)
    }
}
