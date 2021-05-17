//
//  UserDataVC.swift
//  WeatherApp
//
//  Created by Farhana Khan on 17/05/21.
//

import UIKit
import CoreData

class UserDataVC: UIViewController {
    var displayArr = [UserItem]()
    let appDel = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var TV: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    func getAllData(){
        let ctx = appDel.persistentContainer.viewContext
        do {
            displayArr = try ctx.fetch(UserItem.fetchRequest())
            print("User length \(displayArr.count)")
            TV.reloadData()
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        getAllData()
    }
}


extension UserDataVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        displayArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomTVC
        let allUsers = displayArr[indexPath.row]
        cell.imgV.image = UIImage(data: allUsers.img!)
        cell.nameLb.text = allUsers.userName
        cell.emailLb.text = allUsers.userEmail
        cell.cityLb.text = allUsers.userCity
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let alert = UIAlertController(title: "Warning!!!!", message: "Are you sure you want to delete", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
                let ctx = self.appDel.persistentContainer.viewContext
                
                let item = self.displayArr[indexPath.row]
                ctx.delete(item)
                self.displayArr.remove(at: indexPath.row)
                self.appDel.saveContext()
                self.TV.reloadData()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        0.1
    }
    
    @objc func deletePress(sender: UIButton) {
        let alert = UIAlertController(title: "Warning", message: "Are you sure you want to delete", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            let ctx = self.appDel.persistentContainer.viewContext
            let item = self.displayArr[sender.tag]
            ctx.delete(item)
            self.displayArr.remove(at: sender.tag)
            self.appDel.saveContext()
            self.TV.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    
}
