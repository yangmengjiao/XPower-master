//
//  RestManager.swift
//  RestManager
//
//  Created by Gabriel Theodoropoulos.
//  Copyright © 2019 Appcoda. All rights reserved.
//

import Foundation

class RestManager {
    
    // MARK: - Properties
    
    var requestHttpHeaders = RestEntity()
    
    var urlQueryParameters = RestEntity()
    
    var httpBodyParameters = RestEntity()
    
    var httpBody: Data?
    
    
    // MARK: - Public Methods
    
    func makeRequest(toURL url: URL,
                     withHttpMethod httpMethod: HttpMethod,
                     completion: @escaping (_ result: Results) -> Void) {
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let targetURL = self?.addURLQueryParameters(toURL: url)
            var httpBody:Data = Data()
            
            if httpMethod != .get
            {
                httpBody = (self?.getHttpBody())!
            }
            guard let request = self?.prepareRequest(withURL: targetURL, httpBody: httpBody, httpMethod: httpMethod) else
            {
                completion(Results(withError: CustomError.failedToCreateRequest))
                return
            }
            
            let sessionConfiguration = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfiguration)
            let task = session.dataTask(with: request) { (data, response, error) in
                completion(Results(withData: data,
                                   response: Response(fromURLResponse: response),
                                   error: error))
            }
            task.resume()
        }
    }
    
    
    
    func getData(fromURL url: URL, completion: @escaping (_ data: Data?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let sessionConfiguration = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfiguration)
            let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
                guard let data = data else { completion(nil); return }
                completion(data)
            })
            task.resume()
        }
    }
    
    func makePostRequest(toURL url:URL, completionHandler: @escaping (_ result: Results , _ success:Bool) -> Void)
    {
        self.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
        self.makeRequest(toURL: url, withHttpMethod: .post) { (result) in
            if((200...499) ~= result.response!.httpStatusCode)
            {
                completionHandler(result,true)
                
            }
            else
            {
                completionHandler(result,false)
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func addURLQueryParameters(toURL url: URL) -> URL {
        if urlQueryParameters.totalItems() > 0 {
            guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return url }
            var queryItems = [URLQueryItem]()
            for (key, value) in urlQueryParameters.allValues() {
                let item = URLQueryItem(name: key, value: (value as! String).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
                
                queryItems.append(item)
            }
            
            urlComponents.queryItems = queryItems
            
            guard let updatedURL = urlComponents.url else { return url }
            return updatedURL
        }
        
        return url
    }
    
    
    
    private func getHttpBody() -> Data? {
        guard let contentTypeData = requestHttpHeaders.value(forKey: "Content-Type") else { return nil }
        let contentType:String = contentTypeData as! String
        
        if contentType.contains("application/json") {
            return try? JSONSerialization.data(withJSONObject: httpBodyParameters.allValues(), options: [.prettyPrinted, .sortedKeys])
        } else if contentType.contains("application/x-www-form-urlencoded") {
            let bodyString = httpBodyParameters.allValues().map { "\($0)=\(String(describing: ($1 as AnyObject).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)))" }.joined(separator: "&")
            return bodyString.data(using: .utf8)
        } else {
            return httpBody
        }
    }
    
    private func prepareRequest(withURL url: URL?, httpBody: Data?, httpMethod: HttpMethod) -> URLRequest? {
        guard let url = url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        
        for (header, value) in requestHttpHeaders.allValues() {
            request.setValue(value as? String, forHTTPHeaderField: header)
        }
        
        request.httpBody = httpBody
        return request
    }
}


// MARK: - RestManager Custom Types

extension RestManager {
    enum HttpMethod: String {
        case get
        case post
        case put
        case patch
        case delete
    }

    
    
    struct RestEntity {
        private var values: [String: Any] = [:]
        
        mutating func add(value: Any, forKey key: String) {
            values[key] = value
        }
        
        func value(forKey key: String) -> Any? {
            return values[key]
        }
        
        func allValues() -> [String: Any] {
            return values
        }
        
        func totalItems() -> Int {
            return values.count
        }
        mutating func addAllBodyParameters(dic:Dictionary<String,Any>)
        {
            for key in dic.keys {
                add(value: dic[key] as Any, forKey: key)
            }
        }
    }
    
    
    
    struct Response {
        var response: URLResponse?
        var httpStatusCode: Int = 0
        var headers = RestEntity()
        
        init(fromURLResponse response: URLResponse?) {
            guard let response = response else { return }
            self.response = response
            httpStatusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
            
            if let headerFields = (response as? HTTPURLResponse)?.allHeaderFields {
                for (key, value) in headerFields {
                    headers.add(value: "\(value)", forKey: "\(key)")
                }
            }
        }
    }
    
    
    
    struct Results {
        var data: Data?
        var response: Response?
        var error: Error?
        
        init(withData data: Data?, response: Response?, error: Error?) {
            self.data = data
            self.response = response
            self.error = error
        }
        
        init(withError error: Error) {
            self.error = error
        }
    }

    
    
    enum CustomError: Error {
        case failedToCreateRequest
    }
}


// MARK: - Custom Error Description
extension RestManager.CustomError: LocalizedError {
    public var localizedDescription: String {
        switch self {
        case .failedToCreateRequest: return NSLocalizedString("Unable to create the URLRequest object", comment: "")
        }
    }
}
