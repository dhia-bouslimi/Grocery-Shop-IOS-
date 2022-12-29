//
//  DetailFournisseurViewController.swift
//  Shop
//
//  Created by hamza-dridi on 20/11/2022.
//

import UIKit

class DetailFournisseurViewController: UIViewController {
    
    @IBOutlet weak var secteur: UILabel!
    @IBOutlet weak var adresse: UILabel!
    @IBOutlet weak var numtel: UILabel!
    @IBOutlet weak var fullname: UILabel!
    
  //  fileprivate let baseURL = "https://shopapp.onrender.com"
   // public var SuccessMessage:Message = Message(message: "")

    var strfullname = ""
    var strnumtel = ""
    var stradresse = ""
    var strsecteur = ""
    
    
    
   
       
        
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullname.text = strfullname
        numtel.text = strnumtel
        adresse.text = stradresse
        secteur.text = strsecteur
        // Do any additional setup after loading the view.
    }
    

 
    @IBAction func btnretour(_ sender: Any) {
        self.performSegue(withIdentifier: "DetailTolistefournisseur", sender: sender)

    }
    
    
    @IBAction func btnPhone(_ sender: Any) {
    }
    
    
    
    
    
    
  /*  @IBAction func deleteBtn(_ sender: Any) {
        
        let parameters = [ "fullName" : fullName ] as! [String:Any]
     
        guard let url = URL(string: self.baseURL+"/fournisseurs/deletefournisseur/:fullName") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "delete"
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
                  if status == 200 {
                   self.performSegue(withIdentifier: "DeleteToDetailFournisseur", sender: sender)
                        
                    }
                    

                    
                    print("test-------------")
                  
                    

                }
            }
        }.resume()
    }*/
    
    
}
