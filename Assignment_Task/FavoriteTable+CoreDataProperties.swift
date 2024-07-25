//
//  FavoriteTable+CoreDataProperties.swift
//  Assignment_Task
//
//  Created by VAISHNAVI J on 24/07/24.
//
//

import Foundation
import CoreData


extension FavoriteTable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteTable> {
        return NSFetchRequest<FavoriteTable>(entityName: FAVORITE_TABLE)
    }

    @NSManaged public var item_id: Int32
    @NSManaged public var item_img: String?
    @NSManaged public var item_name: String?
    @NSManaged public var item_price: Double

}

extension FavoriteTable : Identifiable {

}
