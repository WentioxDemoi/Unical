import SwiftUI
import CoreLocation

struct MainPage: View {
    @State private var username: String = ""
        @State private var latitude: Double?
        @State private var longitude: Double?
        @State private var weatherData: WeatherData? // Déclarer une variable d'état pour stocker les données météorologiques

        var body: some View {
            VStack(spacing: 20) {
                // Welcome rectangle
                ZStack {
                    Rectangle()
                        .fill(Color.blue)
                        .frame(height: 80)
                        .cornerRadius(10)

                    Text("Welcome, \(username.isEmpty ? "Fetching username..." : username)!")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                }

                // Latitude & Longitude rectangle
                ZStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 60)
                        .cornerRadius(10)

                    Text("Your Latitude & Longitude")
                        .font(.title2)
                        .foregroundColor(.gray)
                }

                // HStack with Latitude and Longitude squares
                if let latitude = latitude, let longitude = longitude {
                    HStack(spacing: 20) {
                        // Latitude square
                        ZStack {
                            Rectangle()
                                .fill(Color.gray)
                                .frame(height: 100)
                                .cornerRadius(10)
                                .frame(maxWidth: .infinity) // Add this line

                            VStack(spacing: 10) {
                                Text("Latitude")
                                    .font(.title3)
                                    .foregroundColor(.white)

                                Text("\(latitude)")
                                    .font(.title2)
                                    .foregroundColor(.white)
                            }
                        }

                        // Longitude square
                        ZStack {
                            Rectangle()
                                .fill(Color.gray)
                                .frame(height: 100)
                                .cornerRadius(10)
                                .frame(maxWidth: .infinity) // Add this line

                            VStack(spacing: 10) {
                                Text("Longitude")
                                    .font(.title3)
                                    .foregroundColor(.white)

                                Text("\(longitude)")
                                    .font(.title2)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .onAppear {
                        fetchWeather() // Appel de fetchWeather lorsque les variables latitude et longitude sont remplies
                    }
                } else {
                    Text("Fetching location...")
                }

                // Afficher les données météorologiques
                if let weatherData = weatherData {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Weather now")
                            .bold()
                            .padding(.bottom)

                        HStack {
                            WeatherRow(logo: "thermometer", name: "Min temp", value: "\(convertToCelsius(weatherData.main.temp_min))°")
                            Spacer()
                            WeatherRow(logo: "thermometer", name: "Max temp", value: "\(convertToCelsius(weatherData.main.temp_max))°")

                        }

                        HStack {
                            WeatherRow(logo: "wind", name: "Wind speed", value: "\(weatherData.wind.speed) m/s")
                            Spacer()
                            WeatherRow(logo: "humidity", name: "Humidity", value: "\(weatherData.main.humidity)%")
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .padding(.bottom, 20)
                    .foregroundColor(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
                    .background(.white)
                    //.cornerRadius(20, corners: [.topLeft, .topRight])
                } else {
                    Text("Fetching weather...")
                }
            }
            .padding()
            .navigationBarHidden(true)
            .onAppear {
                fetchLocation()
                fetchUsername()
            }
        }
    
    func convertToCelsius(_ kelvin: Double) -> Int {
        return Int(kelvin - 273.15)
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
    func fetchWeather() {
        // Récupérer le token stocké dans le code
        let token = UserDefaults.standard.string(forKey: "jwt") ?? ""
        
        // Récupérer la latitude et la longitude stockées dans le code
        guard let latitude = latitude, let longitude = longitude else {
            print("Latitude or longitude is nil")
            return
        }
        
        // Créer l'URL pour l'endpoint de l'API météo
        let urlString = "http://localhost:8080/user/getweather"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        // Créer les données JSON à envoyer dans la requête
        let weatherData: [String: Any] = [
            "token": token,
            "latitude": latitude,
            "longitude": longitude
        ]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: weatherData) else {
            print("Failed to serialize JSON data")
            return
        }
        
        // Créer la requête URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        // Envoyer la requête
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Vérifier s'il y a des erreurs
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            // Convertir les données de réponse en chaîne JSON
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Response JSON: \(jsonString)")
                do {
                    // Utiliser JSONDecoder pour décoder les données dans la structure WeatherData
                    let decodedData = try JSONDecoder().decode(WeatherData.self, from: data)
                    DispatchQueue.main.async {
                        // Stocker les données dans la variable d'état weatherData
                        self.weatherData = decodedData
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            } else {
                print("Failed to convert data to JSON string")
            }
        }
        task.resume()
    }


}

struct WeatherRow: View {
    let logo: String
    let name: String
    let value: String

    var body: some View {
        HStack {
            Image(systemName: logo)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
                .foregroundColor(.blue)
            Text(name)
                .font(.headline)
            Text(value)
                .font(.subheadline)
        }
    }
}

// Mock data structure representing weather data
struct WeatherData: Decodable {
    struct Coord: Decodable {
        let lon: Double
        let lat: Double
    }

    struct Weather: Decodable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }

    struct Main: Decodable {
        let temp: Double
        let feels_like: Double
        let temp_min: Double
        let temp_max: Double
        let pressure: Int
        let humidity: Int
    }

    struct Wind: Decodable {
        let speed: Double
        let deg: Int
    }

    struct Clouds: Decodable {
        let all: Int
    }

    struct Sys: Decodable {
        let type: Int
        let id: Int
        let country: String
        let sunrise: Int
        let sunset: Int
    }

    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
}

// Preview
struct MainPage_Previews: PreviewProvider {
    static var previews: some View {
        MainPage()
    }
}

//#Preview {
//    MainPage()
//}
