import Foundation

struct NewsArticle: Identifiable {
    var id = UUID()
    var title: String
    var link: String
    var source: String
    var time: String
    var content: String
//    var description: String
}
