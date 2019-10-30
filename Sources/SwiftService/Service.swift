import Foundation

/// Basic service with get, post and delete
open class Service {

    open var decoder: JSONDecoder = JSONDecoder()
    open var encoder: JSONEncoder = JSONEncoder()

    open var root: URL?
    open var token: String?

    public func get(urlString: String, completionBlock: @escaping (Data) -> Void) {
        // Set up the URL request
        guard let url = urlWithRootTo(urlString) else {
            print("Error: cannot create URL")
            return
        }
        var urlRequest = URLRequest(url: url)
        if let token = token {
            let requestString = "Bearer \(token)"
            urlRequest.setValue(requestString, forHTTPHeaderField: "Authorization")
        }

        // set up the session
        let session = URLSession(configuration: .default)

        // make the request
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                print("error calling GET")
                print(error!)
                return
            }
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }

            completionBlock(responseData);

        }
        task.resume()
    }

    public func post(urlString: String, body: Data? = nil, urlRequestSetup: ((inout URLRequest) -> Void)? = nil, completionBlock: @escaping (Data) -> Void) {
        // Set up the URL request
        guard let url = urlWithRootTo(urlString) else {
            print("Error: cannot create URL")
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        if let body = body {
            urlRequest.httpBody = body
        }
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = token {
            let requestString = "Bearer \(token)"
            urlRequest.setValue(requestString, forHTTPHeaderField: "Authorization")
        }

        if let requestSetup = urlRequestSetup {
            requestSetup(&urlRequest)
        }
        // set up the session
        let session = URLSession(configuration: .default)

        // make the request
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                print("error calling POST")
                print(error!)
                return
            }
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }

            completionBlock(responseData);

        }
        task.resume()
    }

    public func delete(urlString: String, body: Data? = nil, urlRequestSetup: ((inout URLRequest) -> Void)? = nil, completionBlock: @escaping (Data) -> Void) {
        // Set up the URL request
        guard let url = urlWithRootTo(urlString) else {
            print("Error: cannot create URL")
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        if let body = body {
            urlRequest.httpBody = body
        }
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = token {
            let requestString = "Bearer \(token)"
            urlRequest.setValue(requestString, forHTTPHeaderField: "Authorization")
        }

        if let requestSetup = urlRequestSetup {
            requestSetup(&urlRequest)
        }
        // set up the session
        let session = URLSession(configuration: .default)

        // make the request
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                print("error calling DELETE")
                print(error!)
                return
            }
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }

            completionBlock(responseData);

        }
        task.resume()
    }

    public func errorFromData(_ data: Data) -> ErrorResponse? {
        return try? decoder.decode(ErrorResponse.self, from: data)
    }

    private func urlWithRootTo(_ urlString: String) -> URL? {
        return root?.appendingPathComponent(urlString) ?? URL(string: urlString)
    }

}
