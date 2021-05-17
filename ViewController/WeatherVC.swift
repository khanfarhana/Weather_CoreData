//
//  ViewController.swift
//  WeatherApp
//
//  Created by Farhana Khan on 15/05/21.
//

import UIKit
import Alamofire
import Lottie
class WeatherVC: UIViewController {
    @IBOutlet weak var actIn: UIActivityIndicatorView!
    @IBOutlet var mainView: UIView!
    var animationV = AnimationView()
    @IBOutlet weak var viewAnimation: UIView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var imgV: UIImageView!
    var weatherData = NSDictionary()
    var name = String()
    
    func animation() {
        animationV.frame = viewAnimation.bounds
        animationV.backgroundColor = .clear
        animationV.contentMode = .scaleAspectFit
        animationV.play()
        animationV.loopMode = .loop
        viewAnimation.addSubview(animationV)
    }
    func applyGradient(colors: [CGColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 1 , y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = mainView.bounds
        mainView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actIn.hidesWhenStopped = true
        animation()
        alphaLabel(val: 0)
        weather()
    }
    
    func weather() {
        if Connectivity.isConnectedToInternet() {
            AF.request("https://api.openweathermap.org/data/2.5/weather?q=Mumbai&appid=851320d069968eff8c17f0028027e05c", method: .get).responseJSON{(resp) in
                if let  data = resp.value as? NSDictionary {
                    self.actIn.stopAnimating()
                    self.weatherData = data.value(forKey: "coord") as! NSDictionary
                    let weatherDetails = data.value(forKey: "weather") as! [NSDictionary]
                    self.name = data.value(forKey: "name") as! String
                    let weatherMain = data.value(forKey: "main") as! NSDictionary
                    //            let temp = Int(self.weatherMain.value["temp"] as? Double ?? 0)
                    let temp = weatherMain.value(forKey: "temp") as? Double ?? 0.0
                    let desc = (weatherDetails.first?["description"] as? String)?.captialzingfirstLetter()
                    //            self.setWeather(Weather: weatherDetails.first?["main"] as? String, description: description as? String, temp: temp as? Double)
                    self.setWeather(Weather: weatherDetails.first?["main"] as? String, description: desc as? String ?? "", temp: temp as? Double ?? 0.0)
                    print(data)
                }
                else {
                    print("error ")
                }
            }
        }
        else {
            self.actIn.isHidden = true
            let alert = UIAlertController(title: "No Internet Connection!!", message: "Please Check Your Internet Connection and Try Again", preferredStyle: .actionSheet)
            let titleAttributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 18)!, NSAttributedString.Key.foregroundColor: UIColor.black]
            let titleString = NSAttributedString(string: "No Internet Connection!!", attributes: titleAttributes)
            alert.setValue(titleString, forKey: "attributedTitle")
            let dismiss = UIAlertAction(title: "Dismiss", style: .destructive, handler: nil)
            alert.addAction(dismiss)
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    func setWeather(Weather: String?,description: String?, temp:Double) {
        
        alphaLabel(val: 1)
        descriptionLbl.text = description ?? "empty"
        tempLbl.text = "\(temp)"
        nameLbl.text = " Hello, \(name)"
        switch Weather{
        case "Rain":
            animationV.animation = Animation.named("cloudy")
            applyGradient(colors: [#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1),#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1),#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)])
            animation()
        default:
            animationV.animation = Animation.named("sunny")
            applyGradient(colors: [#colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1),#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1),#colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)])
            animation()
        }
    }
    
    func alphaLabel(val: CGFloat){
        descriptionLbl.alpha = val
        nameLbl.alpha = val
        tempLbl.alpha = val
    }
    func showErr(msg: String){
        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        let titleAttributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 18)!, NSAttributedString.Key.foregroundColor: UIColor.black]
        let titleString = NSAttributedString(string: "\(msg)", attributes: titleAttributes)
        alert.setValue(titleString, forKey: "attributedTitle")
        let dismiss = UIAlertAction(title: "Dismiss", style: .destructive, handler: nil)
        alert.addAction(dismiss)
        self.present(alert, animated: true, completion: nil)
    }
}



extension String {
    func captialzingfirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
