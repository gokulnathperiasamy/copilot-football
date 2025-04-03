import SwiftUI

struct NewsArticleDetailView: View {
    var article: NewsArticle
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(article.title)
                .font(.largeTitle)
                .padding(.bottom, 4)
            
            Text(article.time.toFormattedDate())
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Text(article.content)
                .font(.body)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Article Details")
    }
}

struct NewsArticleDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NewsArticleDetailView(article: NewsArticle(
            title: "Sample Title",
            link: "https://example.com",
            source: "BBC",
            time: "2025-04-03T16:16:30Z",
            content: "Sample content for testing..."
//            description: "StringSample content for testing..."
        ))
    }
}
