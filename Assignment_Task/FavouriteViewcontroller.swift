//
//  FavouriteViewController.swift
//  Assignment_Task
//
//  Created by VAISHNAVI J on 22/07/24.
//

import UIKit
import SwiftyJSON

class FavouriteViewcontroller: UIViewController {
    
    @IBOutlet weak var favouriteTableView: UITableView!
    @IBOutlet weak var noDataView: UIView!
    
    var favouriteData: [itemsModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getAllFavourites()
    }
    
    //MARK: RETRIEVE OPERATION --- Fetch FavouriteData
    func getAllFavourites() {
        do {
            //Fetch all the Favourite data from CoreData to show favorite heart
            let searchDatas = try DB_Context.fetch(FavoriteTable.fetchRequest())
            if searchDatas.count > 0 {
                if self.favouriteData.count > 0 {
                    self.favouriteData.removeAll()
                }
                
                for productItem in searchDatas {
                    let favModel = itemsModel(fromJson: JSON())
                    favModel.id = productItem.item_id
                    favModel.name = productItem.item_name
                    favModel.icon = productItem.item_img
                    favModel.price = productItem.item_price
                    self.favouriteData.append(favModel)
                }
            }
            else {
                self.favouriteData = []
            }
            self.favouriteTableView.reloadData()
            self.noDataView.isHidden = self.favouriteData.count > 0
        }
        catch {
            print("Error in Fetching Data from CoreData :--->\(error)")
        }
    }
    
    @IBAction func didBackBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension FavouriteViewcontroller: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favouriteData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favouritetableviewcell", for: indexPath) as! favouritetableviewcell
        let dict = self.favouriteData[indexPath.row]
        cell.productName.text = dict.name
        cell.productPrice.text = "\(currencySymbol)" + String(format: "%.1f", dict.price)
        cell.productImg.sd_setImage(with: URL(string: dict.icon))
        cell.heartBtn.setOn(true, animated: false)
        cell.favouriteBtn.tag = indexPath.row
        cell.favouriteBtn.addTarget(self, action: #selector(self.didTapRemoveFavourite(_:)), for: .touchUpInside)
        cell.addToCartBtn.tag = indexPath.row
        cell.addToCartBtn.addTarget(self, action: #selector(self.didTapAddToCart(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    @objc func didTapRemoveFavourite(_ sender: UIButton) {
        let iDict = self.favouriteData[sender.tag]
        self.favouriteData.remove(at: sender.tag)
        COREDATA_MANAGER.removeFavouriteData(itemID: iDict.id)
        self.favouriteTableView.reloadData()
        self.noDataView.isHidden = self.favouriteData.count > 0
    }
    
    @objc func didTapAddToCart(_ sender: UIButton) {
        let iDict = self.favouriteData[sender.tag]
        let existingQty = COREDATA_MANAGER.GetProductQty(itemID: iDict.id)
        COREDATA_MANAGER.addCartData(rData: iDict, QtyCount: existingQty + 1)
        self.view.make(toast: "Item added to cart")
    }
}
