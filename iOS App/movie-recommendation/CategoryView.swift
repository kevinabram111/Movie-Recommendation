//
//  CategoryView.swift
//  movie-recommendation
//
//  Created by Kevin Abram on 22/09/24.
//

import SwiftUI

struct CategoryView: View {
    
    var data: Category
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .stroke(style: .init())
                .foregroundColor(MovieAppColors.lightGray)
            HStack {
                Image(systemName: data.image)
                    .font(.system(size: 20))
                    .foregroundColor(MovieAppColors.lightGray)
                Text(data.text)
                    .font(.system(size: 20))
                    .foregroundColor(MovieAppColors.lightGray)
            }
            .padding(.horizontal)
        }.frame(height: 36)
    }
}

#Preview {
    CategoryView(data: .init(image: "star", text: "featured"))
}
