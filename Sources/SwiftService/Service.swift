import Foundation

/// Basic service with get, post and delete
open class Service {
    
    public var decoder: JSONDecoder = JSONDecoder()
    public var encoder: JSONEncoder = JSONEncoder()
    public var scheme: String = "https"
    public var host: String?
    public var authorization: String?
    public var contentType: String? = "application/json"
    
    public var session = URLSession(configuration: .default)
    
    public init() {}
    
    public func request(method: HTTPMethod, components: URLComponents, headers: [HTTPHeader], body: Data?, onComplete: @escaping (Result<Data?, RequestError>) -> Void) {
        guard let url = components.url else {
            onComplete(.failure(.init(message: "Could not create valid URL from components.")))
            return
        }
        
        var request = URLRequest(url: url)
        for header in headers {
            request.add(header: header)
        }
        
        let task = session.dataTask(with: url) { (data, response, error) in
            guard let response = response as? HTTPURLResponse else {
                onComplete(.failure(.init(message: "Did not get an http response")))
                return
            }
            
            if let error = error as NSError? {
                onComplete(.failure(.init(message: "\(response.statusCode): \(error.localizedDescription)")))
                return
            }
            
            onComplete(.success(data))
        }
        task.resume()
    }
        
    public func get(path: String, queryItems: [URLQueryItem]? = nil, onComplete: @escaping (Result<Data?, RequestError>) -> Void) {
        
        var components = self.components(path: path)
        components.queryItems = queryItems
        
        request(method: .get, components: components, headers: defaultHeaders(), body: nil, onComplete: onComplete)
    }

    public func post(path: String, body: Data? = nil, onComplete: @escaping (Result<Data?, RequestError>) -> Void) {

        let components = self.components(path: path)
        
        request(method: .post, components: components, headers: defaultHeaders(), body: body, onComplete: onComplete)
    }

    public func delete(path: String, body: Data? = nil, onComplete: @escaping (Result<Data?, RequestError>) -> Void) {
        
        let components = self.components(path: path)
        
        request(method: .delete, components: components, headers: defaultHeaders(), body: body, onComplete: onComplete)
    }
    
    open func defaultHeaders() -> [HTTPHeader] {
        var headers: [HTTPHeader] = []
        if let contentType = self.contentType {
            headers.append(HTTPHeader(field: .contentType, value: contentType))
        }
        
        if let authorization = self.authorization {
            headers.append(HTTPHeader(field: .authorization, value: authorization))
        }
        return headers
    }
    
    private func components(path: String) -> URLComponents {
        var components = URLComponents()
        components.host = self.host
        components.path = path
        components.scheme = scheme
        return components
    }
}
