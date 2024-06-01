//
//  MainPage.swift
//  Toobo
//
//  Created by Rémi Desbordes on 01/06/2024.
//

import SwiftUI

struct MainPage: View {
    var username: String

    var body: some View {
        VStack {
            Text("Welcome, \(username)!")
                .font(.largeTitle)
                .padding()
            // Add more UI elements for the main page here
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    MainPage(username: "TestUser")
}
