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
        (image != nil ? Image(uiImage: image!) : Image("progress_defaultImage"))
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: UIScreen.main.bounds.width / 1.84, height: UIScreen.main.bounds.width / 1.84)
            .clipShape(Circle())
    }
}

#Preview {
    CircularProgressPhoto()
}
