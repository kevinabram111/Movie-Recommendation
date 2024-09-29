//
//  DetailView.swift
//  movie-recommendation
//
//  Created by Kevin Abram on 22/09/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct DetailView: View {
    
    var movie: ContentView.Movie
    let movieImageWidth = UIScreen.main.bounds.width
    let movieImageHeight = UIScreen.main.bounds.width * 2 / 3
    
    var body: some View {
        VStack {
            ScrollView(.vertical) {
                
                if let backdropPath = movie.backdrop_path {
                    // Use the reusable MovieImageView for the backdrop image
                    MovieImageView(imagePath: backdropPath, width: movieImageWidth, height: movieImageHeight)
                } else if let posterPath = movie.poster_path {
                    // Use the reusable MovieImageView for the poster image
                    MovieImageView(imagePath: posterPath, width: movieImageWidth, height: movieImageHeight)
                } else {
                    // Fallback to placeholder
                    Rectangle()
                        .frame(width: movieImageWidth, height: movieImageHeight)
                        .foregroundColor(MovieAppColors.slate)
                }
                
                VStack {
                    HStack {
                        Text(movie.title)
                            .font(.system(size: 32, weight: .semibold))
                            .foregroundColor(.white)
                        Spacer()
                    }
                    Spacer()
                    HStack {
                        Text(movie.overview ?? "")
                            .font(.system(size: 20, weight: .regular))
                            .foregroundColor(MovieAppColors.lightGray)
                        Spacer()
                    }
                }
                .padding()
            }
        }
        .ignoresSafeArea()
        .background(MovieAppColors.black)
    }
}

/// Reusable component to handle the image loading
struct MovieImageView: View {
    let imagePath: String
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(imagePath)")
        
        WebImage(url: imageUrl) { image in
            image
                .resizable()
                .scaledToFill()
                .frame(width: width, height: height)
                .clipped()
        } placeholder: {
            Rectangle()
                .foregroundColor(MovieAppColors.lightGray)
                .frame(width: width, height: height)
        }
    }
}
