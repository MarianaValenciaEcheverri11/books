//
//  Home.swift
//  books
//
//  Created by Mariana Valencia Echeverri on 29/01/24.
//

import SwiftUI

protocol HomeViewDelegate {
    func displayBooks(with books: [Book])
}

struct HomeView: View {
    
    struct Constants {
        static let title: String = "Home"
        static let backButtonTitle: String = "Go back"
        static let fontSizeTitle: CGFloat = 20
        static let paddingHorizontal: CGFloat = 25
        static let paddingCell: CGFloat = 3
    }
    
    // MARK: - Private properties -
    
    private var btnBack : some View {
        Button(action: {
        self.presentationMode.wrappedValue.dismiss()
        }) {
            Text(Constants.backButtonTitle)
        }
        .padding(.horizontal, Constants.paddingHorizontal)
    }
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    // MARK: - Internal properties -
    
    @State var books: [Book] = []
    @State var viewModel: HomeViewModel? = nil
    let model: OauthKeyModel
    let sesskey: String
    
    var body: some View {
        VStack(alignment: .leading) {
            title
                
            List(books, id: \.sstamp.self) { book in
                BookCell(book)
                    .listRowBackground(Color.clear)
                    .padding(.all, Constants.paddingCell)
            }
            .listStyle(.plain)
            
            Spacer()
        }
        .onAppear {
            viewModel = HomeViewModel()
            viewModel?.model = model
            viewModel?.sesskey = sesskey
            configureDataList()
        }
        .onAppear(perform: { () })
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundColor(.black)
        .background(.white)
    }
    
    // MARK: - Private properties -
    
    private func configureDataList() {
        viewModel?.view = self
        Task {
            do {
                await viewModel?.viewDidLoad()
            }
        }
    }
    
    private var title: some View {
        HStack {
            btnBack
            Text(Constants.title)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: Constants.fontSizeTitle))
                .padding(.leading, Constants.paddingHorizontal)
        }
    }
    
    init(model: OauthKeyModel, sessKey: String) {
        self.model = model
        self.sesskey = sessKey
    }
}

extension HomeView: HomeViewDelegate {
    func displayBooks(with books: [Book]) {
        self.books = books
    }
}
