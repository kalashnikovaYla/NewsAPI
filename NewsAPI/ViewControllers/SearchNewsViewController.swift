//
//  SearchNewsViewController.swift
//  NewsAPI
//
//  Created by sss on 29.01.2023.
//

import UIKit
import SafariServices

final class SearchNewsViewController: UIViewController {
    
    private let searchVC = UISearchController(searchResultsController: nil)
    private var tableView: UITableView!
    
    var presenter: SearchNewsPresenterDelegate!
    
    //MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        createTableView()
        addConstraint()
        createSearchBar()
    }
    
    //MARK: - Methods
    
    private func createTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SearchNewsTableViewCell.self, forCellReuseIdentifier: SearchNewsTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }
    
    private func addConstraint() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func createSearchBar() {
        navigationItem.searchController = searchVC
        searchVC.searchBar.delegate = self
    }
}

//MARK: - UISearchBarDelegate

extension SearchNewsViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard var text = searchBar.text, !text.isEmpty else {return}
        if text.contains(" ") {
            text = text.split(separator: " ").joined(separator: "")
        }
        ///View notifies presenter that searchButton pressed
        presenter.searchButtonPressed(text: text)
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension SearchNewsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.atricles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchNewsTableViewCell.identifier, for: indexPath) as! SearchNewsTableViewCell
        
        let article = presenter?.atricles?[indexPath.row]
        cell.newsTitleLabel.text = article?.title ?? ""
        cell.subTitleLabel.text = article?.description ?? ""
        
        presenter.getImageData(urlString: article?.urlToImage ?? "") { data in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    cell.newsImageView.image = image
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let articleUrlString = presenter.atricles?[indexPath.row].url
        guard let articleUrlString = articleUrlString, let url = URL(string: articleUrlString) else {return}
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
        
    }
}

//MARK: - TopNewsViewDelegate

extension SearchNewsViewController: SearchNewsViewDelegate {
    
    func updateView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
