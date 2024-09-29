import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var vm: UserStateViewModel
    
    @State private var username: String = ""
    @State private var password: String = ""
    
    @State private var loginSuccessfull: Bool = false
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    
    struct LoginResponse: Codable {
        let message: String
        let userId: Int?
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("MovieFlix")
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(MovieAppColors.red)
            
            /// Username
            HStack {
                Text("Username:")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(MovieAppColors.lightGray)
                    .padding(.top, 16)
                    .padding(.horizontal, 16)
                Spacer()
            }
            
            HStack {
                TextField("Username", text: $username)
                    .border(.secondary)
                    .background(.white)
                    .textFieldStyle(.roundedBorder)
                    .font(.system(size: 32, design: .default))
                    .padding(.horizontal, 16)
            }
            
            /// Password
            HStack {
                Text("Password:")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(MovieAppColors.lightGray)
                    .padding(.top, 16)
                    .padding(.horizontal, 16)
                Spacer()
            }
            
            HStack {
                SecureField("Password", text: $password)
                    .border(.secondary)
                    .background(.white)
                    .textFieldStyle(.roundedBorder)
                    .font(.system(size: 32, design: .default))
                    .padding(.horizontal, 16)
            }
            
            /// Login
            
            Button(action: {
                login()
            }, label: {
                Text("Sign In")
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundColor(MovieAppColors.lightGray)
                    .padding(.top, 30)
                    .padding(.horizontal, 16)
            })
            
            if showError {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(.top, 20)
            }
            
            Spacer()
        }
        .ignoresSafeArea()
        .background(MovieAppColors.black)
    }
    
    /// Login function to handle API call
    func login() {
        guard let url = URL(string: "http://127.0.0.1:5000/login") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["username": username.lowercased(), "password": password.lowercased()]
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else { return }
        
        request.httpBody = httpBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    self.errorMessage = "Network error. Please try again."
                    self.showError = true
                }
                return
            }
            
            // Decode the response using Codable
            do {
                let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                
                if loginResponse.message == "Success", let userId = loginResponse.userId {
                    // Handle successful login, use the userId
                    DispatchQueue.main.async {
                        vm.loginState = .loggedIn(userId: userId)
                        self.loginSuccessfull = true
                    }
                } else {
                    DispatchQueue.main.async {
                        self.errorMessage = loginResponse.message
                        self.showError = true
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to parse response."
                    self.showError = true
                }
            }
        }.resume()
    }
}

#Preview {
    LoginView()
}
