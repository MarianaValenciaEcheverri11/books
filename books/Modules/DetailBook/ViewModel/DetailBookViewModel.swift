//
//  DetailBookViewModel.swift
//  books
//
//  Created by Mariana Valencia Echeverri on 29/01/24.
//

import Foundation

protocol DetailBookViewModelProtocol {
    func viewBack()
}

class DetailBookViewModel: DetailBookViewModelProtocol {
    
    // MARK: - Internal properties -
    
    var view: DetailBook?
    
    // MARK: - Internal methods -

    func viewBack() {
        self.view?.viewBack()
    }
}
