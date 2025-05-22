//
//  GitHubAuthManager.swift
//  GistViewer
//
//  Created by Evgeniy Gushchin on 5/11/25.
//

import AuthenticationServices

class GitHubAuthManager: NSObject, ASWebAuthenticationPresentationContextProviding, AuthClientProtocol {
    
    private struct TokenResponse: Codable {
        let accessToken: String?
        let tokenType: String?
        let scope: String?
        
        enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
            case tokenType = "token_type"
            case scope
        }
    }
    
    enum AuthError: Error {
        case invalidCallbackURL
        case tokenExchangeFailed
    }
    
    static var keyWindow: UIWindow? {
        let allScenes = UIApplication.shared.connectedScenes
        for scene in allScenes {
            guard let windowScene = scene as? UIWindowScene else { continue }
            for window in windowScene.windows where window.isKeyWindow {
                return window
            }
        }
        return nil
    }
    
    private let clientID = "YOUR_ID"
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return GitHubAuthManager.keyWindow!
    }
    
    func authenticate() async throws -> String {
        let callbackURLScheme = "myapp"
        let authURL = URL(string: "https://github.com/login/oauth/authorize?client_id=\(clientID)&scope=gist")!
        
        let code: String = try await withCheckedThrowingContinuation() { continuation in
            Task { @MainActor in
                let session = ASWebAuthenticationSession(
                    url: authURL,
                    callbackURLScheme: callbackURLScheme
                ) { callbackURL, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    
                    guard let callbackURL = callbackURL,
                          let code = URLComponents(string: callbackURL.absoluteString)?
                        .queryItems?
                        .first(where: { $0.name == "code" })?
                        .value else {
                        continuation.resume(throwing: AuthError.invalidCallbackURL)
                        return
                    }
                    continuation.resume(returning: code)
                }
                
                session.presentationContextProvider = self
                session.prefersEphemeralWebBrowserSession = true
                session.start()
            }}
        
        return try await exchangeCodeForToken(code: code)
    }
    
    private func exchangeCodeForToken(code: String) async throws -> String {
        let clientSecret = "YOUR_SECRET" // client secret
        let tokenURL = URL(string: "https://github.com/login/oauth/access_token")!
        
        var request = URLRequest(url: tokenURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = [
            "client_id": clientID,
            "client_secret": clientSecret,
            "code": code
        ]
        
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(TokenResponse.self, from: data)
        
        guard let accessToken = response.accessToken else {
            throw AuthError.tokenExchangeFailed
        }
        
        return accessToken
    }
}
