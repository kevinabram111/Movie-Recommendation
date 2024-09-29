import SwiftUI

struct ContentView: View {
    
    @State var showProfileView = false
    var userId: Int
    
    @State private var watchedMovies: [Movie] = []
    @State private var recommendedMovies: [Movie] = []  // Store recommended movies
    @State private var errorMessage: String? = nil
    
    struct Movie: Codable, Identifiable {
        var id: Int { movieId }
        let movieId: Int
        let title: String
        let genres: String
        let rating: Double?
        let original_title: String?
        let overview: String?
        let poster_path: String?
        let backdrop_path: String?
    }
    
    var body: some View {
        VStack {
            ScrollView(.vertical) {
                /// Title
                HStack {
                    Text("MovieFlix")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(MovieAppColors.red)
                    Spacer()
                    
                    NavigationLink(destination: ProfileView(), isActive: $showProfileView) {
                        Image(systemName: "person.crop.circle")
                            .font(.system(size: 40))
                            .foregroundColor(MovieAppColors.lightGray)
                    }
                }
                
                /// Scrollable Component
                ScrollView(.horizontal) {
                    LazyHGrid(rows: [GridItem(.flexible())]) {
                        ForEach(0..<categories.count, id: \.self) { index in
                            CategoryView(data: categories[index])
                        }
                    }
                }
                .frame(height: 38)
                .scrollIndicators(.never)
                
                /// Movies you have watched
                HStack {
                    Text("Movies you have watched")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(MovieAppColors.lightGray)
                    Spacer()
                }
                .padding(.vertical)
                
                /// Scrollable Component for watched movies
                ScrollView(.horizontal) {
                    LazyHGrid(rows: [GridItem(.flexible())]) {
                        ForEach(watchedMovies) { movie in
                            MovieView(movie: movie)
                        }
                    }
                }
                .frame(height: 260)
                .scrollIndicators(.never)
                
                /// Recommended Movies
                HStack {
                    Text("Recommended For You")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(MovieAppColors.lightGray)
                    Spacer()
                }
                .padding(.vertical)
                
                /// Scrollable Component for recommended movies
                ScrollView(.horizontal) {
                    LazyHGrid(rows: [GridItem(.flexible())]) {
                        ForEach(recommendedMovies) { movie in
                            MovieView(movie: movie)
                        }
                    }
                }
                .frame(height: 260)
                .scrollIndicators(.never)
            }.scrollIndicators(.never)
        }
        .padding(.horizontal)
        .padding(.top)
        .background(MovieAppColors.black)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle(" ")
        .onFirstAppear {
            fetchWatchedMovies(userId: userId)
            fetchRecommendedMovies(userId: userId)  // Fetch recommendations when the view appears
        }
    }
    
    /// Function to fetch watched movies for the user
    func fetchWatchedMovies(userId: Int) {
        guard let url = URL(string: "http://127.0.0.1:5000/user/\(userId)/movies") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to fetch movies. Please try again."
                }
                return
            }
            
            // Decode the movies response
            do {
                let response = try JSONDecoder().decode(UserMoviesResponse.self, from: data)
                
                // Handle success or failure based on status
                if response.status == 200 {
                    DispatchQueue.main.async {
                        self.watchedMovies = response.movies
                    }
                } else {
                    DispatchQueue.main.async {
                        self.errorMessage = "Error: \(response.message ?? "Unknown error")"
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    print("Error decoding JSON: \(error)")
                    self.errorMessage = "Failed to parse movies. Please try again."
                }
            }
        }.resume()
    }
    
    /// Function to fetch recommended movies for the user
    func fetchRecommendedMovies(userId: Int) {
        guard let url = URL(string: "http://127.0.0.1:5000/user/\(userId)/recommendations") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to fetch recommendations. Please try again."
                }
                return
            }
            
            // Log the raw response to the console (optional)
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON Response: \(jsonString)")
            }
            
            // Decode the recommendations response
            do {
                let response = try JSONDecoder().decode(UserMoviesResponse.self, from: data)
                
                // Handle success or failure based on status
                if response.status == 200 {
                    DispatchQueue.main.async {
                        self.recommendedMovies = response.movies
                    }
                } else {
                    DispatchQueue.main.async {
                        self.errorMessage = "Error: \(response.message ?? "Unknown error")"
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    print("Error decoding JSON: \(error)")
                    self.errorMessage = "Failed to parse recommendations. Please try again."
                }
            }
        }.resume()
    }
    
    /// Struct to decode the user movies and recommendations
    struct UserMoviesResponse: Codable {
        let status: Int
        let userId: Int
        let message: String?
        let movies: [Movie]
    }
}

public struct OnFirstAppearModifier: ViewModifier {

    private let onFirstAppearAction: () -> ()
    @State private var hasAppeared = false
    
    public init(_ onFirstAppearAction: @escaping () -> ()) {
        self.onFirstAppearAction = onFirstAppearAction
    }
    
    public func body(content: Content) -> some View {
        content
            .onAppear {
                guard !hasAppeared else { return }
                hasAppeared = true
                onFirstAppearAction()
            }
    }
}

extension View {
    func onFirstAppear(_ onFirstAppearAction: @escaping () -> () ) -> some View {
        return modifier(OnFirstAppearModifier(onFirstAppearAction))
    }
}
