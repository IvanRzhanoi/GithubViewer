//
//  WebView.swift
//  GithubViewer
//
//  Created by Ivan Rzhanoi on 8.1.2024.
//


import SwiftUI
import WebKit


// Basic WebView to show repos
struct WebView: UIViewRepresentable {
    // 1
    let url: URL

    
    // 2
    func makeUIView(context: Context) -> WKWebView {

        return WKWebView()
    }
    
    // 3
    func updateUIView(_ webView: WKWebView, context: Context) {

        let request = URLRequest(url: url)
        webView.load(request)
    }
}
