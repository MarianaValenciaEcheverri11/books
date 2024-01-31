//
//  LoginButtonStyle.swift
//  books
//
//  Created by Mariana Valencia Echeverri on 29/01/24.
//

import SwiftUI

struct LoginButtonStyle: ButtonStyle {
    
    struct Constants {
        static let cornerRadius: CGFloat = 10
        static let verticalPadding: CGFloat = 16
    }
    
    // MARK: - Internal methods -
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, Constants.verticalPadding)
            .background(Color.green)
            .foregroundStyle(.white)
            .cornerRadius(Constants.cornerRadius)
            .fontWeight(.bold)
    }
}
