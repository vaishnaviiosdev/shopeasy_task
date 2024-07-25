//
//  CartTable+CoreDataProperties.swift
//  Assignment_Task
//
//  Created by VAISHNAVI J on 24/07/24.
//
//

import Foundation
import CoreData


extension CartTable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CartTable> {
        return NSFetchRequest<CartTable>(entityName: CART_TABLE)
    }

    @NSManaged public var item_id: Int32
    @NSManaged public var item_name: String?
    @NSManaged public var item_img: String?
    @NSManaged public var item_price: Double
    @NSManaged public var item_qty: Int32

}

extension CartTable : Identifiable {

}
