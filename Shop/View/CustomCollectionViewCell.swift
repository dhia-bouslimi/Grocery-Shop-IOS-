//
//  CustomCollectionViewCell.swift
//  Shop
//
//  Created by hamza-dridi on 26/11/2022.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageview: UIImageView!
    
    @IBOutlet weak var typelbl: UILabel!
    
    var cornerRadius: CGFloat = 5.0

     override func awakeFromNib() {
         super.awakeFromNib()
             
         // Apply rounded corners to contentView
         contentView.layer.cornerRadius = cornerRadius
         contentView.layer.masksToBounds = true
         
         // Set masks to bounds to false to avoid the shadow
         // from being clipped to the corner radius
         layer.cornerRadius = cornerRadius
         layer.masksToBounds = false
         
         // Apply a shadow
         layer.shadowRadius = 8.0
         layer.shadowOpacity = 0.10
         layer.shadowColor = UIColor.blue.cgColor
         layer.shadowOffset = CGSize(width: 2, height: 5)
     }
     
     override func layoutSubviews() {
         super.layoutSubviews()
         
         // Improve scrolling performance with an explicit shadowPath
         layer.shadowPath = UIBezierPath(
             roundedRect: bounds,
             cornerRadius: cornerRadius
         ).cgPath
     }
    
}
