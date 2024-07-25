//
//  MenuViewController.swift
//  Assignment_Task
//
//  Created by VAISHNAVI J on 25/07/24.
//

import UIKit

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didHomeBtnTap(_ sender: Any) {
        let HomePage = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
        self.navigationController?.pushViewController(HomePage!, animated: false)
    }
    
    @IBAction func didFavouriteBtnTap(_ sender: Any) {
        let favouritePage = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FavouriteViewcontroller") as? FavouriteViewcontroller
        self.navigationController?.pushViewController(favouritePage!, animated: false)
    }
    
    @IBAction func didCartBtnTap(_ sender: Any) {
        let cartPage = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CartViewController") as? CartViewController
        self.navigationController?.pushViewController(cartPage!, animated: false)
    }

}
