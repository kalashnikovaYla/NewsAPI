//
//  TopNewsTableViewCell.swift
//  NewsAPI
//
//  Created by sss on 29.01.2023.
//

import UIKit

class TopNewsTableViewCell: UITableViewCell {
    
    static let identifier = "TopNewsTableViewCell"
    
    let newsTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .light)
        return label
    }()
    
    let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(newsImageView)
        contentView.addSubview(newsTitleLabel)
        contentView.addSubview(subTitleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        newsTitleLabel.frame = CGRect(x: 5, y: 0, width: contentView.frame.width - 170, height: 70)
        subTitleLabel.frame = CGRect(x: 5, y: 70, width: contentView.frame.width - 170, height: contentView.frame.height / 2)
        newsImageView.frame = CGRect(x: contentView.frame.width - 150, y: 5, width: 140, height: 140)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newsTitleLabel.text = nil
        subTitleLabel.text = nil
        newsImageView.image = nil
    }
}
