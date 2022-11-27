//
//  FournisseurViewController.swift
//  Shop
//
//  Created by hamza-dridi on 19/11/2022.
//

import UIKit

class FournisseurViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var SecteurTxt: UITextField!
    @IBOutlet weak var AdresseTxt: UITextField!
    @IBOutlet weak var NumTelTxt: UITextField!
    @IBOutlet weak var FullNameTxt: UITextField!
    
    fileprivate let baseURL = "https://shopapp.onrender.com/"
    public var SuccessMessage:Message = Message(message: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FullNameTxt.delegate = self
        NumTelTxt.delegate = self
        AdresseTxt.delegate = self
        SecteurTxt.delegate = self

        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    

   
    @IBAction func AddBtn(_ sender: Any) {
        if(FullNameTxt.text != "" && NumTelTxt.text != "" && AdresseTxt.text != "" && SecteurTxt.text != "" )
        {
            
            let parameters = ["fullName" : FullNameTxt.text! ,"adresse" : AdresseTxt.text! , "numTel" : NumTelTxt.text! , "secteur" : SecteurTxt.text! ]  as [String:Any]
            
            guard let url = URL(string: baseURL+"fournisseurs/addfournisseur") else { return }
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
                           // self.performSegue(withIdentifier: "SignupToLogin", sender: sender)
                          //  self.performSegue(withIdentifier: "signupToProfil", sender: self)
                            print("ok")
                           self.performSegue(withIdentifier: "vendorToList", sender: sender)
                        }
                        
                    }
                }
                

            }.resume()
            }
        
        
    }
    
}
