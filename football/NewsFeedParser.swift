import Foundation
import FeedKit

class NewsFeedParser: ObservableObject {
    @Published var articles = [NewsArticle]()
    
    private let feedURLs = [
        "https://feeds.bbci.co.uk/sport/football/rss.xml",
        "https://rss.app/feeds/Hn3WBt7RY5AFQ0rk.xml",
        "https://www.theguardian.com/football/rss"
    ]
    
    init() {
        fetchFeeds()
    }
    
    func fetchFeeds() {
        var fetchedArticles = [NewsArticle]()
        
        let group = DispatchGroup()
        
        for url in feedURLs {
            if let feedURL = URL(string: url) {
                group.enter()
                let parser = FeedParser(URL: feedURL)
                parser.parseAsync { (result) in
                    switch result {
                    case .success(let feed):
                        if let items = feed.rssFeed?.items {
                            let newArticles = items.map { item in
                                NewsArticle(
                                    title: item.title ?? "No Title",
                                    link: item.link ?? "",
                                    source: self.getSource(from: url),
                                    time: item.pubDate?.description ?? "2025-04-03T16:16:30Z", // Placeholder value for demo
                                    content: item.description ?? "No content available."
                                )
                            }
                            fetchedArticles.append(contentsOf: newArticles)
                        }
                    case .failure(let error):
                        print("Error parsing feed: \(error)")
                    }
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            self.articles = fetchedArticles.sorted { $0.time > $1.time }
        }
    }

    private func getSource(from url: String) -> String {
        if url.contains("bbc.co.uk") {
            return "BBC"
        } else if url.contains("theguardian.com") {
            return "Guardian"
        } else {
            return "Sky Sports"
        }
    }
}
