//
//  ViewController2.swift
//  WeatherApp
//
//  Created by Farhana Khan on 16/05/21.
//

import UIKit
import CoreData
class SignUpVC: UIViewController {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var mobTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var userProfile: UIImageView!
    let appDel = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        applyGradient(colors: [#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1),#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1),#colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1)])
        self.navigationController?.navigationBar.isHidden = true
        userProfile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setImage)))
        userProfile.isUserInteractionEnabled = true
    }
    func applyGradient(colors: [CGColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 1 , y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = mainView.bounds
        mainView.layer.insertSublayer(gradientLayer, at: 0)
    }
    @IBAction func saveBtn(_ sender: UIButton) {
        let error = validateFields()
        if error != nil{
            showErr(msg: error!)
        }
        else{
            let png = self.userProfile.image?.pngData()
        }
        //let jpeg = self.userProfile.image?.jpegData(compressionQuality: 0.75)
        let png = self.userProfile.image?.pngData()
        let ctx = appDel.persistentContainer.viewContext
        
        let item = UserItem(context: ctx)
        item.img = png
        item.userName = nameTF.text
        item.userNumber = mobTF.text
        item.userEmail = emailTF.text
        item.userCity = cityTF.text
        appDel.saveContext()
        
        
        let alert = UIAlertController(title: "User Added", message: "User is Added Into the System", preferredStyle: .actionSheet)
        let ok = UIAlertAction(title: "OK", style: .default) { alert in
            
            self.userProfile.image = UIImage(named: "user")
            self.nameTF.text = ""
            self.mobTF.text = ""
            self.emailTF.text = ""
            self.cityTF.text = ""
        }
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    @objc func setImage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func weatherBtn(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ViewController") as!  WeatherVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        applyGradient(colors: [#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1),#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1),#colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1)])
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    
}


extension SignUpVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImage = UIImage()
        
        if let editedImg = info[.editedImage] as? UIImage{
            
            selectedImage = editedImg
        }else if let originalImage = info[.originalImage] as? UIImage{
            
            selectedImage = originalImage
        }
        
        if let selected = selectedImage as? UIImage{
            userProfile.image = selected
        }
        dismiss(animated: true, completion: nil)
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
    
    
    //MARK:- Field Validation
    func validateFields() -> String? {
        
        if nameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            mobTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            cityTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields"
            
        }
        
        //Check if the email is correct
        let cleanEmail = emailTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if isValidEmail(cleanEmail) == false{
            
            return "Make sure you've entered email in correct format"
            
        }
        return nil
    }
    
    func isValidEmail(_ email: String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
