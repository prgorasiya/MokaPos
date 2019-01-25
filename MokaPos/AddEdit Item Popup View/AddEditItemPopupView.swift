//
//  AddEditItemPopupView.swift
//  MokaPos
//
//  Created by paras gorasiya on 25/1/19.
//  Copyright © 2019 paras gorasiya. All rights reserved.
//

import Foundation
import UIKit

protocol AddEditPopupDelegate: class {
    func itemDetailsSaved(productId: Int, quantity: Int, discountId: Int)
}

class AddEditItemPopupView: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var discountCollectionView: UICollectionView!
    
    weak var delegate: AddEditPopupDelegate?
    var productId: Int!
    var updatedProductId: Int?
    
    var quantity: Int = 1
    var updatedQuantity: Int = 0 {
        didSet {
            self.quantityLabel.text = String(updatedQuantity)
        }
    }
    
    var discountId: Int?
    var updatedDiscountId: Int?
    
    static let cellId: String = "DiscountCollectionViewCell"
    var item: Item?
    //fetching all discoutns from userdefaults
    var allDiscounts: [DiscountModel] = UserDefaults.standard.retrieve(object: [DiscountModel].self, fromKey: StaticKeys.allDiscounts)!
    var viewModal: AddEditPopupViewModal?
    
    let rows = 2
    let columnsInPage = 2
    var itemsInPage: Int { return columnsInPage*rows }
    var columns: Int { return allDiscounts.count%itemsInPage <= columnsInPage ? ((allDiscounts.count/itemsInPage)*columnsInPage)  + (allDiscounts.count%itemsInPage) : ((allDiscounts.count/itemsInPage)+1)*columnsInPage }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.viewModal = AddEditPopupViewModal(delegate: self)
        self.viewModal?.fetchItemFromDatabase(productId: productId)
    }
    
    
    //MARK: UI update methods
    func updateUIFromCurrentItem() {
        self.updateQuantity(value: quantity)
        self.updateName(value: (item?.title)!)
        self.updatePrice(value: (item?.price)!)
        
        let total = (item?.price)! * Double(quantity)
        self.updateTotalPrice(value: total)
    }
    
    
    func updateQuantity(value: Int) {
        self.quantityLabel.text = String(value)
    }
    
    
    func updateName(value: String) {
        self.productNameLabel.text = value
    }
    
    
    func updatePrice(value: Double) {
        self.priceLabel.text = String(format: "$%f", value)
    }
    
    
    func updateTotalPrice(value: Double) {
        self.totalPriceLabel.text = String(format: "$%f", value)
    }
    
    
    //MARK: UIControl action methods
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        self.updatedQuantity = Int(sender.value)
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.removeAnimated()
    }
    
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        self.delegate?.itemDetailsSaved(productId: productId, quantity: updatedQuantity, discountId: updatedDiscountId)
    }
    
    
    //MARK: View show/hide methods
    func showAnimated() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    
    func removeAnimated() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished){
                self.view.removeFromSuperview()
            }
        });
    }
}


extension AddEditItemPopupView: AddEditPopupModalDelegate {
    func setItem(data: Item) {
        self.item = data
        self.updateUIFromCurrentItem()
        self.showAnimated()
    }
}


extension AddEditItemPopupView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return columns * rows
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Calculating current item index based on grouping
        let t = indexPath.item / itemsInPage
        let i = indexPath.item / rows - t*columnsInPage
        let j = indexPath.item % rows
        let item = (j*columnsInPage+i) + t*itemsInPage
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddEditItemPopupView.cellId, for: indexPath) as! DiscountCollectionViewCell
        cell.delegate = self
        
        let currentDiscount = allDiscounts[item]
        let shouldApplyDiscount = discountId == currentDiscount.id
        cell.updateCellWith(data: currentDiscount, applyDiscount: shouldApplyDiscount)
        
        return cell
    }
}


extension AddEditItemPopupView: DiscountCollectionViewCellDelegate {
    func switchValueDidChangeAt(index: Int) {
        self.updatedDiscountId = index
    }
}
