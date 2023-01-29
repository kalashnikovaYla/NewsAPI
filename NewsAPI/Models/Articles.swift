//
//  Article.swift
//  NewsAPI
//
//  Created by sss on 29.01.2023.
//

import Foundation

struct Articles: Codable {
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
}

struct Source: Codable {
    let name: String
}
