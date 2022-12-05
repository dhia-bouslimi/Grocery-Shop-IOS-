//
//  LoginViewController.swift
//  Shop
//
//  Created by hamza-dridi on 10/11/2022.
//
import CoreData
import UIKit
//import Alamofire

class LoginViewController: UIViewController,UITextFieldDelegate {
    
    public var connectedUser: User = User(id: "", email: "", password: "", firstName: "", lastName: "", gender: "" , age: "", photo: "", code: "",codeAdmin: "")
    public var responseError:ErrorMessage = ErrorMessage( error: "")
    fileprivate let baseURL = "http://172.17.2.174:2500"
    
    
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    
    var iconClick = false
      let imageicon = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        emailTxtField.delegate = self
        passwordTxtField.delegate = self

        imageicon.image = UIImage(named: "colseeye")
        
        let contentView = UIView()
        contentView.addSubview(imageicon)
        
        contentView.frame = CGRect(x: 0, y: 0, width: UIImage(named: "closeeye")!.size.width, height: UIImage(named: "closeeye")!.size.height)
        
        
        imageicon.frame = CGRect(x: -10, y: 0, width: UIImage(named: "closeeye")!.size.width, height: UIImage(named: "closeeye")!.size.height)
        
        
        
        passwordTxtField.rightView = contentView
        passwordTxtField.rightViewMode = .always
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageicon.isUserInteractionEnabled = true
        imageicon.addGestureRecognizer(tapGestureRecognizer)
        // Do any additional setup after loading the view.
      
    }
    
    
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        if iconClick
        {
            iconClick = false
            tappedImage.image = UIImage(named: "openeye")
            passwordTxtField.isSecureTextEntry = false
        }
     else
        {
            iconClick = true
            tappedImage.image = UIImage(named: "closeeye")
            passwordTxtField.isSecureTextEntry = true
        }

    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    
    
    @IBAction func btnLogin(_ sender: Any) {

        let emailValue = emailTxtField.text
                let passwordValue = passwordTxtField.text

               if emailValue == "" {
                    print("email empty")
                    let alert = UIAlertController(title: "email field is empty", message: "please fill your inputs", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }else if passwordValue == "" {
                    print("password empty")
                    let alert = UIAlertController(title: "password field is empty", message: "please fill your inputs", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }else{
         
                    print("try to connect")
                    let parameters = ["email" : emailValue, "password" : passwordValue]
                    guard let url = URL(string: baseURL+"/users/signIn") else { return }
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
                                if !( status == 200) {

                                    print("serialize backendresponse")
                                    self.responseError = try JSONDecoder().decode(ErrorMessage.self, from: data!)
                                    print(self.responseError)
                                }else {
                                    self.connectedUser = try JSONDecoder().decode(User.self, from: data!)
                                    print(self.connectedUser)
                                    print("serialize user")
                                    
                                
                                }
                                
                            } catch {
                                print("parse json error")
                            }
                    
                            DispatchQueue.main.async {
                                
                              if status == 422 {
                                print("error=======")
                                    let alert = UIAlertController(title: "Incorrect password OR Email", message: "check your inputs", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                                    self.present(alert, animated: true)
                                }else if status == 200 {
                                    
                                    print("welcome +++"+self.connectedUser.lastName!+"+++")
                                  //  print(self.connectedUser)
                                   self.saveConnectedUser()
                                    
                                    self.performSegue(withIdentifier: "loginToHome", sender: sender)

                                }
                                
                            }
                        }
                    }.resume()
                }
    }
    
    
    
    
    @IBAction func btnforgetpassword(_ sender: Any) {
        
    }
    
    
    func saveConnectedUser() -> Void {
        
        let appD = UIApplication.shared.delegate as! AppDelegate
        let PC = appD.persistentContainer
        let managedContext = PC.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Connected",in: managedContext)!
        let object = NSManagedObject(entity: entity,insertInto: managedContext)
        
        object.setValue(self.connectedUser.id, forKey: "id")
        object.setValue(self.connectedUser.firstName, forKey: "name")
        object.setValue(self.connectedUser.lastName, forKey: "lastName")
        object.setValue(self.connectedUser.email, forKey: "email")
        object.setValue(self.connectedUser.password, forKey: "password")
        object.setValue(self.connectedUser.gender, forKey: "gender")
        object.setValue(self.connectedUser.age, forKey: "age")
        object.setValue(self.connectedUser.code, forKey: "code")
        object.setValue(self.connectedUser.codeAdmin, forKey: "codeAdmin")
        object.setValue(self.connectedUser.photo, forKey: "photo")

                
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
     
    }

    
    
    
    
    
    

}


