//
//  DetailstockViewController.swift
//  Shop
//
//  Created by hamza-dridi on 27/11/2022.
//

import UIKit

class DetailstockViewController: UIViewController {

    @IBOutlet weak var imgproduit: UIImageView!
    @IBOutlet weak var prix: UILabel!
    @IBOutlet weak var quantite: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var DetailStockView: UIView!
    
    
    
    
    var strimgproduit = ""
    var strprix = ""
    var strquantite = ""
    var strtype = ""
   // var strimgproduit = UIImageView()
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DetailStockView.roundCorners([.topLeft, .topRight], radius: 50)
        prix.text = strprix
        type.text = strtype
        quantite.text = strquantite
          // imgproduit.image = strimgproduit
        
        // Do any additional setup after loading the view.
    }
    


}




extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        if #available(ios 11, *){
            var cornerMask = CACornerMask()
            if(corners.contains(.topLeft)){
                cornerMask.insert(.layerMinXMinYCorner)
            }
            if(corners.contains(.topRight)){
                cornerMask.insert(.layerMaxXMinYCorner)
            }
            if(corners.contains(.bottomLeft)){
                cornerMask.insert(.layerMinXMaxYCorner)
            }
            if(corners.contains(.bottomRight)){
                cornerMask.insert(.layerMaxXMaxYCorner)
            }
            self.layer.cornerRadius = radius
            self.layer.maskedCorners = cornerMask
            
        } else {
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }
    }
}
