import SwiftUI
import OAuth2

struct GitHubAuth: View {
    @State private var isLoggedIn = false
    @State private var error: Error?

    var body: some View {
        NavigationView {
            VStack {
                if isLoggedIn {
                    Text("Vous êtes connecté à GitHub")
                } else {
                    Button(action: login) {
                        Text("Se connecter à GitHub")
                    }
                }
                if let error = error {
                    Text(error.localizedDescription)
                }
            }
            .padding()
        }
    }

    func login() {
        let oauth2 = OAuth2(
clientID: "YOUR_CLIENT_ID",
            clientSecret: "YOUR_CLIENT_SECRET",
            authorizeURL: "https://github.com/login/oauth/authorize",
            tokenURL: "https://github.com/login/oauth/access_token",
            redirectURL: "YOUR_REDIRECT_URL"
        )

        oauth2.authorize { result in
            switch result {
            case .success(let token):
                // Stockez le jeton d'accès
                isLoggedIn = true
            case .failure(let error):
                self.error = error
            }
        }
    }
}

