import Foundation

enum HTTPMethod: String {
    case OPTIONS
    case GET
    case HEAD
    case POST
    case PUT
    case DELETE
    case TRACE
    case CONNECT
}

protocol APIEndpoint {
    var url: URL { get }
    var method: HTTPMethod { get }
    var query: [String: String]? { get }
    var headers: [String: String]? { get }
    associatedtype ResponseType: JSONDecodable
}

extension APIEndpoint {
    var method: HTTPMethod {
        return .GET
    }
    var query: [String: String]? {
        return nil
    }
    var headers: [String: String]? {
        return nil
    }
    var body: [String: Any] {
        return [:]
    }
}

extension APIEndpoint {
    var urlRequest: URLRequest {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = query?.map(URLQueryItem.init)

        var req = URLRequest(url: components?.url ?? url)
        req.httpMethod = method.rawValue
        for (key, value) in headers ?? [:] {
            req.addValue(value, forHTTPHeaderField: key)
        }
        req.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        return req
    }
}

enum APIError: Error {
    case emptyBody
    case unexpectedResponseType
}

enum APIResult<Response> {
    case success(Response)
    case failure(Error)
}

extension APIEndpoint {
    @discardableResult
    func request(_ session: URLSession, callback: @escaping (APIResult<ResponseType>) -> Void) -> URLSessionDataTask {
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            if let e = error {
                callback(.failure(e))
            } else if let data = data {
                do {
                    guard let dic = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                        throw APIError.unexpectedResponseType
                    }
                    let response = try ResponseType(json: JSONObject(json: dic))
                    callback(.success(response))
                } catch {
                    callback(.failure(error))
                }
            } else {
                callback(.failure(APIError.emptyBody))
            }
        }
        task.resume()
        return task
    }
}
