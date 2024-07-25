//
//  ProductTable+CoreDataProperties.swift
//  Assignment_Task
//
//  Created by VAISHNAVI J on 23/07/24.
//
//

import Foundation
import CoreData


extension ProductTable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductTable> {
        return NSFetchRequest<ProductTable>(entityName: PRODUCT_TABLE)
    }

    @NSManaged public var product_id: Int32
    @NSManaged public var product_name: String?
    @NSManaged public var product_items: String?

}

extension ProductTable : Identifiable {

}
