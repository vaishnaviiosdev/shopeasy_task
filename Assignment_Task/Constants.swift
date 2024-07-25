//
//  Constants.swift
//  Assignment_Task
//
//  Created by VAISHNAVI J on 23/07/24.
//

import Foundation
import UIKit

let APPNAME = "Shopfy"
let APPDELEGATE = UIApplication.shared.delegate as! AppDelegate
let DB_Context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
let SCREEN_SIZE: CGRect = UIScreen.main.bounds
let SCREEN_HEIGHT = UIScreen.main.bounds.height
let SCREEN_WIDTH = UIScreen.main.bounds.width
let COREDATA_MANAGER = CoreDataManager.shared
let PRODUCT_TABLE = "ProductTable"
let FAVORITE_TABLE = "FavoriteTable"
let CART_TABLE = "CartTable"
let currencySymbol = "₹"
let currency = "INR"

enum AppFontName: String {
    case FontFamily = "Outfit"
    case AppRegularFont = "Outfit-Regular"
    case AppMediumFont = "Outfit-Medium"
    case AppBoldFont = "Outfit-Bold"
    case AppBlackFont = "Outfit-Black"
}
