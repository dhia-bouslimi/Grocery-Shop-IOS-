//
//  RegisterViewController.swift
//  Shop
//
//  Created by hamza-dridi on 10/11/2022.
//

import UIKit

class RegisterViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var lastNametxt: UITextField!
    @IBOutlet weak var gendertxt: UITextField!
    @IBOutlet weak var agetxt: UITextField!
    @IBOutlet weak var passwordtxt: UITextField!
    @IBOutlet weak var Emailtxt: UITextField!
    @IBOutlet weak var userNametxt: UITextField!
    
    fileprivate let baseURL = "http://172.17.4.53:2500/"
    public var SuccessMessage:Message = Message(message: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lastNametxt.delegate = self
        gendertxt.delegate = self
        agetxt.delegate = self
        passwordtxt.delegate = self
        Emailtxt.delegate = self
        userNametxt.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    
    
    @IBAction func signupbtn(_ sender: Any) {
        let isEmailAddressValid = isValidEmailAddress(emailAddressString: Emailtxt.text!)
        if(userNametxt.text == "") {
            let alert = UIAlertController(title: "User Name field is empty".localizedSignup, message: "please enter all fields".localizedSignup, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok".localized, style: .default, handler: nil))
                  self.present(alert, animated: true)
                  
              }
        else if(lastNametxt.text == "") {
            let alert = UIAlertController(title: "Last Name field is empty".localizedSignup, message: "please enter all fields".localizedSignup, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok".localizedSignup, style: .default, handler: nil))
                   self.present(alert, animated: true)
                   
               }
        else if(
            (Emailtxt.text != nil) != isEmailAddressValid ){
            let alert = UIAlertController(title: "Your Email IS Not Valid".localizedSignup, message: "check your inputs".localizedSignup, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok".localizedSignup, style: .default, handler: nil))
            self.present(alert, animated: true)
            
        }
        else if(passwordtxt.text == "") {
            let alert = UIAlertController(title: "Password field is empty".localizedSignup, message: "please enter all fields".localizedSignup, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok".localizedSignup, style: .default, handler: nil))
                   self.present(alert, animated: true)
                   
               }
        else if(agetxt.text == "") {
            let alert = UIAlertController(title: "Age field is empty".localizedSignup, message: "please enter all fields".localizedSignup, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok".localizedSignup, style: .default, handler: nil))
                   self.present(alert, animated: true)
                   
               }

       else if(gendertxt.text == "") {
                  let alert = UIAlertController(title: "Gender field is empty", message: "please enter all fields", preferredStyle: .alert)
                  alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                  self.present(alert, animated: true)
                  
              }
     
       
    

        

        
        else  if(userNametxt.text != "" && lastNametxt.text != "" && Emailtxt.text != "" && passwordtxt.text != "" && agetxt.text != "" && gendertxt.text != "")
        {
            
            let parameters = ["firstName" : userNametxt.text! ,"lastName" : lastNametxt.text! , "email" : Emailtxt.text! , "password" : passwordtxt.text! , "age" : agetxt.text! , "gender" : gendertxt.text!]  as [String:Any]
            
            guard let url = URL(string: baseURL+"users/signup") else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
            request.httpBody = httpBody
            var status = 0
            URLSession.shared.dataTask(with: request) { (data,response,error) in
                if error == nil{
                    do {
                        let httpResponse = response as? HTTPURLResponse
                        status = httpResponse!.statusCode
                        self.SuccessMessage = try JSONDecoder().decode(Message.self, from: data!)
                        print(self.SuccessMessage)
                        //self.performSegue(withIdentifier: "signupToHome", sender: sender)
                    } catch {
                        print("parse json error")
                    }
                    DispatchQueue.main.async {
                        if status == 200 {
                             self.performSegue(withIdentifier: "SignupToLogin", sender: sender)
                          //  self.performSegue(withIdentifier: "signupToProfil", sender: self)
                            print("ok")
                        }
                        
                    }
                }
                

            }.resume()
            
        }

    }
}



func isValidEmailAddress(emailAddressString: String) -> Bool {
    
    var returnValue = true
    let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
    
    do {
        let regex = try NSRegularExpression(pattern: emailRegEx)
        let nsString = emailAddressString as NSString
        let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
        
        if results.count == 0
        {
            returnValue = false
        }
        
    } catch let error as NSError {
        print("invalid regex: \(error.localizedDescription)")
        returnValue = false
    }
    
    return  returnValue
}



extension String {
    var localizedSignup: String {
        return NSLocalizedString(self, comment: "")
    }
}
