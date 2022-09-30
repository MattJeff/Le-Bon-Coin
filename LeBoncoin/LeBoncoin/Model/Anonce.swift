//
//  Anonce.swift
//  autolayout
//
//  Created by Mathis Higuinen on 28/09/2022.
//


import Foundation

// MARK: - AnonceElement
struct AnonceElement: Identifiable,Codable{
    
    let id, categoryID: Int
    let title, anonceDescription: String?
    let price: Int?
    let imagesURL: ImagesURL
    let creationDate: Date?
    let isUrgent: Bool?
    let siret: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case categoryID = "category_id"
        case title = "title"
        case anonceDescription = "description"
        case price = "price"
        case imagesURL = "images_url"
        case creationDate 
        case isUrgent = "is_urgent"
        case siret
    }
}

// MARK: - ImagesURL
struct ImagesURL: Codable {
    let small, thumb: String?
}
