//
//  ProfilViewController.swift
//  Shop
//
//  Created by hamza-dridi on 16/11/2022.
//

import UIKit
import CoreData

class ProfilViewController: UIViewController {
    public var connectedUser: User = User(id: "", email: "", password: "", firstName: "", lastName: "", gender: "" , age: "", photo: "", code: "",codeAdmin: "")

    @IBOutlet weak var emailTxt: UITextView!
    
    @IBOutlet weak var ageTxt: UITextView!
    @IBOutlet weak var lastnameTxt: UITextView!
    @IBOutlet weak var firstnameTxt: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getConnectedUser()
        setupUser()
        // Do any additional setup after loading the view.
    }
    
    
    
   
    @IBAction func darkModebtn(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            overrideUserInterfaceStyle = .light
        } else {
            overrideUserInterfaceStyle = .dark
        }
    }
    

    @IBAction func editBtn(_ sender: Any) {
        
        self.performSegue(withIdentifier: "profilToEdit", sender: sender)
    }
    
    func setupUser() {
        lastnameTxt.text = connectedUser.lastName
        firstnameTxt.text = connectedUser.firstName
        emailTxt.text = connectedUser.email
        ageTxt.text = connectedUser.age
        
        
    }
    
    
    func getConnectedUser() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Connected")
        do {
            let result = try managedContext.fetch(fetchRequest)
            for obj in result {
                self.connectedUser.id =  (obj.value(forKey: "id") as! String)
                self.connectedUser.firstName=(obj.value(forKey: "name") as! String)
                self.connectedUser.lastName=(obj.value(forKey: "lastName") as! String)
                self.connectedUser.email=(obj.value(forKey: "email") as! String)
                self.connectedUser.age=(obj.value(forKey: "age") as! String)
               // self.connectedUser.photo=(obj.value(forKey: "photo") as! String)

               
            }
            
         
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    

    
    
    
    
    
    
    
    
    @IBAction func btnLogout(_ sender: Any) {
        
        let defaults: UserDefaults? = UserDefaults.standard
           defaults?.set(false, forKey: "ISRemember")
          defaults?.set("", forKey: "SavedEmail")
          defaults?.set("", forKey: "SavedPassword")
          
          
          let appDelegate = UIApplication.shared.delegate as! AppDelegate
              
          let managedContext = appDelegate.persistentContainer.viewContext
              
          let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Connected")
              
          do {
              let result = try managedContext.fetch(fetchRequest)
              for obj in result {
                  managedContext.delete(obj)
              }
              try managedContext.save()
              print("deleted connected user")
          } catch let error as NSError {
              print("Could not fetch. \(error), \(error.userInfo)")
          }
          performSegue(withIdentifier: "logout", sender: sender)
    }
    
    
}
