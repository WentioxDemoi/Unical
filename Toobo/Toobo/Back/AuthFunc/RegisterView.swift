import SwiftUI

struct RegisterView: View {
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String?
    @State private var isRegistered: Bool = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Register")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 40)

                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.default)
                    .autocapitalization(.none)
                    .padding(.horizontal, 20)

                TextField("Email Address", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding(.horizontal, 20)

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 20)

                Button(action: handleRegister) {
                    Text("Register")
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
                    isActive: $isRegistered,
                    label: { EmptyView() }
                )
            }
            .padding()
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private func handleRegister() {
        let userRegistrationData = UserRegistration(
            username: username,
            email: email,
            password: password,
            role: "USER"
        )

        guard let url = URL(string: "http://localhost:8080/user/register") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(userRegistrationData)
            request.httpBody = jsonData
        } catch {
            print("Error encoding user registration data: \(error)")
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

            DispatchQueue.main.async {
                print("User registered successfully: \(userRegistrationData)")
                self.errorMessage = nil
                self.isRegistered = true // Set the state to navigate to MainPage
            }
        }.resume()
    }
}

#Preview {
    RegisterView()
}
