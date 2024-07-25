//
//  CoreDataManager.swift
//  Assignment_Task
//
//  Created by VAISHNAVI J on 24/07/24.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    //MARK: CREATE OPERATION --- Add to FavouriteTable
    func addFavouriteData(rData: itemsModel) {
        if !(self.findProductID(itemID: rData.id, entityName: FAVORITE_TABLE)) { //--- Check If already Item is in Table
            print("The findprodcutId result is \((self.findProductID(itemID: rData.id, entityName: FAVORITE_TABLE)))")
            let favouriteProduct = FavoriteTable(context: DB_Context)
            favouriteProduct.item_id = rData.id
            favouriteProduct.item_name = rData.name
            favouriteProduct.item_price = rData.price
            favouriteProduct.item_img = rData.icon
            COREDATA_MANAGER.savedata()
        }
    }
    
    //MARK: DELETE OPERATION (Delete by SpecificId) --- Remove From FavouriteTable
    func removeFavouriteData(itemID: Int32) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: FAVORITE_TABLE)
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "item_id = %@", "\(itemID)")
        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "item_id", ascending: false)]
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let result = try DB_Context.fetch(fetchRequest)
            if result.count > 0 {
                for data in result as! [FavoriteTable] {
                    print("Delete ==> Check ReceivedProductID : ==> \(itemID) \(data.item_id) <== Fetched ProductID")
                    if itemID == data.item_id {
                        DB_Context.delete(data)
                        self.savedata()
                        return
                    }
                }
            }
        } catch {
            print("***FindProductID Fetch Request Error for Delete :---> \(error)***")
        }
    }
    
    //MARK: --- CART TABLE
    
    //MARK: CREATE OPERATION --- Add to Cart
    func addCartData(rData: itemsModel, QtyCount: Int32) {
        if !(self.findProductID(itemID: rData.id, entityName: CART_TABLE)) { //--- Check If already Item is in Table
            let cartProduct = CartTable(context: DB_Context)
            cartProduct.item_id = rData.id
            cartProduct.item_name = rData.name
            cartProduct.item_price = rData.price
            cartProduct.item_img = rData.icon
            cartProduct.item_qty = QtyCount
            COREDATA_MANAGER.savedata()
        }
        else {
            self.updateData(rData: rData, QtyCount: QtyCount)
        }
    }
    
    //MARK: UPDATE OPERATION FOR CART TABLE
    
    func updateData(rData: itemsModel, QtyCount: Int32) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CART_TABLE)
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "item_id = %@", "\(rData.id ?? 0)")
        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "item_id", ascending: false)]
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let result = try DB_Context.fetch(fetchRequest)
            
            if result.count > 0 {
                let updateCartTable = result[0] as! NSManagedObject
                updateCartTable.setValue(rData.name, forKey: "item_name")
                updateCartTable.setValue(rData.icon, forKey: "item_img")
                updateCartTable.setValue(rData.id, forKey: "item_id")
                updateCartTable.setValue(rData.price, forKey: "item_price")
                updateCartTable.setValue(QtyCount, forKey: "item_qty")
                self.savedata()
            }
        }
        catch {
            print("***Error in UpdateData :---> \(error)***")
        }
    }
    
    //MARK: DELETE OPERATION (Delete by SpecificId) --- Remove From CartTable
    func removeFromCart(itemID: Int32) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CART_TABLE)
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "item_id = %@", "\(itemID)")
        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "item_id", ascending: false)]
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let result = try DB_Context.fetch(fetchRequest)
            if result.count > 0 {
                for data in result as! [CartTable] {
                    print("Delete ==> Check ReceivedProductID : ==> \(itemID) \(data.item_id) <== Fetched ProductID")
                    if itemID == data.item_id {
                        DB_Context.delete(data)
                        self.savedata()
                        return
                    }
                }
            }
        } catch {
            print("***FindProductID Fetch Request Error for Delete :---> \(error)***")
        }
    }
    
    //MARK: GET PRODUCTQTY (Quantity by SpecificId)
    func GetProductQty(itemID: Int32) -> Int32 {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CART_TABLE)
        
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "item_id = %@", "\(itemID)")
        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "item_id", ascending: false)]
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let result = try DB_Context.fetch(fetchRequest)
            if result.count > 0 {
                for data in result as! [CartTable] {
                    print("Check Received ProductID @DataReload : ==> \(itemID) \(data.item_id) <== Fetched ProductID\nProductName : \(data.item_name ?? "--") : \(data.item_qty)Nos")
                    if itemID == data.item_id {
                        if data.item_qty > 0 {
                            return Int32(data.item_qty)
                        }
                        else {
                            return 0
                        }
                    }
                    else {
                        return 0
                    }
                }
            }
            else {
                return 0
            }
        } catch {
            print("***FindProductID Fetch Request Error for Count:---> \(error)***")
        }
        return 0
    }
    
    //MARK: GET CART ITEMS COUNT
    func getCartItemsCount() -> Int {
        do {
            let fetchRequest: NSFetchRequest<CartTable> = CartTable.fetchRequest()
            let searchDatas = try DB_Context.fetch(fetchRequest)
            return searchDatas.count
        }
        catch {
            print("Error fetching data from CoreData: \(error)")
            return 0
        }
    }
    
    //MARK: --- CommonToAll
    
    //MARK: RETRIEVE OPERATION (Find by SpecificId)
    
    func findProductID(itemID: Int32, entityName: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "item_id = %@", "\(itemID)")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "item_id", ascending: false)]
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let result = try DB_Context.fetch(fetchRequest)
            return result.count > 0 // Return true if result is not empty (product found)
        } catch {
            print("***Fetch Request Error :---> \(error)***")
            return false
        }
    }
    
    //MARK: - DELETE OPERATION
    func ClearTable(entityName: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        do {
            let objects = try DB_Context.fetch(fetchRequest)
            for object in objects {
                DB_Context.delete(object as! NSManagedObject)
            }
            self.savedata()
        }
        catch {
            print("Error in Fetch to delete the objects.!")
        }
    }
    
    //MARK: SAVE DATA
    
    func savedata() {
        do {
            try DB_Context.save()
        }
        catch {
            print("***Error in Insert Data on Table :---> \(error)***")
        }
    }
}

