//
//  AuthViewController.swift
//  Shop
//
//  Created by hamza-dridi on 10/11/2022.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import GoogleSignIn
import LocalAuthentication
class AuthViewController: UIViewController {
    
    
    @IBOutlet weak var facebookLoginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.facebookLoginBtn.layer.cornerRadius = 10.0
        if isLoggedIn() {
                    // Show the ViewController with the logged in user
                }else{

                    // Show the Home ViewController
                }
            }
    
    
    
    
    @IBAction func faceIdBtn(_ sender: Any) {
        let context = LAContext()
        var error: NSError? = nil
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics
                                     , error: &error) {
            
            let reason = "Please authorise with touch id!"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, error in
                DispatchQueue.main.async {
                    guard success , error == nil else {
                        //failed
                        let alert = UIAlertController(title: "Failed to Authentificate".localizedaAuth, message: "Please try again".localizedaAuth, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss".localizedaAuth, style: .cancel, handler: nil))
                        self?.present(alert, animated: true)
                        return
                    }
                    //show other screen success
                    self!.performSegue(withIdentifier: "AuthToHome", sender: sender)
                }
            }
        }
        else {
            let alert = UIAlertController(title: "Unavailable".localizedaAuth, message: "you can use this feature".localizedaAuth, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss".localizedaAuth, style: .cancel, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
    }
    
    
    
    
    
    
    @IBAction func btnFacebook(_ sender: Any) {
       // self.loginButtonClicked()
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"], from: self, handler: { result, error in
            if error != nil {
                print("ERROR: Trying to get login results")
            } else if result?.isCancelled != nil {
                print("The token is \(result?.token?.tokenString ?? "")")
                if result?.token?.tokenString != nil {

                    print("Logged in")
                    self.getUserProfile(token: result?.token, userId: result?.token?.userID)
                    self.performSegue(withIdentifier: "AuthToHome", sender: sender)
                } else {
                    print("Cancelled")
                }
            }

        })
     

        
        }
   
    
    func getUserProfile(token: AccessToken?, userId: String?) {
            let graphRequest: GraphRequest = GraphRequest(graphPath: "me", parameters: ["fields": "id, first_name, middle_name, last_name, name, picture, email"])
            graphRequest.start { _, result, error in
                if error == nil {
                    let data: [String: AnyObject] = result as! [String: AnyObject]
                    
                    // Facebook Id
                    if let facebookId = data["id"] as? String {
                        print("Facebook Id: \(facebookId)")
                    } else {
                        print("Facebook Id: Not exists")
                    }
                    
                    // Facebook First Name
                    if let facebookFirstName = data["first_name"] as? String {
                        print("Facebook First Name: \(facebookFirstName)")
                    } else {
                        print("Facebook First Name: Not exists")
                    }
                    
                    // Facebook Middle Name
                    if let facebookMiddleName = data["middle_name"] as? String {
                        print("Facebook Middle Name: \(facebookMiddleName)")
                    } else {
                        print("Facebook Middle Name: Not exists")
                    }
                    
                    // Facebook Last Name
                    if let facebookLastName = data["last_name"] as? String {
                        print("Facebook Last Name: \(facebookLastName)")
                    } else {
                        print("Facebook Last Name: Not exists")
                    }
                    
                    // Facebook Name
                    if let facebookName = data["name"] as? String {
                        print("Facebook Name: \(facebookName)")
                    } else {
                        print("Facebook Name: Not exists")
                    }
                    
                    // Facebook Profile Pic URL
                    let facebookProfilePicURL = "https://graph.facebook.com/\(userId ?? "")/picture?type=large"
                    print("Facebook Profile Pic URL: \(facebookProfilePicURL)")
                    
                    // Facebook Email
                    if let facebookEmail = data["email"] as? String {
                        print("Facebook Email: \(facebookEmail)")
                    } else {
                        print("Facebook Email: Not exists")
                    }
                    
                    print("Facebook Access Token: \(token?.tokenString ?? "")")
                } else {
                    print("Error: Trying to get user's info")
                }
            }
        }
    
    
    func isLoggedIn() -> Bool {
            let accessToken = AccessToken.current
            let isLoggedIn = accessToken != nil && !(accessToken?.isExpired ?? false)
            return isLoggedIn
        }
    
    
    
    
    
    @IBAction func btnGoogle(_ sender: Any) {
       let signInConfig=GIDConfiguration.init(clientID:"768972209259-5gb9dd30tars06s3v9hg3nkt1k869n4p.apps.googleusercontent.com")
        
       
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            guard error == nil else { return}
            guard let user = user else { return }

            if let profiledata = user.profile {
                
                let userId : String = user.userID ?? ""
                let givenName : String = profiledata.givenName ?? ""
                let familyName : String = profiledata.familyName ?? ""
                let email : String = profiledata.email
                print("userId: \(userId)")
                print("email: \(email)")
                print("familyName: \(familyName)")
                print("givenName: \(givenName)")
                

                self.performSegue(withIdentifier: "AuthToHome", sender: sender)


               
                
            }
            
        }
    }
    

    
    }
    
    
   

extension String {
    var localizedaAuth: String {
        return NSLocalizedString(self, comment: "")
    }
}
