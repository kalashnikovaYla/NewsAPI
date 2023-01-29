//
//  TopNewsPresenter.swift
//  NewsAPI
//
//  Created by sss on 29.01.2023.
//

import Foundation

protocol TopNewsViewDelegate: AnyObject {
    func updateView()
}

protocol TopNewsPresenterDelegate: AnyObject {
    
    var atricles: [Articles]? {get}
    
    init(view: TopNewsViewDelegate, networkManager: NetworkManager)
    func getImageData(urlString: String, completion: @escaping(Data?) -> Void)
    func pickerDidSelected(category: Category)
}

final class TopNewsPresenter: TopNewsPresenterDelegate {
    
    weak var view: TopNewsViewDelegate?
    let networkManager: NetworkManager!
    
    var atricles: [Articles]?
    
    //MARK: - Init
    
    init(view: TopNewsViewDelegate, networkManager: NetworkManager) {
        self.view = view
        self.networkManager = networkManager
        
        networkManager.fetchNews(
            forRequestType: .categoryNews(category: Category.business.rawValue)) { [weak self] articles in
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
    
    func pickerDidSelected(category: Category) {
        networkManager.fetchNews(
            forRequestType: .categoryNews(category: category.rawValue)) { [weak self] articles in
                self?.atricles = articles
                /// Presenter asks view to update tableVC
                self?.view?.updateView()
            }
    }
}
