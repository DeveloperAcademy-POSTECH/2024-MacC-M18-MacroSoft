//
//  CircularProgressPhoto.swift
//  Modak
//
//  Created by kimjihee on 10/9/24.
//

import SwiftUI

struct CircularProgressPhoto: View {
    var image: UIImage?

    var body: some View {
        if let image = image {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 213, height: 213)
                .clipShape(Circle())
        } else {
            Image("progress_defaultImage")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 213, height: 213)
                .clipShape(Circle())
        }
    }
}

#Preview {
    CircularProgressPhoto()
}
