import SwiftUI
import SafariServices

struct NewsArticleRow: View {
    var article: NewsArticle
    @State private var showSafariView = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(article.title)
                    .font(.headline)
                    .foregroundColor(.black)
                    .lineLimit(2)
                Text(article.content.removingHTMLElements())
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(3)
                HStack {
                    Text(article.time.toFormattedDate())
                        .font(.caption)
                        .foregroundColor(.gray)
                    Spacer()
                    Text(article.source)
                        .font(.caption)
                        .padding(4)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(4)
                        .foregroundColor(.black)
                }
            }
        }
        .padding(1)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(4)
        .padding(.horizontal, 1)
        .onTapGesture {
            showSafariView = true
        }
        .sheet(isPresented: $showSafariView) {
            if let url = URL(string: article.link) {
                SafariView(url: url)
            }
        }
    }
}

struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {}
}

extension String {
    func toFormattedDate() -> String {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = formatter.date(from: self) {
            formatter.timeZone = TimeZone.current
            formatter.dateFormat = "E d MMMM, yyyy 'at' HH:mm"
            return formatter.string(from: date)
        }

        formatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
        if let date = formatter.date(from: self) {
            formatter.timeZone = TimeZone.current
            formatter.dateFormat = "E d MMMM, yyyy 'at' HH:mm"
            return formatter.string(from: date)
        }

        formatter.dateFormat = "E, d MMM yyyy HH:mm:ss zzz"
        if let date = formatter.date(from: self) {
            formatter.timeZone = TimeZone.current
            formatter.dateFormat = "E d MMMM, yyyy 'at' HH:mm"
            return formatter.string(from: date)
        }

        return self
    }

    func removingHTMLElements() -> String {
        guard let data = data(using: .utf8) else { return self }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        do {
            let attributedString = try NSAttributedString(data: data, options: options, documentAttributes: nil)
            return attributedString.string
        } catch {
            return self
        }
    }
}

struct NewsArticleRow_Previews: PreviewProvider {
    static var previews: some View {
        NewsArticleRow(article: NewsArticle(
            title: "Sample Title",
            link: "https://example.com",
            source: "BBC",
            time: "Thu, 3 April 2025 22:45:00 +0000",
            content: "<p>Sample content for testing...</p>"
        ))
    }
}
