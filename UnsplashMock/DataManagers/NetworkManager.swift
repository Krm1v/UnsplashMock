//
//  NetworkManager.swift
//  UnsplashMock
//
//  Created by Владислав Баранкевич on 27.06.2022.
//

import Foundation

class NetworkManager {
    
    func fetchRequest(searchWord: String, completion: @escaping (Data?, Error?) -> Void) {
        
        let params = self.askForParams(searchWord: searchWord)
        let url = self.url(params: params)
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = prepareHeader()
        request.httpMethod = "get"
        let task = createDataTask(with: request, completion: completion)
        task.resume()
    }
    
    
    private func prepareHeader() -> [String: String]? {
        
        var headers = [String: String]()
        headers["Authorization"] = "client_id=xgtXHmCm36C9TXhrWeSHOcnKa6MwC6hEW2j2lt2KdM4"
        return headers
    }
    
    private func askForParams(searchWord: String?) -> [String: String] {
        var params = [String: String]()
        params["query"] = searchWord
        params["page"] = String(1)
        params["per_page"] = String(30)
        params["client_id"] = "xgtXHmCm36C9TXhrWeSHOcnKa6MwC6hEW2j2lt2KdM4"
        return params
    }
    
    private func url(params: [String : String]) -> URL {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/search/photos"
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
        return components.url!
    }
    
    private func createDataTask(with request: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
    }
}
