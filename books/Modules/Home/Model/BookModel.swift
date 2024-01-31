//
//  BookModel.swift
//  books
//
//  Created by Mariana Valencia Echeverri on 29/01/24.
//

import Foundation

struct Library: Codable {
    let status: String
    let allBooks: AllBooks
}

struct AllBooks: Codable {
    let nbBooks: Int
    let books: [Book]
}

struct Book: Codable {
    let sstamp: Int
    let description: String?
    let ownerPrefs: OwnerPrefs
}

struct OwnerPrefs: Codable {
    let oCoverImg: String
    let title: String
}
