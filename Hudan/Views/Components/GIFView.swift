import SwiftUI
import WebKit

struct GIFView: UIViewRepresentable {
    private let data: Data

    init(data: Data) {
        self.data = data
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        
        // Create a responsive HTML string
        let htmlString = """
        <html>
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no">
            <style>
                body { margin: 0; background-color: transparent; }
                img { width: 100%; height: auto; }
            </style>
        </head>
        <body>
            <img src="data:image/gif;base64,\(data.base64EncodedString())" />
        </body>
        </html>
        """

        webView.loadHTMLString(htmlString, baseURL: nil)
        
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
