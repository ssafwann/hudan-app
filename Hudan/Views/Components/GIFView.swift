import SwiftUI
import WebKit

struct GIFView: UIViewRepresentable {
    private let data: Data

    init(data: Data) {
        self.data = data
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        
        webView.load(
            data,
            mimeType: "image/gif",
            characterEncodingName: "UTF-8",
            baseURL: Bundle.main.resourceURL!
        )
        // Make the background of the web view transparent
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.isScrollEnabled = false
        
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // No need to update the view for a static GIF
    }
}
