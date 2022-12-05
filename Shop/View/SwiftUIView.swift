//
//  SwiftUIView.swift
//  Shop
//
//  Created by hamza-dridi on 3/12/2022.
//

import SwiftUI
import UserNotifications
class NotificationManager {
    static let instance = NotificationManager()
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (success, error) in
            if let error = error {
                print("error: \(error)")
            } else {
                print("SUCCESS")
            }
        }
    }
    
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "New Promotion for You "
        content.subtitle = "ENTER THE APPLICATION TO DISCOVER NEW PROMOTION !!"
        content.sound = .default
        content.badge = 1
        
        // timer
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)
        
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}

struct SwiftUIView: View {
    @ObservedObject var view = ViewPromo()
    @State var prix_promo: String
    @State var produit: String
    @State var duree: String
    @State var active: Bool = false
@State private var showalert = false

    var body: some View {
        VStack{
    
            
            Form{
                matesSection
                matesSection1
                matesSection2
              
            }
 
            doneButton
    
        }
    }
    
 
    var matesSection: some View {
        FormSwiftUIView(inputText: $prix_promo ,title: "Prix promo", placeholderText: "Prix promo")
        }
    var matesSection1: some View {
        FormSwiftUIView(inputText: $produit ,title: "Produit", placeholderText: "Produit")
        }
    
    var matesSection2: some View {
        FormSwiftUIView(inputText: $duree ,title: "Durée Du Promotion", placeholderText: "Durée Du Promotion")
        }
        
    var doneButton: some View {
            NavigationLink(destination: HomeSwiftUIView().navigationBarBackButtonHidden(true))
            {
                Button(action: {
                    
                    self.verify()
                   
                }) {
                    Text("save")
                        .frame(maxWidth: 200,minHeight: 40)
                        .background(Color.green)
                        .cornerRadius(25)
                        .foregroundColor(Color.white)
                        
                } .alert(isPresented: $showalert) {
                    Alert(title: Text("Successfully Added"))
                    
                }
                

            }

        
        
    }
    
    func verify()
    {
        if prix_promo != "" && produit != "" && duree != ""  {
            let parameters: [String: Any] = ["prix_promo": prix_promo, "produit": produit, "duree": duree]
            view.addProposition(parameters: parameters)
            NotificationManager.instance.requestAuthorization()
            NotificationManager.instance.scheduleNotification()
            
            self.showalert = true
            
        } else {
            
        }

    }
        
}



