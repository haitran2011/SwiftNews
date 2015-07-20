protocol ArticleRepository {
    func saveArticle(article: Article)
    func doesArticleExist(article: Article) -> Bool
}
