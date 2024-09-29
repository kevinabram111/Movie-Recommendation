//
//  MovieView.swift
//  movie-recommendation
//
//  Created by Kevin Abram on 22/09/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct MovieView: View {
    
    var movie: ContentView.Movie
    
    var body: some View {
        NavigationLink(destination: DetailView(movie: movie)) {
            VStack {
                if let posterPath = movie.poster_path {
                    // Create the full URL for the poster image
                    let posterURL = URL(string: "https://image.tmdb.org/t/p/w200\(posterPath)")
                    
                    WebImage(url: posterURL) { image in
                        image
                            .resizable()
                            .scaledToFill()  // Scale to fill the frame
                            .frame(width: 150, height: 200)  // Set the exact frame
                            .clipped()  // Clip the overflowing content
                    } placeholder: {
                        // Placeholder while the image is loading
                        Rectangle()
                            .foregroundColor(MovieAppColors.lightGray)
                            .frame(width: 150, height: 200)
                    }
                } else {
                    // Show a placeholder if no poster_path is available
                    Rectangle()
                        .frame(width: 150, height: 200)
                        .foregroundColor(MovieAppColors.lightGray)
                }
                
                HStack {
                    Text(movie.title)
                        .font(.system(size: 16, weight: .semibold))
                        .multilineTextAlignment(.leading)
                        .foregroundColor(MovieAppColors.lightGray)
                    Spacer()
                }
                Spacer()
            }
            .frame(width: 150, height: 260)
        }
    }
}
