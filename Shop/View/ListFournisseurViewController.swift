//
//  ListFournisseurViewController.swift
//  Shop
//
//  Created by hamza-dridi on 19/11/2022.
//

import UIKit
struct jsonstruct: Decodable {
    let fullName: String
    let numTel: String
    let adresse: String
    let secteur: String
    
}
class ListFournisseurViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
   
    
    @IBOutlet weak var searchbar: UISearchBar!
    var arrdata = [jsonstruct]()

 
    fileprivate let baseURL = "https://shopapp.onrender.com"
   
    override func viewDidLoad() {
        super.viewDidLoad()
        getdata()
       
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
        detail.strnumtel = "Numéro de téléphone : \(arrdata[indexPath.row].numTel)"
        detail.stradresse = "Adresse : \(arrdata[indexPath.row].adresse)"
        detail.strsecteur = "Secteur : \(arrdata[indexPath.row].secteur)"

        self.navigationController?.pushViewController(detail, animated: true)
    }

}

