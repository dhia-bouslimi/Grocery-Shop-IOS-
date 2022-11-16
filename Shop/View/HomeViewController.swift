//
//  HomeViewController.swift
//  Shop
//
//  Created by hamza-dridi on 14/11/2022.
//

import UIKit
import SwiftUI
class HomeViewController: UIViewController {
    @IBAction func profilToHomeVC(sender: UIStoryboardSegue){
        
    }
    @IBOutlet weak var theContainer : UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let childView = UIHostingController(rootView: HomeSwiftUIView())
        addChild(childView)
        childView.view.frame = theContainer.bounds
        theContainer.addSubview(childView.view)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
