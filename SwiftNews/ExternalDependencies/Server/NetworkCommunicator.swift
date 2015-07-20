import Foundation

let NetworkCommunicatorErrorDomain = "NetworkCommunicatorErrorDomain"

class NetworkCommunicator {
    private var completionHandler: ((NSData?, NSError?) -> Void)!
    private var httpResponse: NSHTTPURLResponse?
    private var downloadedData: NSData?
    
    func performRequest(request: NSURLRequest, completionHandler: (NSData?, NSError?) -> Void) {
        self.completionHandler = completionHandler
        let session = NSURLSession.sharedSession()
        
        let dataTrask = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if error != nil {
                completionHandler(nil, error)
            }
            else {
                self.downloadedData = data
                self.httpResponse = response as? NSHTTPURLResponse
                self.evaluateResponse()
            }
        }
    }
    
    private func evaluateResponse() {
        if isSuccessfulResponse() {
            completionHandler(downloadedData, nil)
        }
        else {
            let error = buildErrorWithHttpStatusCode()
            completionHandler(nil, error)
        }
    }
    
    private func buildErrorWithHttpStatusCode() -> NSError {
        let errorMessage = "Server returned non-200 status code."
        let userInfo = [NSLocalizedDescriptionKey : errorMessage]
        
        return NSError(domain: NetworkCommunicatorErrorDomain,
            code: httpResponse!.statusCode,
            userInfo: userInfo)
    }
    
    private func isSuccessfulResponse() -> Bool {
        let regExp = NSRegularExpression(pattern: "2[0-9][0-9]", options: nil, error: nil)
        let statusString = String(httpResponse!.statusCode)
        
        if let firstMatch = regExp?.firstMatchInString(statusString,
            options: nil, range:
            NSRange(location: 0, length: count(statusString)))
        {
            return true
        }
        
        return false
    }
}
