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
    let url: URL

    // Setting up WebView
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    // Loading the Webview
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
