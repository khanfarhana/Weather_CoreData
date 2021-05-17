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
        nameLbl.text = name
        switch Weather{
                case "Rain":
                    animationV.animation = Animation.named("cloudy")
                    animation()
                default:
                    animationV.animation = Animation.named("sunny")
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
