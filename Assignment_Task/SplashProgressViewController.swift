//
//  SplashProgressViewController.swift
//  Assignment_Task
//
//  Created by VAISHNAVI J on 25/07/24.
//

import UIKit
import Lottie

class SplashProgressViewController: UIViewController {

    var starAnimationView = LottieAnimationView()
    @IBOutlet weak var bottomView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.playanimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        // Do any additional setup after loading the view.
    }
    
    func playanimation() {
        
        let path = Bundle.main.path(forResource: "launcher_point_animation",
                                    ofType: "json") ?? ""
        self.starAnimationView = LottieAnimationView.init(filePath: path)
        self.starAnimationView.frame = CGRect(x: 0, y: 0, width: 120, height: 100)
        self.starAnimationView.contentMode = .scaleAspectFill
        self.starAnimationView.center = CGPoint(x: self.bottomView.bounds.midX, y: self.bottomView.bounds.midY)
        self.bottomView.addSubview(self.starAnimationView)
        self.starAnimationView.loopMode = .loop
        self.starAnimationView.play()
    }

}
