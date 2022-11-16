//
//  Parser.swift
//  Shop
//
//  Created by hamza-dridi on 11/11/2022.
//

import Foundation

func Parse() {
    let api = URL(string: "")
    
    URLSession.shared.dataTask(with: api!){
        data ,response ,error in
        if error != nil{
            print(error?.localizedDescription)
            return
        }
        do {
            let result = try JSONDecoder().decode(User.self, from: data!)
            print(result)
            
        } catch {
            
        }
            
            
    }.resume()
        
    }
