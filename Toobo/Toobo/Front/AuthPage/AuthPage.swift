import SwiftUI

struct WelcomePage: View {
    var body: some View {
        NavigationView {
            VStack {
                Image("Toobo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 150)
                
                VStack(spacing: 20) {
                    // Login Button
                    NavigationLink(destination: LoginView()) {
                        Text("Login")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 200, height: 50)
                            .background(Color.gray)
                            .cornerRadius(10)
                            .contentShape(Rectangle())
                    }
                    
                    // Register Button
                    NavigationLink(destination: RegisterView()) {
                        Text("Register")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 200, height: 50)
                            .background(Color.gray)
                            .cornerRadius(10)
                            .contentShape(Rectangle())
                    }
                }
                .navigationBarHidden(true)
                
                HStack(spacing: 30) {
                    // Google Button
                    Button(action: {
                        print("Google") // Action to perform when the button is pressed
                    }) {
                        Image("googleImage")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    }
                    // Github Button
                    Button(action: {
                        print("Github") // Action to perform when the button is pressed
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
}

#Preview {
    WelcomePage()
}
