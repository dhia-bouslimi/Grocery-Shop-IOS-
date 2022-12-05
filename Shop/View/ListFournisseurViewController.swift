//
//  ListFournisseurViewController.swift
//  Shop
//
//  Created by hamza-dridi on 19/11/2022.
//

import UIKit
import Alamofire
struct jsonstruct: Decodable {
    let fullName: String
    let numTel: String
    let adresse: String
    let secteur: String
    
}
class ListFournisseurViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
   
    
    @IBOutlet weak var searchbar: UISearchBar!
    var arrdata = [jsonstruct]()
    var searchedProduit = [jsonstruct]()
     var searching = false

    fileprivate let baseURL = "http://172.17.2.174:2500"
 
    
    let fournisseur = ["ahmed", "ali", "aymen"]
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getdata()
        self.searchedProduit = arrdata
        // Do any additional setup after loading the view.
    }
    
    
    
 
    
    
    
    func getdata(){
         let url = URL(string: baseURL+"/fournisseurs/fournisseur")
       
        URLSession.shared.dataTask(with: url!) { (data,response,error) in
            do{
                if error == nil {
                    self.arrdata = try JSONDecoder().decode([jsonstruct].self, from: data!)
                    for mainarr in self.arrdata{
                        //print(mainarr.fullName, ":", mainarr.numTel)
                        DispatchQueue.main.async {
                          
                            self.tableview.reloadData()
                        }
                       
                    }
                }
            }catch{
                print("ERROR in get json data")
            }
           
            
            

        }.resume()
    }
    
    
    @IBAction func deletebtn(_ sender: Any) {
        let point = (sender as AnyObject).convert(CGPoint.zero, to:tableview)
               guard let indexpath = tableview.indexPathForRow(at: point) else { return }
               var fullName = arrdata[indexpath.row].fullName
        DeleteFournisseur(fullName: fullName, onSuccess: {
                   self.arrdata.remove(at: indexpath.row)
                   self.tableview.reloadData()
               },onFailure: {errorMessage in
                   print("error")
                   
               })
    }
    
    
    func DeleteFournisseur (fullName : String,onSuccess: @escaping () -> Void ,onFailure: @escaping (_ errorMessage: String) -> Void ) {
          
           AF.request("http://172.17.2.174:2500/fournisseurs/deletefournisseur/\(fullName)", method: .delete,
                      
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
    
    
    
    @IBAction func btnPlus(_ sender: Any) {
        self.performSegue(withIdentifier: "ListvendorToadd", sender: sender)

    }
    
    @IBOutlet weak var tableview: UITableView!
    
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrdata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: TableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        cell.name?.text = "Name: \(arrdata[indexPath.row].fullName)"
        cell.numero?.text = "Secteur: \(arrdata[indexPath.row].secteur)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail: DetailFournisseurViewController = self.storyboard?.instantiateViewController(withIdentifier: "detail") as! DetailFournisseurViewController
        detail.strfullname = "Fullname : \(arrdata[indexPath.row].fullName)"
        detail.strnumtel = "Numéro : \(arrdata[indexPath.row].numTel)"
        detail.stradresse = "Adresse : \(arrdata[indexPath.row].adresse)"
        detail.strsecteur = "Secteur : \(arrdata[indexPath.row].secteur)"

        self.navigationController?.pushViewController(detail, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        self.arrdata.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.endUpdates()
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0, y: 1)
        UIView.animate(withDuration: 0.5, delay: 0.05 * Double(indexPath.row), animations: {
            cell.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }

}


