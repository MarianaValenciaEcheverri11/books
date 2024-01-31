//
//  Login.swift
//  books
//
//  Created by Mariana Valencia Echeverri on 29/01/24.
//

import SwiftUI

protocol LoginViewDelegate {
    func showErrorAlert(message: String)
    func signIn(with email: String, password: String)
    func showHome(with model: OauthKeyModel, sessKey: String)
}

struct Login: View {
    
    private struct Constants {
        static let email: String = "Email"
        static let password: String = "Password"
        static let buttonTitle: String = "Login"
        static let fontSizeLabels: CGFloat = 20
        static let fontSizeFields: CGFloat = 18
        static let heightFields: CGFloat = 25
        static let horizontalPadding: CGFloat = 20
        static let cornerRadius: CGFloat = 10
    }
    
    // MARK: - Private properties -
    
    private var emailText: some View {
        Text(Constants.email)
            .font(.system(size: Constants.fontSizeLabels))
            .fontWeight(.bold)
    }
    
    private var passwordText: some View {
        Text(Constants.password)
            .font(.system(size: Constants.fontSizeLabels))
            .fontWeight(.bold)
    }
    
    private var emailTextField: some View {
        TextField(String(), text: $email)
            .keyboardType(.emailAddress)
            .textContentType(.emailAddress)
            .background(Color.gray)
            .font(.system(size: Constants.fontSizeFields))
            .fontWeight(.medium)
            .cornerRadius(Constants.cornerRadius)
    }
    
    private var passwordTextField: some View {
        SecureField(String(), text: $password)
            .textContentType(.password)
            .background(Color.gray)
            .frame(height: Constants.heightFields)
            .font(.system(size: Constants.fontSizeFields))
            .fontWeight(.bold)
            .cornerRadius(Constants.cornerRadius)
    }
    
    private var accessButton: some View {
        Button(action: { signIn(with: email, password: password) }) {
            Text(Constants.buttonTitle)
                .frame(maxWidth: .infinity)
        }
        .padding(.all, Constants.horizontalPadding)
        .buttonStyle(LoginButtonStyle())
    }
    
    @State private var email: String = String()
    @State private var password: String = String()
    @State private var canPresentHome: Bool = false
    @State private var canPresentAlert: Bool = false
    @State private var messageAlert: String = ""
    @State private var viewModel: LoginViewModel? = nil
    
    // MARK: - Internal properties -
    
    internal var body: some View {
        VStack(alignment: .leading) {
            emailText
            emailTextField
            passwordText
            passwordTextField
            accessButton
        }
        .padding(.horizontal, Constants.horizontalPadding)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundColor(.black)
        .background(.white)
        .onAppear {
            self.viewModel = LoginViewModel()
            self.viewModel?.view = self
        }
        .fullScreenCover(isPresented: $canPresentHome, content: {
            if let vM = viewModel {
                HomeView(model: vM.oauthKeyModel, sessKey: vM.sesskey)
            }
        })
        .toast(message: messageAlert, isShowing: $canPresentAlert)
    }
}

extension Login: LoginViewDelegate {
    
    func showErrorAlert(message: String) {
        messageAlert = message
        canPresentAlert = true
    }
    
    func showHome(with model: OauthKeyModel, sessKey: String) {
        self.canPresentHome = true
    }
    
    func signIn(with email: String, password: String) {
        Task {
            do {
                await viewModel?.signIn(with: email, password: password)
            }
        }
    }
}
