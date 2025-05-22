//
//  GistStore.swift
//  GistViewer
//
//  Created by Evgeniy Gushchin on 5/10/25.
//

import Foundation
import Combine
import Observation

@Observable class GistStore {
    
    var gists: [Gist] = []
    var personalGists: [Gist] = []
    var isAuth: Bool {
        return authService.isAuthorized
    }
    var showErrorAlert = false
    var errorMessage = ""
    
    var searchUserName = "" {
        didSet {
            searchSubject.send(searchUserName)
        }
    }
    var isLoading = false
    var hasMore = true
        
    private let searchSubject = PassthroughSubject<String, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private var lastPageIndex: Int = 1
    private var lastPersonalPageIndex: Int = 1
    private let apiClient: ApiClientProtocol
    private let authService: any AuthServiceProtocol
    private var isInitialEmptySkipped = false
    
    init(apiClient: ApiClientProtocol = ApiClient(),
         authService: any AuthServiceProtocol = AuthService()) {
        self.authService = authService
        self.apiClient = apiClient
        searchSubject
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .filter({ value in
                if !self.isInitialEmptySkipped && value.isEmpty {
                    self.isInitialEmptySkipped = true
                    return false
                }
                return true
            })
            .sink { [weak self] query in
                self?.performSearch(query: query)
            }
            .store(in: &cancellables)
    }
    
    private func performSearch(query: String) {
        Task { @MainActor in
            
            defer { isLoading = false }
            isLoading = true

            if query.isEmpty {
                gists = [Gist]()
                await fetchGistsPage()
            } else {
                await fetchByUser(name: query)
            }
        }
    }
    
    @MainActor
    private func showError(_ message: String) {
        self.showErrorAlert = true
        self.errorMessage = message
    }
    
    // MARK: - Fetch
    
    func fetchGistsPage() async {
        defer { isLoading = false }
        isLoading = true
        
        do {
            let (list, hasNext) = try await apiClient.fetchPublicGists(page: lastPageIndex)
            lastPageIndex += 1
            await MainActor.run {
                gists.append(contentsOf: list)
                hasMore = hasNext
            }
        } catch {
            await showError(error.localizedDescription)
        }
    }
    
    func fetchPersonalGistsPage() async  {
        guard isAuth else { return }
        
        do {
            let (list, hasNext) = try await apiClient.fetchPersonalGists(page: lastPersonalPageIndex, token: authService.token)
            lastPersonalPageIndex += 1
            await MainActor.run {
                personalGists.append(contentsOf: list)
                hasMore = hasNext
            }
        } catch {
            await showError(error.localizedDescription)
        }
        
    }
    
    func fetchByUser(name: String) async {
        do {
            let (list, hasNext) = try await apiClient.fetchGistsByUserName(username: name)
            await MainActor.run {
                gists = list
                lastPageIndex = 1
                hasMore = hasNext
            }
        } catch {
            await showError(error.localizedDescription)
        }
    }
          
    // MARK: - Login
    
    func login() async {
        do {
            try await authService.login()
        } catch {
            showErrorAlert = true
            errorMessage = error.localizedDescription
        }
        
    }
    
    func logout() {
        authService.logout()
        lastPersonalPageIndex = 1
    }
}
