//
//  DetailBook.swift
//  books
//
//  Created by Mariana Valencia Echeverri on 29/01/24.
//

import SwiftUI

protocol DetailBookViewDelegate {
    func viewBack()
}

struct DetailBook: View {
    
    struct Constants {
        static let fontSizeName: CGFloat = 18
        static let horizontalPadding: CGFloat = 20
        static let iconLeftName: String = "chevron.left"
        static let baseURLImage: String = "https://timetonic.com/live/"
    }
    
    // MARK: - Internal properties -
    
    var book: Book
    @State var viewModel: DetailBookViewModel? = nil
    
    var body: some View {
        NavigationView {
            VStack {
                AsyncImage(url: URL(string: Constants.baseURLImage +
                                               book.ownerPrefs.oCoverImg.replacingOccurrences(of: "/dev/", with: "")))
                Text(book.description ?? String())
                    .font(.system(size: Constants.fontSizeName))
                    .fontWeight(.bold)
                    .padding(.horizontal, Constants.horizontalPadding)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .foregroundColor(.black)
            .background(.white)
            .navigationBarItems(leading: Button(action: {
                viewModel?.viewBack()
            }) {
                Image(systemName: Constants.iconLeftName)
                    .foregroundColor(.black)
            })
        }.onAppear {
            viewModel = DetailBookViewModel()
            viewModel?.view = self
        }
    }
    
    // MARK: - Private properties -
    
    @Environment(\.presentationMode) private var presentation
    
    // MARK: - Lifecycle -
    
    init(_ book: Book) {
        self.book = book
    }
}

extension DetailBook: DetailBookViewDelegate {
    func viewBack() {
        self.presentation.wrappedValue.dismiss()
    }
}
