//
//  SearchNewsPresenter.swift
//  NewsAPI
//
//  Created by sss on 29.01.2023.
//

import Foundation

protocol SearchNewsViewDelegate: AnyObject {
    func updateView()
}

protocol SearchNewsPresenterDelegate: AnyObject {
    var atricles: [Articles]? {get}
    
    init(view: SearchNewsViewDelegate, networkManager: NetworkManager)
    func searchButtonPressed(text: String)
    func getImageData(urlString: String, completion: @escaping(Data?) -> Void)
}


final class SearchNewsPresenter: SearchNewsPresenterDelegate {
    
    weak var view: SearchNewsViewDelegate?
    let networkManager: NetworkManager!
    var atricles: [Articles]?
    
    //MARK: - Init
    
    init(view: SearchNewsViewDelegate, networkManager: NetworkManager) {
        self.view = view
        self.networkManager = networkManager
    }
    
    func searchButtonPressed(text: String) {
        networkManager.fetchNews(forRequestType: .searchNews(news: text)) { [weak self] articles in
            self?.atricles = articles
            
            /// Presenter asks view to update tableVC
            self?.view?.updateView()
        }
    }
    
    func getImageData(urlString: String, completion: @escaping(Data?) -> Void) {
        
        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {return}
            completion(data)
        }.resume()
    }
}
