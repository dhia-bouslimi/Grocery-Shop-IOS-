//
//  EditProfilViewController.swift
//  Shop
//
//  Created by hamza-dridi on 16/11/2022.
//

import UIKit
import CoreData
import Alamofire

extension UIImageView {
    func downloaded(url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFill){
        contentMode = mode
       
        URLSession.shared.dataTask(with: url) { data, response, error in
guard
    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
    let mimeType = response?.mimeType, mimeType.hasPrefix("photo"),
    let data = data, error == nil,
    let image = UIImage(data: data)
            else{ return }
            DispatchQueue.main.async {
                
                self.image = image
            }
        }.resume()
    }
    func downloaded(link: String){
        guard let url = URL(string: link) else { return }
        print(url)
        downloaded(url: url)
    }
}

class EditProfilViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public var connectedUser: User = User(id: "", email: "", password: "", firstName: "", lastName: "", gender: "" , age: "", photo: "")
    var pickedImage = false
 
    @IBOutlet weak var editAgeTxt: UITextField!
    @IBOutlet weak var editLastnameTxt: UITextField!
    @IBOutlet weak var editFirstnameTxt: UITextField!
    @IBOutlet weak var editEmailTxt: UITextField!
    
    @IBOutlet weak var imgProfile: UIImageView!
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    
   
    fileprivate let baseURL = "http://172.17.1.50:2500"
    var imagePicker = UIImagePickerController()
    var networkService = NetworkService()
    var returnedAvatar:String="default"

    public var SuccessMessage:Message = Message(message: "")

    
    override func viewDidLoad() {
        super.viewDidLoad()
      /* let tapgesture = UITapGestureRecognizer(target: self, action:
                                                    #selector(imageTapped(tapGestureRecognizer: )))
      
        imgprofil.addGestureRecognizer(tapgesture)*/
        imgProfile.backgroundColor = .cyan
       imgProfile.layer.masksToBounds = true
        imgProfile.layer.cornerRadius = imgProfile.frame.height / 2
        
        getConnectedUser()
        setupUser()
        
        let completeLink = connectedUser.photo
        print(completeLink)
        let imageUrl = URL(string: completeLink!)
        let task = URLSession.shared.dataTask(with: imageUrl!) {
            (data,response,error ) in
            if let error = error {
                print(error)
                return
            }
            if let data = data, let image = UIImage(data:data) {
                DispatchQueue.main.async {
                    self.imgProfile.image = image
                }
            }
             }
        task.resume()
        
        
    }
    
  /*  @objc
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        openGallery()
        print("image clicked")
    }*/
    
    

    
    
    
    func setupUser() {
        editLastnameTxt.text = connectedUser.lastName
        editFirstnameTxt.text = connectedUser.firstName
        editEmailTxt.text = connectedUser.email
        editAgeTxt.text = connectedUser.age
       // let completeLink = connectedUser.photo
       // print(completeLink)
         // imgProfile.downloaded(link: completeLink!)
       
        
        
        
        
        
        
        
    }
    
    
    
    
    /*@IBAction func UploadAction(_ sender: UIButton) {
     /*   if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    func uploadImage(with image: UIImage?, completion: (() -> Void)? = nil) {
        
        guard let pickedImage = image else {
            completion?()
            return
        }

        networkService.uploadImage(with: pickedImage) {photo in
            self.returnedAvatar=photo
            completion?()
        } onError: { error in
            print(error)
            completion?()
        }*/
        
    }*/
    
    
  /*  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        guard let pickedImage = info[.originalImage] as? UIImage else { return }
        profileImageView.image = pickedImage
    }*/
    
    
    
    
    
    @IBAction func selectBtn(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) && !pickedImage {
                      let imagePickerController = UIImagePickerController()
                      imagePickerController.delegate = self
                      imagePickerController.sourceType = .photoLibrary
                      self.present(imagePickerController, animated: true, completion: nil)
                      pickedImage = true
              }
    }
    
    
    
    
    
    @IBAction func uploadbTN(_ sender: Any) {
       guard let imageData = imgProfile.image?.jpegData(compressionQuality: 0.75) else { return }
        uploadImage(imgData: imageData, imageName: "chichi.jpg")
    }
    
    
    
    func uploadImage(imgData:Data,imageName:String){
      
   
       
       
        let params = ["id":connectedUser.id]
       print(params)
       AF.upload(multipartFormData: { multiPart in
           multiPart.append(imgData, withName: "photo",fileName: imageName,mimeType: "image/*")

         for (key,keyValue) in params{
               if let keyData = keyValue!.data(using: String.Encoding.utf8){
                       multiPart.append(keyData, withName: key)
                   }
               }
       }, to: "http://172.17.1.50:2500/users/updatephoto/\(connectedUser.id!)",headers: []).responseJSON { apiResponse in
           
           switch apiResponse.result{
           case .success(_):
               let apiDictionary = apiResponse.value as? [String:Any]
               print("apiResponse --- \(apiDictionary)")
               print("ajout avec succes")
               print ( "http://172.17.1.50:2500/users/updatephoto/\(self.connectedUser.id!)")

           case .failure(_):
               print("got an error")
               print(apiResponse.error?.errorDescription)            }
       }
       
       
        
   }

    
    
    
    
    
    
 
    
    
    
   
    @IBAction func SaveBtn(_ sender: Any) {
      
        let parameters = ["id" : connectedUser.id,"firstName" : editFirstnameTxt.text! ,"lastName" : editLastnameTxt.text! , "email" : editEmailTxt.text!, "age" : editAgeTxt.text!]  as [String:Any]
        
        guard let url = URL(string: self.baseURL+"/users/UpdateUser") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        var status = 0
        URLSession.shared.dataTask(with: request) { (data,response,error) in
            if error == nil{
                do {
                    
                    let httpResponse = response as? HTTPURLResponse
                    status = httpResponse!.statusCode

                        self.connectedUser = try JSONDecoder().decode(User.self, from: data!)
                        print(self.connectedUser)
                        print("serialize user")
                    
                        
                } catch {
                    print("parse json error")
                }
        
                DispatchQueue.main.async {
                    
                    if(status == 202)
                    {
                
                     self.updateData(id: self.connectedUser.id!)
                     self.performSegue(withIdentifier: "editProfilToLogin", sender: sender)
                     //  self.saveConnectedUser()
                     //  self.getConnectedUser()
                      //  self.setupUser()
                       /* self.uploadImage(with: self.profileImageView.image) {
                            DispatchQueue.main.async {
                                self.updateUserAvatar(message: self.returnedAvatar)
                            }
                        }*/
                      
                    }
                   
                    
                 
                    
                }
            }
        }.resume()
    }
    
    
    
    
   /* func updateUserAvatar(message:String) {
        let emailValue=editEmailTxt.text
        let parameters = ["photo" : message,"email" : emailValue]
        guard let url = URL(string: self.baseURL+"/users/updatephoto/:id") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        URLSession.shared.dataTask(with: request) { (data,response,error) in
            if error == nil{
                do {
                    self.SuccessMessage = try JSONDecoder().decode(Message.self, from: data!)
                } catch {
                    print("parse profile customer error")
                }
        
                DispatchQueue.main.async {
                    print(self.SuccessMessage.message)
                   
                }
            }
        }.resume()
    }*/
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func updateData(id : String) {
        guard
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Connected", in : managedContext)
        let request = NSFetchRequest < NSFetchRequestResult > ()
        request.entity = entity
        let predicate = NSPredicate(format:"id = %@", id as String)
        request.predicate = predicate
        do {
            let results =
                try managedContext.fetch(request)
            let object = results[0] as!NSManagedObject

            //
            object.setValue(editFirstnameTxt.text!, forKey: "name")
            object.setValue(editLastnameTxt.text!, forKey: "lastName")
            object.setValue( editEmailTxt.text!, forKey: "email")
            object.setValue(editAgeTxt.text!, forKey: "age")
          //  object.setValue(photo.text!, forKey: "photo")

            
            
            do {
                try managedContext.save()
                print("user Updated!")
            /*    let tabBarController = self.storyboard?.instantiateViewController(identifier:ID_TABBAR) as! UITabBarController
                   self.navigationController?.pushViewController(tabBarController, animated:true)
                self.dismiss(animated:true, completion:nil);
                self.navigationController?.popViewController(animated:true);*/
            } catch
            let error as NSError {}
        } catch
        let error as NSError {}
    }
    
    
    func saveConnectedUser() -> Void {
        
        let appD = UIApplication.shared.delegate as! AppDelegate
        let PC = appD.persistentContainer
        let managedContext = PC.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Connected",in: managedContext)!
        let object = NSManagedObject(entity: entity,insertInto: managedContext)
        
        object.setValue(self.connectedUser.id, forKey: "id")
        object.setValue(self.connectedUser.firstName, forKey: "name")
        object.setValue(self.connectedUser.lastName, forKey: "lastName")
        object.setValue(self.connectedUser.email, forKey: "email")
        object.setValue(self.connectedUser.age, forKey: "age")
        object.setValue(self.connectedUser.photo, forKey: "photo")

       
                
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
     
    }
    
    
    
    func getConnectedUser() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Connected")
        do {
            let result = try managedContext.fetch(fetchRequest)
            for obj in result {
                self.connectedUser.id =  (obj.value(forKey: "id") as! String)
                self.connectedUser.firstName=(obj.value(forKey: "name") as! String)
                self.connectedUser.lastName=(obj.value(forKey: "lastName") as! String)
                self.connectedUser.email=(obj.value(forKey: "email") as! String)
                self.connectedUser.age=(obj.value(forKey: "age") as! String)
                self.connectedUser.photo = (obj.value(forKey: "photo") as! String)

               
                
                
                
                
            }
            
         
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    
    
    
    
    
    
  /*  @IBAction func btnEditphoto(_ sender: Any) {
        let parameter = ["id" : connectedUser.id,"firstName" : editFirstnameTxt.text! ,"lastName" : editLastnameTxt.text! , "email" : editEmailTxt.text!, "age" : editAgeTxt.text!]  as [String:Any]
        
        guard let url = URL(string: self.baseURL+"/users/updatephoto/:id") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameter, options: []) else { return }
        request.httpBody = httpBody
        var status = 0
        URLSession.shared.dataTask(with: request) { (data,response,error) in
            if error == nil{
                do {
                    
                    let httpResponse = response as? HTTPURLResponse
                    status = httpResponse!.statusCode

                        self.connectedUser = try JSONDecoder().decode(User.self, from: data!)
                        print(self.connectedUser)
                        print("serialize user")
                    
                        
                } catch {
                    print("parse json error")
                }
        
                DispatchQueue.main.async {
                    
                    if(status == 202)
                    {
                      /*  let tabBarController = self.storyboard?.instantiateViewController(identifier:self.ID_TABBAR) as! UITabBarController
                           self.navigationController?.pushViewController(tabBarController, animated:true)
                        self.dismiss(animated:true, completion:nil);
                        self.navigationController?.popViewController(animated:true);*/
                        
                        self.updateData(id: self.connectedUser.id!)

                       self.saveConnectedUser()
                       self.getConnectedUser()
                        self.setupUser()
                        self.performSegue(withIdentifier: "editphotoToProfil", sender: sender)
                    }
                   
                    
                 
                    
                }
            }
        }.resume()
        
    }*/
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imgProfile.image = image
           self.dismiss(animated: true, completion: nil)
       }
       func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
           self.dismiss(animated: true, completion: nil)
       }

        
        
    }




/*extension EditProfilViewController: UINavigationControllerDelegate,
                                    UIImagePickerControllerDelegate{
    
    func openGallery(){
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .savedPhotosAlbum
            present(picker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let img = info[.originalImage] as? UIImage{
            imgprofil.image = img
        }
        dismiss(animated: true)
    }
}*/
    

