//
//  BookCell.swift
//  books
//
//  Created by Mariana Valencia Echeverri on 29/01/24.
//

import SwiftUI

struct BookCell: View {
    
    struct Constants {
        static let sizeFontName: CGFloat = 20
        static let sizeImage: CGFloat = 80
        static let paddingTopImage: CGFloat = 10
        static let defaultImageName: String = "photo"
        static let empty: String = ""
        static let stringToDelete: String = "/dev/"
        static let baseURLImage: String = "https://timetonic.com/live/"
    }
    
    // MARK: - Internal properties -
    
    var book: Book
    @State var isPresentedDetail: Bool = false
    
    var body: some View {
        HStack {
            Text(book.ownerPrefs.title )
                .font(.system(size: Constants.sizeFontName, weight: .bold))
            Spacer()
            AsyncImage(url: URL(string: Constants.baseURLImage +
                                book.ownerPrefs.oCoverImg.replacingOccurrences(of: Constants.stringToDelete,
                                                                               with: Constants.empty))) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: Constants.sizeImage, maxHeight: Constants.sizeImage)
                        .padding(.top, -Constants.paddingTopImage)
                case .failure:
                    Image(systemName: Constants.defaultImageName)
                @unknown default:
                    EmptyView()
                }
            }
        }
        .onTapGesture {
            isPresentedDetail.toggle()
        }
        .fullScreenCover(isPresented: $isPresentedDetail, content: {
            DetailBook(book)
        })
    }
    
    // MARK: - Lifecycle -
    
    init(_ book: Book) {
        self.book = book
    }
}
