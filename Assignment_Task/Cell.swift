//
//  Cell.swift
//  Assignment_Task
//
//  Created by VAISHNAVI J on 24/07/24.
//

import UIKit
import CoreData
import HeartButton

//MARK: --- PRODUCTS CELL
class categoryTableviewcell: UITableViewCell {
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var toggleBtn: UIButton!
    @IBOutlet weak var itemsView: UIView!
    @IBOutlet weak var subCategoryCollectionView: UICollectionView!
    var productItems: [itemsModel] = []
    var favouriteData: [itemsModel] = []
    
    func showAddToCartToast() {
        if let viewController = self.topMostViewController() as? HomeViewController {
            viewController.view.make(toast: "Item added to cart")
        }
    }
}

//MARK: --- CATEGORIES NAME CELL
class categoryNameTableviewcell: UITableViewCell {
    @IBOutlet weak var categoryName: UILabel!
}

//MARK: --- ITEMS CELL
class subCategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var heartBtn: HeartButton!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var addToCartBtn: UIButton!
}

//MARK: --- FAVOURITE TABLE
class favouritetableviewcell: UITableViewCell {
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var favouriteBtn: UIButton!
    @IBOutlet weak var heartBtn: HeartButton!
    @IBOutlet weak var addToCartBtn: UIButton!
}

//MARK: --- CART TABLE
class cartTableviewcell: UITableViewCell {
    @IBOutlet weak var cartProductImg: UIImageView!
    @IBOutlet weak var cartProductName: UILabel!
    @IBOutlet weak var cartProductPrice: UILabel!
    @IBOutlet weak var decreaseBtn: UIButton!
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var addToCartBtn: UIButton!
    @IBOutlet weak var totalPrice: UILabel!
}
