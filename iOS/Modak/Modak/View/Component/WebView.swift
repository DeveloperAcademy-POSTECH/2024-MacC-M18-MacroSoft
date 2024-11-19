//
//  SwiftUIView.swift
//  Modak
//
//  Created by kimjihee on 11/15/24.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}

#Preview {
    WebView(url: URL(string: "https://sites.google.com/view/modak-privacy/%ED%99%88")!)
        .edgesIgnoringSafeArea(.bottom)
}
