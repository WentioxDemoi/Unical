//
//  AuthPage.swift
//  Toobo
//
//  Created by Rémi Desbordes on 28/03/2024.
//

import Foundation
import SwiftUI
import UIKit

struct WelcomePage: View {
    var body: some View {
        
        VStack {
            Image("Toobo")
                .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 150)
                    
            VStack(spacing: 20){
            // Login Button
                Button(action: { Login() }) {
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200, height: 50)
                        .background(Color.gray)
                        .cornerRadius(10)
                        .contentShape(Rectangle()) // Ajoutez cette ligne
                }

            // Register Button
                Button(action: {
                    Register()
                }) {
                    Text("Register")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200, height: 50)
                        .background(Color.gray)
                        .cornerRadius(10)
                        .contentShape(Rectangle()) // Ajoutez cette ligne
                }
            }.padding(.bottom, 20)
            
            
            HStack(spacing: 30) {
            // Google Button
                Button(action: {
                    print ("Google")// Action à effectuer lorsque le bouton est pressé
                }) {
                    Image("googleImage")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                }
            // Github Button
                Button(action: {
                    print ("Github")// Action à effectuer lorsque le bouton est pressé
                }) {
                    Image("githubImage")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .frame(maxWidth: .infinity, alignment: .center)
        .offset(y: -50)
    }
}
