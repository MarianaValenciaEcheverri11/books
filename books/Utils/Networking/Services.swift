//
//  Services.swift
//  books
//
//  Created by Mariana Valencia Echeverri on 29/01/24.
//

import Foundation

enum ServiceError: Error {
    case formatIncorrect
    case invalidUrl
}

struct Constants {
    static let apiVersion: Float = 1.47
    static let appName: String = "iOS"
    static let httpMethod: String = "POST"
    
    struct Urls {
        static func getBaseURL() -> URL? {
            return URL(string: Apis.BASE_API_URL)
        }
    }
}

protocol ServicesProtocol {
    func registerAppAsync() async throws -> RegisterAppModel
    func registerApp(completion: @escaping (Result<RegisterAppModel, ServiceError>) -> Void)
    func createOauthkeyAsync(with email: String, password: String,
                             appKey: String) async throws -> OauthKeyModel
    func createOauthkey(with email: String, password: String,
                        appKey: String, completion: @escaping (Result<OauthKeyModel, ServiceError>) -> Void)
    func createSesskeyAsync(with model: OauthKeyModel) async throws -> CreateSesskeyModel
    func createSesskey(with model: OauthKeyModel, completion: @escaping (Result<CreateSesskeyModel, ServiceError>) -> Void)
    func getBooksAsync(with model: OauthKeyModel, sesskey: String, book: String) async throws -> Library
    func getBooks(with model: OauthKeyModel, sesskey: String, book: String,
                  completion: @escaping (Result<Library, ServiceError>) -> Void)
}

class Services: ServicesProtocol {
    
    func registerAppAsync() async throws -> RegisterAppModel {
        try await withCheckedThrowingContinuation { continuation in
            registerApp() { result in
                switch result {
                    case .success(let model):
                        continuation.resume(returning: model)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func registerApp(completion: @escaping (Result<RegisterAppModel, ServiceError>) -> Void) {
        let urlSession = URLSession.shared
        guard let url = Constants.Urls.getBaseURL() else {
            return completion(.failure(.invalidUrl))
        }
        var request = URLRequest(url: url)
        request.httpMethod = Constants.httpMethod
        let parameters: [String: Any] = [
            "version": Constants.apiVersion,
            "req": "createAppkey",
            "appname": Constants.appName
        ]
        request.httpBody = parameters.percentEncoded()
        urlSession.dataTask(with: request) { data, response, error in
            do {
                if let data = data {
                    let model = try JSONDecoder().decode(RegisterAppModel.self, from: data)
                    completion(.success(model))
                }
            } catch {
                completion(.failure(.formatIncorrect))
            }
        }.resume()
    }
    
    func createOauthkeyAsync(
        with email: String,
        password: String,
        appKey: String
    ) async throws -> OauthKeyModel {
        try await withCheckedThrowingContinuation { continuation in
            createOauthkey(with: email, password: password, appKey: appKey) { result in
                switch result {
                    case .success(let model):
                        continuation.resume(returning: model)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func createOauthkey(
        with email: String,
        password: String,
        appKey: String,
        completion: @escaping (Result<OauthKeyModel, ServiceError>) -> Void
    ) {
        let urlSession = URLSession.shared
        guard let url = Constants.Urls.getBaseURL() else {
            return completion(.failure(.invalidUrl))
        }
        var request = URLRequest(url: url)
        request.httpMethod = Constants.httpMethod
        let parameters: [String: Any] = [
            "version": Constants.apiVersion,
            "req": "createOauthkey",
            "login": email,
            "pwd": password,
            "appkey": appKey,
            
        ]
        request.httpBody = parameters.percentEncoded()
        urlSession.dataTask(with: request) { data, response, error in
            do {
                if let data = data {
                    let model = try JSONDecoder().decode(OauthKeyModel.self, from: data)
                    completion(.success(model))
                }
            } catch {
                completion(.failure(.formatIncorrect))
            }
        }.resume()
    }
    
    func createSesskeyAsync(with model: OauthKeyModel) async throws -> CreateSesskeyModel {
        try await withCheckedThrowingContinuation { continuation in
            createSesskey(with: model) { result in
                switch result {
                    case .success(let model):
                        continuation.resume(returning: model)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func createSesskey(
        with model: OauthKeyModel,
        completion: @escaping (Result<CreateSesskeyModel, ServiceError>) -> Void
    ) {
        let urlSession = URLSession.shared
        guard let url = Constants.Urls.getBaseURL() else {
            return completion(.failure(.invalidUrl))
        }
        var request = URLRequest(url: url)
        request.httpMethod = Constants.httpMethod
        let parameters: [String: Any] = [
            "version": Constants.apiVersion,
            "req": "createSesskey",
            "o_u": model.o_u,
            "u_c": model.o_u,
            "oauthkey": model.oauthkey
        ]
        request.httpBody = parameters.percentEncoded()
        urlSession.dataTask(with: request) { data, response, error in
            do {
                if let data = data {
                    let model = try JSONDecoder().decode(CreateSesskeyModel.self, from: data)
                    completion(.success(model))
                }
            } catch {
                completion(.failure(.formatIncorrect))
            }
        }.resume()
    }
    
    func getBooksAsync(
        with model: OauthKeyModel,
        sesskey: String,
        book: String = String()
    ) async throws -> Library {
        try await withCheckedThrowingContinuation { continuation in
            getBooks(with: model, sesskey: sesskey, book: book) { result in
                switch result {
                    case .success(let books):
                        continuation.resume(returning: books)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func getBooks(
        with model: OauthKeyModel,
        sesskey: String,
        book: String,
        completion: @escaping (Result<Library, ServiceError>) -> Void
    ) {
        let urlSession = URLSession.shared
        guard let url = Constants.Urls.getBaseURL() else {
            return completion(.failure(.invalidUrl))
        }
        var request = URLRequest(url: url)
        request.httpMethod = Constants.httpMethod
        let parameters: [String: Any] = [
            "version": Constants.apiVersion,
            "req": "getAllBooks",
            "u_c": model.o_u,
            "o_u": model.o_u,
            "sesskey": sesskey
        ]
        request.httpBody = parameters.percentEncoded()
        urlSession.dataTask(with: request) { data, response, error in
            do {
                if let data = data {
                    let model = try JSONDecoder().decode(Library.self, from: data)
                    completion(.success(model))
                }
            } catch {
                completion(.failure(.formatIncorrect))
            }
        }.resume()
    }
}
