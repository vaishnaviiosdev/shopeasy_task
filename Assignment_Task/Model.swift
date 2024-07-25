//
//  Model.swift
//  Assignment_Task
//
//  Created by VAISHNAVI J on 23/07/24.
//

import Foundation
import SwiftyJSON

class dataModel {
    
    var status: Bool!
    var message: String!
    var error: String!
    var categories: [categoriesModel]!
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        status = json["status"].boolValue
        message = json["message"].stringValue
        error = json["error"].stringValue
        categories = [categoriesModel]()
        let dataArray = json["categories"].arrayValue
        for item in dataArray {
            let dataModal =  categoriesModel(fromJson: item)
            categories.append(dataModal)
        }
    }
}

class categoriesModel {
    
    var id: Int32!
    var name: String!
    var itemArr: [JSON]!
    var items: [itemsModel]!
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        id = json["id"].int32Value
        name = json["name"].stringValue
        items = [itemsModel]()
        let itemArray = json["items"].arrayValue
        itemArr = itemArray
        for item in itemArray {
            let dataModal =  itemsModel(fromJson: item)
            items.append(dataModal)
        }
    }
}

class itemsModel {
    
    var id: Int32!
    var name: String!
    var icon: String!
    var price: Double!
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        id = json["id"].int32Value
        name = json["name"].stringValue
        icon = json["icon"].stringValue
        price = json["price"].doubleValue
    }
}

class cartModel {
    
    var id: Int32!
    var name: String!
    var icon: String!
    var price: Double!
    var qty: Int32!
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        id = json["id"].int32Value
        name = json["name"].stringValue
        icon = json["icon"].stringValue
        price = json["price"].doubleValue
        qty = json["qty"].int32Value
    }
    
}

