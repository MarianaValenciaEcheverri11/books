//
//  LoginViewModel.swift
//  books
//
//  Created by Mariana Valencia Echeverri on 29/01/24.
//

import Foundation

protocol LoginViewModelProtocol {
    func signIn(with email: String, password: String) async
}

class LoginViewModel: LoginViewModelProtocol {
    
    // MARK: - Internal properties -
    
    var view: LoginViewDelegate?
    var services = Services()
    var oauthKeyModel: OauthKeyModel!
    var sesskey: String!
    
    // MARK: - Internal methods -

    func signIn(with email: String, password: String) async {
        do {
            let registerAppModel = try await services.registerAppAsync()
            self.oauthKeyModel = try await services.createOauthkeyAsync(
                with: email,
                password: password,
                appKey: registerAppModel.appkey
            )
            let sessKeyModel = try await services.createSesskeyAsync(with: oauthKeyModel)
            self.sesskey = sessKeyModel.sesskey
            DispatchQueue.main.async {
                if sessKeyModel.status == "ok" {
                    self.view?.showHome(with: self.oauthKeyModel, sessKey: sessKeyModel.sesskey)
                }
            }
        } catch {
            view?.showErrorAlert(message: error.localizedDescription)
        }
    }
}
