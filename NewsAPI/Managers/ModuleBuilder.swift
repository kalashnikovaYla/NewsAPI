//
//  ModuleBuilder.swift
//  NewsAPI
//
//  Created by sss on 29.01.2023.
//

import UIKit

protocol ModuleBuilderProtocol {
    static func createTopNewVC() -> UIViewController
    static func createSearchNewsVC() -> UIViewController
}

class ModuleBuilder: ModuleBuilderProtocol {
    
    static func createTopNewVC() -> UIViewController {
        let netwokManager = NetworkManager()
        let view = TopNewsViewController()
        let presenter = TopNewsPresenter(view: view, networkManager: netwokManager)
        view.presenter = presenter
        return view
    }
    
    static func createSearchNewsVC() -> UIViewController {
        let netwokManager = NetworkManager()
        let view = SearchNewsViewController()
        let presenter = SearchNewsPresenter(view: view, networkManager: netwokManager)
        view.presenter = presenter
        return view
    }
    
}
