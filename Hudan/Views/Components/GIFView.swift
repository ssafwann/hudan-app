import SwiftUI
import WebKit

struct GIFView: UIViewRepresentable {
    private let name: String

    init(_ name: String) {
        self.name = name
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        
        // Find the URL of the GIF in your app's bundle
        guard let url = Bundle.main.url(forResource: name, withExtension: "gif") else {
            print("Error: GIF not found - \(name).gif")
            return webView
        }
        
        // Load the GIF data and display it in the web view
        do {
            let data = try Data(contentsOf: url)
            webView.load(
                data,
                mimeType: "image/gif",
                characterEncodingName: "UTF-8",
                baseURL: url.deletingLastPathComponent()
            )
            // Make the background of the web view transparent
            webView.isOpaque = false
            webView.backgroundColor = .clear
            webView.scrollView.isScrollEnabled = false
        } catch {
            print("Error loading GIF data: \(error)")
        }
        
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // No need to update the view for a static GIF
    }
}
