//
//  Toast.swift
//  books
//
//  Created by Mariana Valencia Echeverri on 31/01/24.
//

import SwiftUI

struct Toast: ViewModifier {
    
    struct Constants {
        static let timeInterval: TimeInterval = 2
        static let paddingText: CGFloat = 8
        static let horizontalPadding: CGFloat = 16
        static let fontSizeTitle: CGFloat = 15
        static let animationTime: CGFloat = 0.4
    }
    
    // MARK: - Private properties -
    
    private var toastView: some View {
        VStack {
            Spacer()
            if isShowing {
                Group {
                    Text(message)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .font(.system(size: Constants.fontSizeTitle))
                        .fontWeight(.bold)
                        .padding(Constants.paddingText)
                }
                .background(.red)
                .cornerRadius(Constants.paddingText)
                .onTapGesture {
                    isShowing = false
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + Constants.timeInterval) {
                        isShowing = false
                    }
                }
            }
        }
        .padding(.horizontal, Constants.horizontalPadding)
        .padding(.bottom, Constants.horizontalPadding)
        .animation(.linear(duration: Constants.animationTime), value: isShowing)
        .transition(.opacity)
    }

    // MARK: - Internal properties -
    
    let message: String
    @Binding var isShowing: Bool

    // MARK: - Internal methods -
    
    func body(content: Content) -> some View {
        ZStack {
            content
            toastView
        }
    }
}

extension View {
    func toast(
        message: String,
        isShowing: Binding<Bool>
    ) -> some View {
        self.modifier(Toast(message: message, isShowing: isShowing))
    }
}
