//
//  HomeViewControler.swift
//  Assignment_Task
//
//  Created by VAISHNAVI J on 22/07/24.
//

import UIKit
import SwiftyJSON
import SDWebImage
import SideMenu

class HomeViewController: UIViewController {
    
    var allData = [dataModel]()
    var catagoriesData: [categoriesModel] = []
    var favouriteData: [itemsModel] = []
    
    @IBOutlet weak var topView: GradientView!
    @IBOutlet weak var cartCountLbl: UILabel!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryBtnView: UIView!
    @IBOutlet weak var categoryTableview: UITableView!
    @IBOutlet weak var categoryNameTableview: UITableView!
    @IBOutlet weak var categoryNameTableviewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.topView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner] //Set CornerRadius for specific corners
        self.setupSideMenu()
        NotificationCenter.default.addObserver(self, selector: #selector(self.fetchFavourites(notification:)), name: Notification.Name("FavoritesChanged"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.cartUpdate(notification:)), name: Notification.Name("CartChanged"), object: nil)
    }
    
    //MARK: Setup SideMenu
    fileprivate func setupSideMenu() {
        if self.navigationController != nil {
            SideMenuManager.default.leftMenuNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? SideMenuNavigationController
            SideMenuManager.default.addPanGestureToPresent(toView: self.navigationController!.navigationBar)
            SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: (self.view)!)
            SideMenuManager.default.leftMenuNavigationController?.menuWidth = 280
            //SideMenuManager.default.menuFadeStatusBar = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getAllFavourites()
        self.retrieveData()
        self.setupCartCount()
    }
    
    @objc func cartUpdate(notification: Notification) {
        self.setupCartCount()
    }
    
    @objc func fetchFavourites(notification: Notification) {
        self.getAllFavourites()
    }
    
    func setupCartCount() {
        let cartCount = COREDATA_MANAGER.getCartItemsCount()
        self.cartCountLbl.isHidden = cartCount <= 0
        self.cartCountLbl.text = cartCount > 99 ? "99+" : "\(cartCount)"
    }
    
    //MARK: RETRIEVE OPERATION
    func retrieveData() {
        do {
            //Fetch the Product data from CoreData to display in the tableview
            let searchDatas = try DB_Context.fetch(ProductTable.fetchRequest())
            if searchDatas.count > 0 {
                if self.catagoriesData.count > 0 {
                    self.catagoriesData.removeAll()
                }
                for productItem in searchDatas {
                    
                    let catModel = categoriesModel(fromJson: JSON())
                    catModel.id = productItem.product_id
                    catModel.name = productItem.product_name
                    let jData = "\(productItem.product_items ?? "")".data(using: .utf8)!
                    let json = try JSON(data: jData).arrayValue
                    catModel.items = nil
                    catModel.itemArr = json
                    self.catagoriesData.append(catModel)
                }
                self.categoryTableview.reloadData()
                self.categoryNameTableviewHeight.constant = CGFloat(self.catagoriesData.count * 50) > (SCREEN_HEIGHT - 50) ? (SCREEN_HEIGHT - 100) : CGFloat(self.catagoriesData.count * 50)
                self.categoryNameTableview.reloadData()
            }
            else {
                self.fetchDatafromJSON()
            }
        }
        catch {
            print("Error in Fetching Data from CoreData :--->\(error)")
            //self.fetchDatafromJSON()
        }
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
                    print("~~~Check Favourites~~~\nItemID: \(productItem.item_id)\nName: \(productItem.item_name ?? "")")
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
        }
        catch {
            print("Error in Fetching Data from CoreData :--->\(error)")
        }
    }
    
    //MARK: --- DATA LOAD FROM LOCAL JSON FILE
    func fetchDatafromJSON() {
        if let batch = self.parseJSONFromFile(named: "shopping") {
            for dict in batch.categories {
                let newProduct = ProductTable(context: DB_Context)
                newProduct.product_id = dict.id
                newProduct.product_name = dict.name
                newProduct.product_items = "\(dict.itemArr ?? [])"
               COREDATA_MANAGER.savedata()
            }
            self.retrieveData()
        }
    }
    
    //MARK: --- PARSING LOCAL JSON INTO JSONOBJECT
    func parseJSONFromFile(named fileName: String) -> dataModel? {
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let json = try JSON(data: data)
                return dataModel(fromJson: json)
            } catch {
                print("Error reading JSON file:", error.localizedDescription)
                return nil
            }
        } else {
            print("JSON file not found.")
            return nil
        }
    }
    
    @IBAction func didTapMenu(_ sender: Any) {
        present(SideMenuManager.default.leftMenuNavigationController!, animated: true, completion: nil)
    }
    
    @IBAction func didFavouriteBtnTap(_ sender: Any) {
        let favouritePage = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FavouriteViewcontroller") as? FavouriteViewcontroller
        self.navigationController?.pushViewController(favouritePage!, animated: true)
    }
    
    @IBAction func didCartBtnTap(_ sender: Any) {
        let cartPage = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CartViewController") as? CartViewController
        self.navigationController?.pushViewController(cartPage!, animated: true)
    }
    
    @IBAction func didCategoriesBtnTap(_ sender: Any) {
        self.categoryBtnView.isHidden = true //Hide the CategoryButton
        self.categoryView.isHidden = false //Show the CategoryView
    }
    
    @IBAction func didCloseBtnTap(_ sender: Any) {
        self.categoryBtnView.isHidden = false //Show the CategoryButton
        self.categoryView.isHidden = true //Hide the CategoryView
    }
}

