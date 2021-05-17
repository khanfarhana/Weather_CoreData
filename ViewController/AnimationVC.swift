//
//  AnimationVC.swift
//  WeatherApp
//
//  Created by Farhana Khan on 17/05/21.
//

import UIKit
import Lottie

class AnimationVC: UIViewController {
    @IBOutlet var mainView: UIView!
    var count = 0
    var animationV = AnimationView()
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animation()
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [self] (t) in
            self.count = self.count+1
            if(self.count == 5)
            {
                showVC()
                t.invalidate()
            }
            self.navigationController?.navigationBar.isHidden = true
            applyGradient(colors: [#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1),#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1),#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)])
        }
        
        func applyGradient(colors: [CGColor]) {
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = colors
            gradientLayer.startPoint = CGPoint(x: 1 , y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
            gradientLayer.frame = mainView.bounds
            mainView.layer.insertSublayer(gradientLayer, at: 0)
        }
        
        func animation()  {
            animationV.animation = Animation.named("weatherAnime")
            animationV.frame = view.bounds
            animationV.backgroundColor = .clear
            animationV.contentMode = .scaleAspectFit
            animationV.play()
            animationV.loopMode = .loop
            view.addSubview(animationV)
        }
        func showVC() {
            let vc = storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
}
