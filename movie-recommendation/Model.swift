//
//  Model.swift
//  movie-recommendation
//
//  Created by Kevin Abram on 22/09/24.
//

import SwiftUI

struct Category {
    var image: String
    var text: String
}

var categories: [Category] = [
    .init(image: "star", text: "featured"),
    .init(image: "popcorn", text: "newly added"),
    .init(image: "movieclapper", text: "trending"),
    .init(image: "trophy", text: "oscar winner")
]

struct Movie {
    var movieImage: String
    var movieName: String
}

var watchedMovies: [Movie] = [
    .init(movieImage: "", movieName: ""),
    .init(movieImage: "", movieName: ""),
    .init(movieImage: "", movieName: ""),
    .init(movieImage: "", movieName: "")
]

var recommendedMovies: [Movie] = [
    .init(movieImage: "", movieName: ""),
    .init(movieImage: "", movieName: ""),
    .init(movieImage: "", movieName: ""),
    .init(movieImage: "", movieName: "")
]
