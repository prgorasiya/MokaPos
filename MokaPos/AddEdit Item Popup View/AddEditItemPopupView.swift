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
    func itemUpdatedWith(productId: Int, quantity: Int, discountId: Int, updatedDiscountId: Int)
}

class AddEditItemPopupView: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var quantityStepper: UIStepper!
    @IBOutlet weak var discountCollectionView: UICollectionView!
    
    weak var delegate: AddEditPopupDelegate?
    var productId: Int!
    var updatedProductId: Int?
    
    var quantity: Int = 1
    var updatedQuantity: Int = 1 {
        didSet {
            self.quantityLabel.text = String(updatedQuantity)
            let total = (item?.price)! * Double(updatedQuantity)
            self.updateTotalPrice(value: total)
        }
    }
    
    var discountId: Int = 0
    var updatedDiscountId: Int?
    
    static let cellId: String = "DiscountCollectionViewCell"
    var item: Item?
    //fetching all discoutns from userdefaults
    var allDiscounts: [DiscountModel] = UserDefaults.standard.retrieve(object: [DiscountModel].self, fromKey: StaticKeys.allDiscounts)!
    var viewModal: AddEditPopupViewModal?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //using "updatedDiscountId" to keep track of discount change for existing cart item
        self.updatedDiscountId = self.discountId
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.viewModal = AddEditPopupViewModal(delegate: self)
        self.viewModal?.fetchItemFromDatabase(productId: productId)
    }
    
    
    //MARK: UI update methods
    func updateUIFromCurrentItem() {
        self.updateName(value: (item?.title)!)
        self.updatePrice(value: (item?.price)!)
        self.updateQuantity(value: quantity)
        self.updateStepperInitialValue(value: Double(quantity))
        
        let total = (item?.price)! * Double(quantity)
        self.updateTotalPrice(value: total)
    }
    
    
    func updateName(value: String) {
        self.productNameLabel.text = value
    }
    
    
    func updatePrice(value: Double) {
        self.priceLabel.text = String(format: "$%.1f", value)
    }
    
    
    func updateStepperInitialValue(value: Double) {
        self.quantityStepper.value = value
    }
    
    
    func updateQuantity(value: Int) {
        self.quantityLabel.text = String(value)
    }
    
    
    func updateTotalPrice(value: Double) {
        self.totalPriceLabel.text = String(format: "$%.1f", value)
    }
    
    
    //MARK: UIControl action methods
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        self.updatedQuantity = Int(sender.value)
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.removeAnimated()
    }
    
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        self.delegate?.itemUpdatedWith(productId: productId, quantity: updatedQuantity, discountId: discountId, updatedDiscountId: updatedDiscountId!)
        self.removeAnimated()
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
        self.discountCollectionView.reloadData()
    }
}


extension AddEditItemPopupView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allDiscounts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddEditItemPopupView.cellId, for: indexPath) as! DiscountCollectionViewCell
        
        let currentDiscount = allDiscounts[indexPath.item]
        let shouldApplyDiscount = updatedDiscountId == currentDiscount.id
        cell.updateCellWith(data: currentDiscount, applyDiscount: shouldApplyDiscount)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.updatedDiscountId == indexPath.item + 1 {
            self.updatedDiscountId = 0
        }
        else {
            self.updatedDiscountId = indexPath.item + 1
        }
        self.discountCollectionView.reloadData()
    }
}


extension AddEditItemPopupView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/2, height: collectionView.frame.size.height/2)
    }
}
