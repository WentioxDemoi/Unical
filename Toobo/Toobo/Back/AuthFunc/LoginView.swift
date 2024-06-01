import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String?
    @State private var isLogged: Bool = false // Ajoutez cet état

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Login")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 40)

                TextField("email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.default)
                    .autocapitalization(.none)
                    .padding(.horizontal, 20)

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 20)

                Button(action: handleLogin) {
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.top, 20)

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.top, 20)
                }

                NavigationLink(
                    destination: MainPage(username: username).navigationBarHidden(true),
                    isActive: $isLogged,
                    label: { EmptyView() }
                )
            }
            .padding()
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private func handleLogin() {
        let userLoginData = UserLogin(
            email: email,
            password: password
        )

        guard let url = URL(string: "http://localhost:8080/user/login") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(userLoginData)
            request.httpBody = jsonData
        } catch {
            print("Error encoding user login data: \(error)")
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                if let data = data {
                    let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
                    DispatchQueue.main.async {
                        self.errorMessage = errorMessage
                    }
                }
                return
            }

            if let data = data, let username = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    print("User Logged In Successfully: \(username)")
                    self.username = username // Mettez à jour la valeur du nom d'utilisateur local
                }
            } else {
                print("Invalid response data")
            }

            DispatchQueue.main.async {
                self.errorMessage = nil
                self.isLogged = true // Changez l'état isLogged à true pour activer la NavigationLink
            }
        }.resume()


    }
}

#Preview {
    LoginView()
}
