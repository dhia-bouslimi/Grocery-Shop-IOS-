//
//  forgetViewController.swift
//  Shop
//
//  Created by hamza-dridi on 11/11/2022.
//

import UIKit

class forgetViewController: UIViewController, UITextFieldDelegate {
    public var connectedUser: User = User(id: "", email: "", password: "", firstName: "", lastName: "", gender: "" , age: "", photo: "", code: "")

    @IBOutlet weak var forgettxt: UITextField!
    fileprivate let baseURLRender = "http://172.17.1.50:2500/"
        public var codecode:code = code( code: "")
    override func viewDidLoad() {
        super.viewDidLoad()
        forgettxt.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
  
  
    @IBAction func btnretour(_ sender: Any) {
        self.performSegue(withIdentifier: "retourLogin", sender: sender)
    }
    
    

    @IBAction func btnforget(_ sender: Any) {
        // create the alert
        let isEmailAddressValid = isValidEmailAddressss(emailAddressString: forgettxt.text!)

        if(
            (forgettxt.text != nil) != isEmailAddressValid ){
            let alert = UIAlertController(title: "Your Email IS Not Valid".localizedForget, message: "check your inputs".localizedForget, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok".localizedForget, style: .default, handler: nil))
            self.present(alert, animated: true)
            
        }
             else
             {
                 let parameters = ["email" : forgettxt.text! ] as [String:Any]
              
                 guard let url = URL(string: baseURLRender+"users/forgetPassword") else { return }
                 var request = URLRequest(url: url)
                 request.httpMethod = "POST"
                 request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                 guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
                 request.httpBody = httpBody
                 var status = 0
                 URLSession.shared.dataTask(with: request) { (data,response,error) in
                     if error == nil{
                         do {
                             self.codecode = try JSONDecoder().decode(code.self, from: data!)
                             let httpResponse = response as? HTTPURLResponse
                             status = httpResponse!.statusCode
                         } catch {
                             print("parse json error")
                         }
                         DispatchQueue.main.async {
                         //   if status == 200 {
                           
                             print("waaaaaaaaa" , self.codecode.code )
                                self.performSegue(withIdentifier: "forget2", sender: sender)
                                
                                let pref = UserDefaults.standard
                                let currentLevel = self.codecode.code
                                let currentLevelKey = "currentLevel"
                                pref.set(currentLevel,forKey: currentLevelKey)
                            // }
                         }
                     }
                 }.resume()
                 self.performSegue(withIdentifier: "forget2", sender: sender)

             }
             
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "forget2" {
          let des = segue.destination as! Forget2ViewController
       
          des.Email = forgettxt.text
            
    }

}
    
}
func isValidEmailAddressss(emailAddressString: String) -> Bool {
    
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
    var localizedForget: String {
        return NSLocalizedString(self, comment: "")
    }
}
