//
//  ImageLoader.swift
//  NewsAPI
//
//  Created by sss on 19.02.2023.
//

import Foundation

final class ImageLoader {
    
    static let shared = ImageLoader()
    private var imageDataCache = NSCache<NSString, NSData>()
    
    
    private init() {}
    
    func downloadImage(_ url: URL, completion: @escaping(Data?) -> Void) {
        let key = url.absoluteString as NSString
        
        if let data = imageDataCache.object(forKey: key) {
            completion(data as Data )
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                print(error ?? URLError(.badServerResponse))
                return
            }
            let key = url.absoluteString as NSString
            let value = data as NSData
            self?.imageDataCache.setObject(value, forKey: key)
            completion(data)
        }
        task.resume()
    }
}
