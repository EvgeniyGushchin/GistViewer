//
//  AuthService.swift
//  GistViewer
//
//  Created by Evgeniy Gushchin on 5/12/25.
//

import Foundation

enum AuthError: Error {
    case authenticationFailed
    case keychainError
}

protocol AuthServiceProtocol: Observable {
    var token: String { get }
    var isAuthorized: Bool { get }
    
    func login() async throws
    func logout()
}

protocol AuthClientProtocol {
    func authenticate() async throws -> String
}
    
@Observable class AuthService: AuthServiceProtocol {
    
    private let key = "token"
    private(set) var token = ""
    private let authClient: AuthClientProtocol
    
    private(set) var isAuthorized = false
    
    init(client: AuthClientProtocol = GitHubAuthManager()) {
        
        self.authClient = client
        guard let tokenData = KeychainHelper.load(key: "githubGistToken"),
              let token = String(data: tokenData, encoding: .utf8) else {
            return
        }
        self.token = token
        self.isAuthorized = true
    }
    
    func login() async throws {
        
        let token = try await authClient.authenticate()
        guard let data = token.data(using: .utf8) else {
            throw "Failed to login"
        }
        _ = KeychainHelper.save(key: "githubGistToken", data: data)
        await MainActor.run {
            self.token = token
            self.isAuthorized = true
        }
    }
    
    func logout() {
        _ = KeychainHelper.delete(key: "githubGistToken")
        isAuthorized = false
    }
        
}
