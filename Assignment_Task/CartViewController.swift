//
//  CartViewController.swift
//  Assignment_Task
//
//  Created by VAISHNAVI J on 22/07/24.
//

import UIKit
import CoreData
import Lottie
import SwiftyJSON

class CartViewController: UIViewController {
    
    var successAnimationView = LottieAnimationView()
    @IBOutlet weak var cartTableview: UITableView!
    @IBOutlet weak var successAnimationImage: UIImageView!
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var successBaseView: UIView!
    @IBOutlet weak var discountView: UIView!
    @IBOutlet weak var subtotalLbl: UILabel!
    @IBOutlet weak var discountLbl: UILabel!
    @IBOutlet weak var totalAmtLbl: UILabel!
    
    let discountAmt: Double = 40.0 //--- Change if needs in future.
    var cartData: [CartTable] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.discountLbl.text = "- \(currencySymbol)" + String(format: "%.2f", self.discountAmt)
        self.getAllCart()
    }
    
    func playanimation() {
        
        let path = Bundle.main.path(forResource: "success_point_animation",
                                    ofType: "json") ?? ""
        self.successAnimationView = LottieAnimationView.init(filePath: path)
        self.successAnimationView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        self.successAnimationView.center = CGPoint(x: self.successAnimationImage.bounds.midX, y: self.successAnimationImage.bounds.midY)
        self.successBaseView.isHidden = false
        self.successAnimationImage.addSubview(self.successAnimationView)
        self.successAnimationView.loopMode = .loop
        self.successAnimationView.play()
    }
    
    //MARK: RETRIEVE OPERATION --- Fetch CART
    func getAllCart() {
        do {
            let fetchRequest: NSFetchRequest<CartTable> = CartTable.fetchRequest()
            let searchDatas = try DB_Context.fetch(fetchRequest)
            
            if searchDatas.count > 0 {
                if self.cartData.count > 0 {
                    self.cartData.removeAll()
                }
                self.cartData = searchDatas // Assign fetched data directly
            }
            else {
                self.cartData = []
            }
        }
        catch {
            print("Error fetching data from CoreData: \(error)")
        }
        if self.cartData.count > 0 {
            // Calculate subtotal
            let subTotal = self.cartData.reduce(0.0) { $0 + Double($1.item_qty) * ceil($1.item_price) }
            self.subtotalLbl.text = "\(currencySymbol)\(String(format: "%.2f", subTotal))"
            
            // Calculate total amount with discount (if applicable)
            let totalAmt = subTotal > self.discountAmt ? subTotal - self.discountAmt : subTotal
            self.totalAmtLbl.text = "\(currencySymbol)\(String(format: "%.2f", totalAmt))"
            self.discountView.isHidden = !(subTotal > self.discountAmt)
        }
        else {
            self.discountView.isHidden = true
            self.subtotalLbl.text = "\(currencySymbol)0.00"
            self.totalAmtLbl.text = "\(currencySymbol)0.00"
        }
        self.noDataView.isHidden = (self.cartData.count > 0)
        self.cartTableview.reloadData()
    }
    
    @IBAction func didBackBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didCheckoutBtnTap(_ sender: Any) {
        COREDATA_MANAGER.ClearTable(entityName: CART_TABLE)
        self.playanimation()
    }
    
    @IBAction func didDoneBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cartData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartTableviewcell", for: indexPath) as! cartTableviewcell
        cell.addToCartBtn.tag = indexPath.row
        cell.addToCartBtn.addTarget(self, action: #selector(self.didTapAddToCart(_:)), for: .touchUpInside)
        cell.decreaseBtn.tag = indexPath.row
        cell.decreaseBtn.addTarget(self, action: #selector(self.didTapMinusBtn(_:)), for: .touchUpInside)
        let dict = self.cartData[indexPath.row]
        cell.cartProductName.text = dict.item_name
        cell.cartProductImg.sd_setImage(with: URL(string: dict.item_img ?? ""))
        cell.cartProductPrice.text = "\(currencySymbol)" + String(format: "%.2f", ceil(dict.item_price))
        cell.quantityLbl.text =  dict.item_qty < 10 ? "0\(dict.item_qty)" : "\(dict.item_qty)"
        let totalPrice = Double(Double(dict.item_qty) * ceil(dict.item_price))
        print("The totalPrice is \(totalPrice)")
        cell.totalPrice.text = "\(currencySymbol)" + String(format: "%.2f", totalPrice)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            self.showAlertView(title: APPNAME, message: "Are you sure want to remove \"\(self.cartData[indexPath.row].item_name ?? "")\" from cart?", positiveActionTitle: "Yes", negativeActionTitle: "No") { (yesclick) in
                if yesclick {
                    COREDATA_MANAGER.removeFromCart(itemID: self.cartData[indexPath.row].item_id)
                    self.getAllCart()
                }
            }
        }
        deleteAction.image = UIImage(systemName: "trash") // Added the delete image
        return UISwipeActionsConfiguration(actions: [deleteAction]) // Return the delete Action
    }
    
    @objc func didTapAddToCart(_ sender: UIButton) {
        let existingQty = COREDATA_MANAGER.GetProductQty(itemID: self.cartData[sender.tag].item_id)
        self.adjustQty(position: sender.tag, Qty: existingQty + 1)
    }
    
    @objc func didTapMinusBtn(_ sender: UIButton) {
        let existingQty = COREDATA_MANAGER.GetProductQty(itemID: self.cartData[sender.tag].item_id)
        if existingQty > 1 {
            self.adjustQty(position: sender.tag, Qty: existingQty - 1)
        }
        else {
            self.showAlertView(title: APPNAME, message: "Are you sure want to remove \"\(self.cartData[sender.tag].item_name ?? "")\" from cart?", positiveActionTitle: "Yes", negativeActionTitle: "No") { (yesclick) in
                if yesclick {
                    COREDATA_MANAGER.removeFromCart(itemID: self.cartData[sender.tag].item_id)
                    self.getAllCart()
                }
            }
        }
    }
    
    func adjustQty(position: Int, Qty: Int32) {
        let itemModel = itemsModel(fromJson: JSON())
        itemModel.id = self.cartData[position].item_id
        itemModel.name = self.cartData[position].item_name
        itemModel.icon = self.cartData[position].item_img
        itemModel.price = self.cartData[position].item_price
        COREDATA_MANAGER.addCartData(rData: itemModel, QtyCount: Qty)
        self.getAllCart()
    }
}



