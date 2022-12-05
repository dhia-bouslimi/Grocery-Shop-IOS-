//
//  EditProduitViewController.swift
//  Shop
//
//  Created by hamza-dridi on 30/11/2022.
//

import UIKit
import Alamofire
class EditProduitViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var pickedImage = false
    @IBOutlet weak var quantiteP: UITextField!
    @IBOutlet weak var prixp: UITextField!
    @IBOutlet weak var typeP: UITextField!
    
    
    
    @IBOutlet weak var imgp: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func editBtn(_ sender: Any) {
        let typee = typeP.text
        let prix = prixp.text
        let quantite = quantiteP.text

        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) && !pickedImage {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
            pickedImage = true
        }
    }
    
    
    
    
 
    
    
    func uploadImage(imgData:Data,imageName:String){
       // params to send additional data, for eg. AccessToken or userUserId
        let params = ["type": typeP.text! , "prix": prixp.text!, "quantite": quantiteP.text!]
       print(params)
       AF.upload(multipartFormData: { multiPart in
           for (key,keyValue) in params{
                   if let keyData = keyValue.data(using: .utf8){
                       multiPart.append(keyData, withName: key)
                   }
               }
           multiPart.append(imgData, withName: "image",fileName: imageName,mimeType: "image/*")
       }, to: "http://172.17.2.174:2500/stocks/addStock",headers: []).responseJSON { apiResponse in
           
           switch apiResponse.result{
           case .success(_):
               let apiDictionary = apiResponse.value as? [String:Any]
              print("apiResponse --- \(apiDictionary)")
               print("ajout avec succes")
           case .failure(_):
               print("got an error")
           }
          
       }
   }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imgp.image = image
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    @IBAction func savebtn(_ sender: Any) {
        guard let imageData = imgp.image?.jpegData(compressionQuality: 0.75) else { return }
              uploadImage(imgData: imageData, imageName: "chichi.jpg")
        self.performSegue(withIdentifier: "returnToHome", sender: sender)

   
    }
    
    
    
    @IBAction func returnTohome(_ sender: Any) {
        self.performSegue(withIdentifier: "returnToHome", sender: sender)

    }
    
}
