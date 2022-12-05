//
//  PromoViewController.swift
//  Shop
//
//  Created by hamza-dridi on 3/12/2022.
//

import UIKit
/*struct Promo : Decodable {
    let prix_promo: String
    let duree: String
    let produit : String
  
}
class PromoViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    @IBOutlet weak var collectionPromo: UICollectionView!
    var promos = [Promo]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
         collectionPromo.delegate = self
        collectionPromo.dataSource = self
        // Do any additional setup after loading the view.
        let url = URL(string: "https://shopapp.onrender.com/promotions/promotion")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil {
                do {
                    self.promos = try JSONDecoder().decode([Promo].self, from: data!)
                    
                } catch {
                    print("parse Error")
                }
                DispatchQueue.main.async {
                    self.collectionPromo.reloadData()
                    print(self.promos)
                }
                        }
        }.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return promos.count    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PromoCollectionViewCell
        cell.dureeLbl.text = promos[indexPath.row].duree.capitalized
        cell.produitLbl.text = promos[indexPath.row].produit.capitalized

        cell.prixLbl.text = promos[indexPath.row].prix_promo.capitalized
       
        return cell
    }
    


}*/
