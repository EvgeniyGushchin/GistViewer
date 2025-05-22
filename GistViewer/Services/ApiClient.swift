//
//  ApiClient.swift
//  GistViewer
//
//  Created by Evgeniy Gushchin on 5/7/25.
//

import Foundation
import AuthenticationServices

protocol ApiClientProtocol {
    
    func fetchPublicGists(page: Int) async throws -> ([Gist], Bool)
    func fetchPersonalGists(page: Int, token: String) async throws -> ([Gist], Bool)
    func fetchGistsByUserName(username: String) async throws -> ([Gist], Bool)
}

final class ApiClient: ApiClientProtocol {
    
    private let baseUrlString: String
    private let gistPerPage: Int
    
    let decoder = JSONDecoder()
    
    init(baseUrlString: String = "https://api.github.com/",
         _ gistPerPage:  Int = 30) {
        self.baseUrlString = baseUrlString
        self.gistPerPage = gistPerPage
    }
    
    private func fetchRequestFor(page: Int, path: String) throws -> URLRequest {
        guard var urlComponents = URLComponents(string: baseUrlString + path) else {
            throw "Could not create endpoint URL components"
        }
        let baseParams = [
            "per_page": "\(gistPerPage)",
            "page": "\(page)"
        ]
        urlComponents.setQueryItems(with: baseParams)

        guard let queryURL = urlComponents.url else {
            throw "Could not create endpoint URL"
        }
        let request = URLRequest(url: queryURL)
        
        return request
    }
    
    private func parseGists(_ data: Data, response: URLResponse) throws -> [Gist] {
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
          throw "The server responded with an error."
        }
        
        decoder.dateDecodingStrategy = .iso8601
        guard let list = try? decoder.decode([Gist].self, from: data) else {
          throw "The server response was not recognized."
        }
        return list
    }
    
    func fetchPublicGists(page: Int) async throws -> ([Gist], Bool) {
        
        let request = try fetchRequestFor(page: page, path: "gists")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        let list = try parseGists(data, response: response)
        let hasNext = (response as? HTTPURLResponse)?.value(forHTTPHeaderField: "Link")?.contains("next") ?? false
        return (list, hasNext)
    }
    
    func fetchPersonalGists(page: Int, token: String) async throws -> ([Gist], Bool) {
        
        var request = try fetchRequestFor(page: page, path: "gists")
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        let list = try parseGists(data, response: response)
        let hasNext = (response as? HTTPURLResponse)?.value(forHTTPHeaderField: "Link")?.contains("next") ?? false
        return (list, hasNext)
    }
    
    func fetchGistsByUserName(username: String) async throws -> ([Gist], Bool) {
        
        let request = try fetchRequestFor(page: 1, path:  "users/\(username)/gists")
        let (data, response) = try await URLSession.shared.data(for: request)
        let list = try parseGists(data, response: response)
        let hasNext = (response as? HTTPURLResponse)?.value(forHTTPHeaderField: "Link")?.contains("next") ?? false
        return (list, hasNext)
    }
}
