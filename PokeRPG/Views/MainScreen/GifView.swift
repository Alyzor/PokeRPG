//
//  GifView.swift
//  PokeRPG
//
//  Created by Alyzor on 13/07/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct DynamicImage: View {
    @State var link:URL? = URL(string: "")
    var body: some View {
        WebImage(url:lnk)
    }
}

struct DynamicImage_Previews: PreviewProvider {
    static var previews: some View {
        DynamicImage()
    }
}
