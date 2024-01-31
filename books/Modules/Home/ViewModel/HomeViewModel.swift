//
//  HomeViewModel.swift
//  books
//
//  Created by Mariana Valencia Echeverri on 29/01/24.
//

import Foundation

protocol HomeViewModelProtocol {
    func viewDidLoad() async
}

class HomeViewModel: HomeViewModelProtocol {
    
    // MARK: - Internal properties -
    
    var view: HomeViewDelegate?
    var services = Services()
    var model: OauthKeyModel?
    var sesskey: String?
    
    // MARK: - Internal methods -

    func viewDidLoad() async {
        guard let oauthKeyModel = model, let sessionKey = sesskey else { return }
        await getBooks(with: oauthKeyModel, sesskey: sessionKey)
    }
}

extension HomeViewModel {
    
    func getBooks(with model: OauthKeyModel, sesskey: String) async {
        do {
            let books = try await services.getBooksAsync(with: model, sesskey: sesskey)
            DispatchQueue.main.async {
                self.view?.displayBooks(with: books.allBooks.books)
            }
        } catch {
            print(error)
        }
    }
}
