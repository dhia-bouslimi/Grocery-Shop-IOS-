//
//  HomeSwiftUIView.swift
//  Shop
//
//  Created by hamza-dridi on 16/11/2022.
//

import SwiftUI
import UIKit

let getUrl = "http://172.17.1.50:2500/promotions/promotion"
let promoUrl = "http://172.17.1.50:2500/promotions/addpromotion"

struct Promo: Codable {
    let id, prixPromo: String
    let duree: String
    let createdAt: String
    let v: Int
    let welcomeID: String
    let produit: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case prixPromo = "prix_promo"
        case duree, createdAt
        case v = "__v"
        case welcomeID = "id"
        case produit
    }
}

class ViewPromo: ObservableObject {
    @Published var items = [Promo]()
    func loadData() {
        guard let url = URL(string: getUrl) else { return }
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            if err == nil{
                do {
                    if let data = data {
                        let result = try JSONDecoder().decode([Promo].self, from: data)
                        DispatchQueue.main.async {
                            self.items = result
                            print(self.items)
                        }
                    } else {
                        print("no data")
                    }
                    
                } catch (let error){
                    print(error)
                }
            }
        }.resume()
    }
    func addProposition(parameters: [String: Any]){
        
            guard let url = URL(string: promoUrl) else {
                print("not found")
                return
            }
            let data = try! JSONSerialization.data(withJSONObject: parameters)
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = data
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            
            URLSession.shared.dataTask(with: request) {
                (data , res , error) in
                if error != nil
                {
                    print ("error", error?.localizedDescription ?? "")
                    return
                }
                do {
                    if let data = data {
                        let result = try JSONDecoder().decode(Promo.self, from: data)
                        DispatchQueue.main.async {
                           
                            print(result)
                        }
                        
                    }
                    else {
                        print ("no data")
                    }
                } catch let JsonError {
                    
                    //  print("fetch json error :", JsonError.localizedDescription)
                    print(String(describing: JsonError))
                    
                }
            }.resume()
            
            
        }
}

struct HomeSwiftUIView: View {
    
    @ObservedObject var viewPromo = ViewPromo()
    @State var showListItems = false
    @State var animationDelay = 0.5
    @State var selectedIndex = 0
    let icons = [
        "house",
        "gift",
        "plus",
        "map",
        "person"
    ]
    let image = ["20.jpg"]
    var body: some View {
        VStack{
            //content
            ZStack{
                switch selectedIndex{
                case 0:
                    NavigationView{
                        VStack{
                            
                            storyboardviewstock().edgesIgnoringSafeArea(.all)
                        }
                
                    }
                case 1:
                    NavigationView{
                        
                        
                        VStack{
                            HStack{
                                button
                               Spacer()
                            }
                            
                            ScrollView {
                                ForEach (viewPromo.items, id: \.id) { item in
                                    HStack {
                                        
                                        Spacer()
                                        Text(item.prixPromo)
                                            .font(.system(size: 14, weight:  .heavy))
                                            .padding(.vertical, 10)
                                            .padding(.horizontal, 16)
                                            .background(Color.green)
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                                        Spacer()
                                        Text(item.duree)
                                            .font(.footnote)
                                            .fontWeight(.bold)
                                            .padding(.vertical, 2)
                                            .foregroundColor(.white)
                                        Spacer()
                                        Text(item.produit!)
                                            .font(.footnote)
                                            .fontWeight(.bold)
                                            .padding(.vertical, 2)
                                            .foregroundColor(.white)
                                        
                                        
                                        
                                        
                                    }.foregroundColor(.white)
                                        .padding()
                                        .background(Color.gray)
                                        .clipShape(RoundedRectangle(cornerRadius: 70.0))
                                    
                                    
                                }
                                
                            }
                            
                        }.onAppear(perform: {
                            viewPromo.loadData()
                            
                            
                        })
                        .accentColor(Color.black)
                        .background(Color.green.opacity(0.5))
                        .navigationTitle("Promotion Du Jour")
                        
                        
                        
                        
                        
                        
                    }
                case 2:
                    NavigationView{
                        VStack{
                            
                            storyboardview().edgesIgnoringSafeArea(.all)
                        }
                        
                    }
                case 3:
                    NavigationView{
                        VStack{
                            Text("First Screen")
                        }
                        .navigationTitle("Map")
                    }
                default:
                    NavigationView{
                        VStack{
                            //Text("Second Screen")
                            storyboardviewprofil().edgesIgnoringSafeArea(.all)
                        }
                        
                    }
                    
                    
                }
            }
            Divider()
            HStack{
                ForEach(0..<5, id: \.self){number in
                    Spacer()
                    
                    Button(action: {
                        self.selectedIndex = number
                        
                    }, label:{
                        if number == 2 {
                            Image(systemName: icons[number])
                                .font(.system(size: 25,
                                              weight: .regular,
                                              design: .default ))
                                .foregroundColor(.green)
                                .frame(width: 60, height: 60)
                                .background(Color.blue )
                                .cornerRadius(30 )
                        } else {
                            Image(systemName: icons[number])
                                .font(.system(size: 25,
                                              weight: .regular,
                                              design: .default ))
                                .foregroundColor(selectedIndex == number ? .green :
                                                    Color(UIColor.lightGray))
                        }
                    })
                    Spacer()
                    
                }
            }
        }
    }
    
    
    
    var button: some View {
            NavigationLink(
                destination:
                   SwiftUIView(prix_promo: "", produit: "", duree: "")
            ) {
              
            }
            .buttonStyle(SecondaryButton(buttonTextColor: Color.green, buttonBackground: Color.red))
            
        }
    struct SecondaryButton: ButtonStyle {
        let buttonTextColor: Color
        let buttonBackground: Color
        
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
            Circle().fill(Color.gray).frame(width: 40, height: 40)
                .shadow(radius: 20)
                .overlay(Image(systemName: "pencil.circle.fill").font(.largeTitle)).foregroundColor(Color.green)
        }
    }
    
  
}

struct HomeSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        HomeSwiftUIView()
    }
}













struct storyboardview: UIViewControllerRepresentable{
    func makeUIViewController(context: Context) -> some UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: "ListFournisseurViewController")
        return controller
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}



struct storyboardviewprofil: UIViewControllerRepresentable{
    func makeUIViewController(context: Context) -> some UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: "ProfilViewController")
        return controller
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

struct storyboardviewstock: UIViewControllerRepresentable{
    func makeUIViewController(context: Context) -> some UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: "StockViewController")
        return controller
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
struct storyboardviewpromo: UIViewControllerRepresentable{
    func makeUIViewController(context: Context) -> some UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: "PromoViewController")
        return controller
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}


