//
//  NetworkDataFetcher.swift
//  UnsplashMock
//
//  Created by Владислав Баранкевич on 27.06.2022.
//

import Foundation

class NetworkDataFetcher {
    
    private var networkManager = NetworkManager()
    
    func fetchImages(searchWord: String,
                     completion: @escaping (PhotoModel?) -> ()) {
        
        networkManager.fetchRequest(searchWord: searchWord) { data, error in
            if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
                completion(nil)
            }
            let decoded = self.decodeJSON(type: PhotoModel.self, from: data)
            completion(decoded)
        }
    }
    
    func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        
        let decoder = JSONDecoder()
        guard let data = from else { return nil }
        do {
            let objects = try decoder.decode(type.self, from: data)
            return objects
        } catch let jsonError {
            print("Failed to decode: \(jsonError)")
            return nil
        }
    }
}
