//
//  ViewController.swift
//  Shop
//
//  Created by hamza-dridi on 10/11/2022.
//

import UIKit
import MOLH
class ViewController: UIViewController {

    @IBOutlet weak var language: UIButton!
    @IBOutlet weak var startedBtn: UIButton!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
       
        
        // Do any additional setup after loading the view.
        language.setTitle("languageBtn".localize, for: .normal)
        startedBtn.setTitle("btnstarted".localize, for: .normal)
    }

    @IBAction func languageBtn(_ sender: UIButton) {
        MOLH.setLanguageTo(MOLHLanguage.currentAppleLanguage() == "en" ? "ar" : "en")
        MOLH.reset()
        language.setTitle("languageBtn".localize, for: .normal)
        startedBtn.setTitle("btnstarted".localize, for: .normal)
        if(MOLHLanguage.currentAppleLanguage() == "en"){
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        else {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
   
    }
    
    @IBAction func btnstarted(_ sender: Any) {
        
        //self.performSegue(withIdentifier: "Page1ToAuth", sender: sender)

    }
    
}

                             extension String {
                                 var localize: String {
                                     return NSLocalizedString(self, comment: "")
                                 }
                             }
