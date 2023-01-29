//
//  NetworkManager.swift
//  NewsAPI
//
//  Created by sss on 29.01.2023.
//


import Foundation

final class NetworkManager {
    
    private var urlString = ""
    
    enum RequestType {
        case categoryNews(category: String)
        case searchNews(news: String)
    }
    
    ///Public function for fetch news 
    public func fetchNews(forRequestType requestType: RequestType, completion: @escaping ([Articles]) -> Void) {
        
        switch requestType {
        case .categoryNews(let category):
            urlString = "https://newsapi.org/v2/top-headlines?country=us&category=\(category)&apiKey=\(apiKey)"
        case .searchNews(let news):
            urlString = "https://newsapi.org/v2/everything?from=2023-01-28&sortBy=popularity&apiKey=\(apiKey)&q=\(news)"
        }
        
        guard let url = URL(string: urlString) else {return}
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {return}
            
            do {
                let resultData = try JSONDecoder().decode(APIResponse.self, from: data)
                completion(resultData.articles)
            } catch let error {
                print(error.localizedDescription)
            }
        }.resume()
    }
}
