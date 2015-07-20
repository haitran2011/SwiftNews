News
====

This app allows you to view news downloaded from a remote RSS feed server. Currently, it supports [Google News](https://news.google.com/) and [Apple Hot News](http://www.apple.com/hotnews/). It can easily be extended to add support for other news sources as well. Here is what you need to provide to integrate with a different news source:

* A class that knows how to generate an appropriate [URL request](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSURLRequest_Class/). This class needs to implement the `ArticleUrlRequest` protocol.

* A class that knows how to translate an RSS entry into a `Article` domain object. This class should be a subclass of `AbstractArticleBuilder`. The translation between an RSS entry and a domain object can be performed by overriding the `createArticleFromRssEntry:` method.

```swift
func createArticleFromRssEntry(rssEntry: RssEntry) -> Article {
	// Translation code goes here
}

```

## Displaying Apple Hot News

By default the app displays the [RSS news feed](http://news.google.com/?output=rss) from Google. To turn it into an [Apple Hot News](https://www.apple.com/main/rss/hotnews/hotnews.rss) feed loader all you need to do is inject Apple News specific objects in `ObjectConfigurator` class as shown below.

```swift
class ObjectConfigurator {
    func articleApiClient() -> ArticleApiClient {
        return ArticleApiClient(articleUrlRequest: AppleNewsUrlRequest(),
            networkCommunicator: NetworkCommunicator(),
            articleBuilder: articleBuilder())
    }
    
    func articleBuilder() -> AbstractArticleBuilder {
        return AppleNewsArticleBuilder(rssEntryBuilder: RssEntryBuilder())
    }
}
```

> Remember to uninstall the app before making the aforementioned changes.

## Building

The app relies on a number of open-source libraries. All these dependencies are acquired through [Cocoapods](https://cocoapods.org/). All pods are locked into a specific version to make sure that the app continues to work no matter which machine it gets built from. Since all pods are distributed along with the project, there is no need to run `pod install` from the command line.

## Testing

The test suite contains unit and integration tests. Both tests can be run together by either selecting _Product_ -> _Test_ from the Xcode menu or using the keyboard shortcut _⌘U_. Although the integration tests for `ArticleApiClient` use the [OHHTTPStubs](https://github.com/AliSoftware/OHHTTPStubs) library to stub all outgoing HTTP requests, this doesn't affect the application target. The `OHHTTPStubs` library is linked only to the test target in the `Podfile` as shown below.

```ruby
target :SwiftNewsTests, :exclusive => true do
    pod 'OHHTTPStubs'
end
```

## Architecture

The architecture of this app is heavily inspired by the [Clean Architecture](http://goo.gl/1EgMwV). This architecture encourages a good separation of concerns by creating explicit boundaries around the application logic. The following diagram shows how various components that make downloading an RSS feed from a remote server and displaying it to the user possible fit into an overall structure defined by the Clean Architecture.

![](https://cloud.githubusercontent.com/assets/115379/8519073/ce78dd4c-239d-11e5-8cf4-ee8c65e66da0.png)

It is worth noting that the application logic contained in the use case and entity objects are encapsulated from all external dependencies including the user interface (UI). The following protocols play a vital role in hiding this outside detail from the use case:

* `FetchArticlesUseCaseInput`
* `FetchArticlesUseCaseOutput`
* `ArticleService`
* `ArticleRepository`

> This approach of making both the high level and low level modules depend on abstractions is further explored in [this paper](http://www.objectmentor.com/resources/articles/dip.pdf).

One of the biggest benefits of this approach is that the application logic remains unaffected if we decide to make changes to any of the external dependencies, for example using a different RSS feed source or database technology.
