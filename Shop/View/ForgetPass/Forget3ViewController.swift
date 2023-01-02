//
//  Forget3ViewController.swift
//  Shop
//
//  Created by hamza-dridi on 12/11/2022.
//

import UIKit

class Forget3ViewController: UIViewController {

    @IBOutlet weak var newpass: UITextField!
    @IBOutlet weak var confirmpass: UITextField!
    var Email :String?
    var Lastcode :String?
    fileprivate let baseURLRender = "http://172.17.1.50:2500/"
    public var SuccessMessage:Message = Message(message: "")
    override func viewDidLoad() {
        super.viewDidLoad()

        let preferences = UserDefaults.standard

              let currentLevelKey = "currentLevel"
              if preferences.object(forKey: currentLevelKey) == nil {
                  //  Doesn't exist
              } else {
                  let currentLevel = preferences.integer(forKey: currentLevelKey)
                  print("rrrrrrrrrrrr " , currentLevel)
                  Lastcode =  "\(currentLevel)"
              }
    }
    

   

    @IBAction func GotoLogin(_ sender: Any) {
        
        if(newpass.text == "" && confirmpass.text == "") {
            let alert = UIAlertController(title: "fields is empty".localizedForget2, message: "please enter all fields".localizedForget2, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok".localizedForget2, style: .default, handler: nil))
                  self.present(alert, animated: true)
                  
              }
       else if(newpass.text != confirmpass.text)
          {
           let alert = UIAlertController(title: "Incorrect".localizedForget2, message: "Password is not the same".localizedForget2, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "ok".localizedForget2, style: .default, handler: nil))
              self.present(alert, animated: true)
          }
          else
          {
         // performSegue(withIdentifier: "GoHome", sender: sender)
          let parameters = ["email" :  Email , "code" :  Lastcode , "password" :  newpass.text] as [String:Any]
       
          guard let url = URL(string: baseURLRender+"users/changePassword") else { return }
          var request = URLRequest(url: url)
          request.httpMethod = "POST"
          request.addValue("application/json", forHTTPHeaderField: "Content-Type")
          guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
          request.httpBody = httpBody
          var status = 0
          URLSession.shared.dataTask(with: request) { (data,response,error) in
              if error == nil{
                  do {
                      self.SuccessMessage = try JSONDecoder().decode(Message.self, from: data!)
                      let httpResponse = response as? HTTPURLResponse
                      status = httpResponse!.statusCode
                  } catch {
                      print("parse json error")
                  }
                  DispatchQueue.main.async {

                      if(self.SuccessMessage.message == "password changed")
                      {

                          
                          self.performSegue(withIdentifier: "login", sender: sender)

                          
                      }
                  }
              }
          }.resume()
          }
      }
    
}

extension String {
    var localizedForget2: String {
        return NSLocalizedString(self, comment: "")
    }
}
