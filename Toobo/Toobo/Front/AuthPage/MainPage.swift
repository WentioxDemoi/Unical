import SwiftUI
import CoreLocation

struct MainPage: View {
    @State private var username: String = ""
    @State private var latitude: Double?
    @State private var longitude: Double?

    var body: some View {
        VStack {
            Text("Welcome, \(username.isEmpty ? "Fetching username..." : username)!")
                .font(.largeTitle)
                .padding()

            if let latitude = latitude, let longitude = longitude {
                Text("Latitude: \(latitude)")
                Text("Longitude: \(longitude)")
            } else {
                Text("Fetching location...")
            }

            // Add more UI elements for the main page here
        }
        .navigationBarHidden(true)
        .onAppear {
            fetchLocation()
            fetchUsername()
        }
    }

    private func fetchLocation() {
        DispatchQueue.global().async {
            let locationManager = CLLocationManager()
            locationManager.requestWhenInUseAuthorization()

            if CLLocationManager.locationServicesEnabled() {
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) { // Wait a few seconds for location to be updated
                    if let location = locationManager.location {
                        DispatchQueue.main.async {
                            self.latitude = location.coordinate.latitude
                            self.longitude = location.coordinate.longitude
                        }
                    }
                    locationManager.stopUpdatingLocation()
                }
            }
        }
    }

    private func fetchUsername() {
        guard let url = URL(string: "http://localhost:8080/user/getusername") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Assuming the token is stored in UserDefaults or similar
        let token = UserDefaults.standard.string(forKey: "jwt") ?? ""

        request.httpBody = token.data(using: .utf8)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    print("Network error: \(error)")
                    self.username = "Error fetching username"
                }
                return
            }

            guard let data = data, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                DispatchQueue.main.async {
                    print("Invalid response or data")
                    self.username = "Invalid response or data"
                }
                return
            }

            if let username = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    print("Fetched username successfully: \(username)")
                    self.username = username
                }
            } else {
                DispatchQueue.main.async {
                    print("Failed to decode username")
                    self.username = "Failed to decode username"
                }
            }
        }.resume()
    }
}

#Preview {
    MainPage()
}
