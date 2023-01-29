//
//  TopNewsViewController.swift
//  NewsAPI
//
//  Created by sss on 29.01.2023.
//

import UIKit
import SafariServices

final class TopNewsViewController: UIViewController {

    private var tableView: UITableView!
    private var textField: UITextField!
    
    var presenter: TopNewsPresenterDelegate!
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        createTableView()
        createTextField()
        addConstraint()
    }
    
    //MARK: - Methods
    
    private func createTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TopNewsTableViewCell.self, forCellReuseIdentifier: TopNewsTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }
    
    private func createTextField() {
        textField = UITextField()
        textField.backgroundColor = .tertiarySystemBackground
        textField.layer.cornerRadius = 3
        textField.placeholder = "Chose category"
        textField.textAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)
        
        ///Input view
        let pickerView = UIPickerView()
        pickerView.sizeToFit()
        textField.inputView = pickerView
        pickerView.delegate = self
        pickerView.dataSource = self
        
        ///Input accessory view
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        textField.inputAccessoryView = toolBar
        let dissmissPickerButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dissmissPicker))
        toolBar.setItems([dissmissPickerButton], animated: true)
    }
    
    @objc func dissmissPicker() {
        view.endEditing(true)
    }
    
    private func addConstraint() {
        NSLayoutConstraint.activate([
            
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            textField.heightAnchor.constraint(equalToConstant: 35),
            
            tableView.topAnchor.constraint(equalTo: textField.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension TopNewsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.atricles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TopNewsTableViewCell.identifier, for: indexPath) as! TopNewsTableViewCell
        
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

//MARK: - UIPickerViewDelegate, UIPickerViewDataSource

extension TopNewsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Category.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Category.allCases[row].rawValue.uppercased()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let category = Category.allCases[row]
        textField.text = category.rawValue.uppercased()
        presenter.pickerDidSelected(category: category)
    }
}


//MARK: - TopNewsViewDelegate

extension TopNewsViewController: TopNewsViewDelegate {
    
    func updateView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
