//
//  StockViewController.swift
//  Shop
//
//  Created by hamza-dridi on 26/11/2022.
//

import UIKit
import Alamofire
extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFill){
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
guard
    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
    let data = data, error == nil,
    let image = UIImage(data: data)
            else{ return }
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit){
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}




struct Stock: Decodable {
    let type: String
    let image: String
    let quantite : String
    let prix : String
}
class StockViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    
  
    @IBOutlet weak var collectionview: UICollectionView!
    
    
    var stocks = [Stock]()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       
        collectionview.delegate = self
        collectionview.dataSource = self
        let url = URL(string: "http://172.17.1.50:2500/stocks/stock")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil {
                do { 
                    self.stocks = try JSONDecoder().decode([Stock].self, from: data!)
                    
                } catch {
                    print("parse Error")
                }
                DispatchQueue.main.async {
                    self.collectionview.reloadData()
                }
                        }
        }.resume()
    }
    
    
    @IBAction func Add(_ sender: Any) {
        
        self.performSegue(withIdentifier: "addToEditproduit", sender: sender)

    }
    
    func DeleteStock (type : String,onSuccess: @escaping () -> Void ,onFailure: @escaping (_ errorMessage: String) -> Void ) {
          
           AF.request("http://172.17.1.50:2500/stocks/delete/\(type)", method: .delete,
                      
                      encoding: JSONEncoding.prettyPrinted)
          
           .responseJSON() {
               (response) in
             
               switch response.result {
                   
               case .success(let res):
           
                   print("Delete faints successful")
                    
                   onSuccess()
                   
                   
               case .failure(let err):
                   onFailure(err.errorDescription!)
                   print("Delete faints failed",err)
                   return
               }
           }
       }
   
    @IBAction func deletestock(_ sender: Any) {
        let point = (sender as AnyObject).convert(CGPoint.zero, to:collectionview)
               guard let indexpath = collectionview.indexPathForItem(at: point) else { return }
               var type = stocks[indexpath.row].type
               DeleteStock(type: type, onSuccess: {
                   self.stocks.remove(at: indexpath.row)
                   self.collectionview.reloadData()
               },onFailure: {errorMessage in
                   print("error")
                   
               })
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stocks.count    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customcell", for: indexPath) as! CustomCollectionViewCell
        cell.typelbl.text = stocks[indexPath.row].type.capitalized
        cell.imageview.contentMode = .scaleAspectFill
        let completeLink = stocks[indexPath.row].image
        print(completeLink)
        cell.imageview.downloadedFrom(link: completeLink)
        cell.imageview.layer.cornerRadius = 38
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let controller: DetailstockViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailstockViewController") as! DetailstockViewController
        controller.strtype = ( "Type : \( stocks[indexPath.row].type.capitalized)")
        controller.strquantite = ( "Quantite : \(stocks[indexPath.row].quantite.capitalized)")
        controller.strprix = ( "Prix : \(stocks[indexPath.row].prix.capitalized)")
       // controller.imgproduit.contentMode = .scaleAspectFit
       // let completeLink = stocks[indexPath.row].image
      //  controller.imgproduit.downloadedFrom(link: completeLink)
        print("you have clicked on \(stocks[indexPath.row].type.capitalized)")
        self.navigationController?.pushViewController(controller, animated: true)
        


        }
   

   

}