//MARK: --- MAIN LIST
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.categoryTableview {
            return self.catagoriesData.count > 0 ? self.catagoriesData.count : 0
        }
        else {
            return self.catagoriesData.count > 0 ? self.catagoriesData.count : 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.categoryTableview {
            let cell = tableView.dequeueReusableCell(withIdentifier: "categoryTableviewcell", for: indexPath) as! categoryTableviewcell
            let dict = self.catagoriesData[indexPath.row]
            cell.toggleBtn.tag = indexPath.row
            cell.toggleBtn.addTarget(self, action: #selector(self.expandCollapse(_:)), for: .touchUpInside)
            cell.categoryName.text = dict.name
            cell.favouriteData = self.favouriteData
            do {
                let jsondata = "\(dict.itemArr ?? [])".data(using: .utf8)!
                let iJson = try JSON(data: jsondata).arrayValue
                
                cell.productItems = [itemsModel]()
                
                for item in iJson {
                    let dataModal = itemsModel(fromJson: item)
                    cell.productItems.append(dataModal) // Append to optional array
                }
            }
            catch {
                print("Check Error : ---> \(error)")
            }
            cell.subCategoryCollectionView.reloadData()
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "categoryNameTableviewcell", for: indexPath) as! categoryNameTableviewcell
            let dict = self.catagoriesData[indexPath.row]
            cell.categoryName.text = dict.name
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.categoryTableview {
            return UITableView.automaticDimension
        }
        else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.categoryNameTableview {
            self.categoryTableview.scrollToRow(at: indexPath, at: .top, animated: true)
            let cell = self.categoryTableview.cellForRow(at: indexPath) as! categoryTableviewcell
            cell.itemsView.isHidden = false
            cell.toggleBtn.setImage(UIImage(named: "up"), for: .normal)
            self.categoryTableview.beginUpdates()
            self.categoryTableview.endUpdates()
            self.didCloseBtnTap(self)
        }
    }
    
    @objc func expandCollapse(_ sender: UIButton) {
        let indexpath = IndexPath(row: sender.tag, section: 0)
        let cell = self.categoryTableview.cellForRow(at: indexpath) as! categoryTableviewcell
        
        UIView.transition(with: cell.toggleBtn, duration: 0.3, options: .curveEaseInOut, animations: {
            if cell.itemsView.isHidden {
                cell.toggleBtn.setImage(UIImage(named: "up"), for: .normal)
            } else {
                cell.toggleBtn.setImage(UIImage(named: "down"), for: .normal)
            }
        }, completion: nil)
        
        UIView.transition(with: cell.itemsView, duration: 0.3, options: .showHideTransitionViews, animations: {
            cell.itemsView.isHidden.toggle()  // Toggle the visibility of itemsView
        }, completion: nil)
        
        //cell.itemsView.isHidden = !(cell.itemsView.isHidden)
        self.categoryTableview.beginUpdates()
        self.categoryTableview.endUpdates()
    }
}

//MARK: --- ITEMS GRID
extension categoryTableviewcell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.productItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "subCategoryCollectionViewCell", for: indexPath) as! subCategoryCollectionViewCell
        let dict = self.productItems[indexPath.row]
        cell.productName.text = dict.name
        cell.productPrice.text = "\(currencySymbol)" + String(format: "%.1f", ceil(dict.price))
        cell.productImg.sd_setImage(with: URL(string: dict.icon))
        cell.favoriteBtn.tag = indexPath.row
        cell.favoriteBtn.addTarget(self, action: #selector(self.didTapFavorite(_:)), for: .touchUpInside)
        cell.addToCartBtn.tag = indexPath.row
        cell.addToCartBtn.addTarget(self, action: #selector(self.didTapAddToCart(_:)), for: .touchUpInside)
        if self.favouriteData.contains(where: { $0.id == dict.id }) {
            // Set the button to ON if any item in favouriteData matches the condition
            cell.heartBtn.setOn(true, animated: true)
        } else {
            // Set the button to OFF if none of the items in favouriteData match the condition
            cell.heartBtn.setOn(false, animated: false)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //return CGSize(width: screenWidth - 10, height: screenHeight)
        return CGSize(width: 140, height: 170)
    }
    
    @objc func didTapFavorite(_ sender: UIButton) {
        let indexpath = IndexPath(row: sender.tag, section: 0)
        let iDict = self.productItems[sender.tag]
        let cell = self.subCategoryCollectionView.cellForItem(at: indexpath) as! subCategoryCollectionViewCell
        
        if cell.heartBtn.isOn { //When user mark the favourites before, it is on
            COREDATA_MANAGER.removeFavouriteData(itemID: iDict.id)
        }
        else { //if it doesn't mark as the favourite, we will add the favourites here
            COREDATA_MANAGER.addFavouriteData(rData: iDict)
        }
        cell.heartBtn.setOn(!(cell.heartBtn.isOn), animated: true)
        NotificationCenter.default.post(name: NSNotification.Name("FavoritesChanged"), object: nil)
    }
    
    @objc func didTapAddToCart(_ sender: UIButton) {
        let iDict = self.productItems[sender.tag]
        let existingQty = COREDATA_MANAGER.GetProductQty(itemID: iDict.id)
        COREDATA_MANAGER.addCartData(rData: iDict, QtyCount: existingQty + 1)
        NotificationCenter.default.post(name: NSNotification.Name("CartChanged"), object: nil)
        self.showAddToCartToast()
    }
}
