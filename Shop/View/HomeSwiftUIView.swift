//
//  HomeSwiftUIView.swift
//  Shop
//
//  Created by hamza-dridi on 16/11/2022.
//

import SwiftUI
import UIKit
struct HomeSwiftUIView: View {
    @State var selectedIndex = 0
    let icons = [
    "house",
    "gift",
    "plus",
    "map",
    "person"
    ]
    var body: some View {
        VStack{
            //content
            ZStack{
                switch selectedIndex{
                case 0:
                    NavigationView{
                        VStack{
                            Text("First Screen")
                        }
                        .navigationTitle("Home")
                    }
                case 1:
                    NavigationView{
                        VStack{
                           // Text("First Screen")
                            storyboardview().edgesIgnoringSafeArea(.all)
                        }
                        .navigationTitle("Gift")
                    }
                case 2:
                    NavigationView{
                        VStack{
                            Text("First Screen")
                        }
                        .navigationTitle("Add")
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
                        .navigationTitle("Person")
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
                                .foregroundColor(.white)
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
  
}

struct HomeSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        HomeSwiftUIView()
    }
}













struct storyboardview: UIViewControllerRepresentable{
    func makeUIViewController(context: Context) -> some UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: "AuthViewController")
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
