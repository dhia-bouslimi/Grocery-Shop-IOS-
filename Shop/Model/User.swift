//
//  User.swift
//  Shop
//
//  Created by hamza-dridi on 10/11/2022.
//

import Foundation
struct User: Decodable {
    var id : String?
    var email : String?
    var password : String?
    var firstName : String?
    var lastName: String?
    var gender : String?
    var age : String?
    var photo : String?
    var code : String?
    var codeAdmin : String?

}
