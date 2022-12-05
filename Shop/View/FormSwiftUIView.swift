//
//  FormSwiftUIView.swift
//  Shop
//
//  Created by hamza-dridi on 3/12/2022.
//

import SwiftUI
struct FormSwiftUIView: View {
    @Binding var inputText: String
    
    let title: String
    let placeholderText: String
    
    var body: some View {
        Section(header: Text(title)) {
            TextField(placeholderText, text: $inputText)
        }
    }
}
