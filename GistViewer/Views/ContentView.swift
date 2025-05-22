//
//  ContentView.swift
//  GistViewer
//
//  Created by Evgeniy Gushchin on 4/30/25.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(GistStore.self) var store
    
    @State var isAuthorizing = false
    @State var selectedTab: Int = 0
    @State var searchUserName = ""
    
    var body: some View {
        @Bindable var twStore = store
        NavigationStack {
            TabView(selection: $selectedTab) {
                VStack {
                    TextField("Search by username", text: $twStore.searchUserName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                    List($twStore.gists, id: \.id) { $gist in
                        NavigationLink(destination: DetailView(gist: gist)) {
                            GistCellView(gist: gist)
                        }
                        .onAppear {
                            if gist == twStore.gists.last && twStore.hasMore {
                                Task {
                                    await store.fetchGistsPage()
                                }
                            }
                        }
                    }
                }
                .tabItem {
                    Image(systemName: "person.2")
                    Text("Public Gists")
                }
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarBackground(
                    Color(uiColor: .systemBackground),
                    for: .tabBar
                )
                
                PersonalGistsView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Your Gists")
                }
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarBackground(
                    Color(uiColor: .systemBackground),
                    for: .tabBar
                )
            }
            .overlay{
                (store.isLoading && store.gists.count == 0) ? ProgressView() : nil
            }
            .toolbar {
                if store.isAuth {
                    Button("Logout") {
                        store.logout()
                    }
                }
            }
        }
        .task {
            await store.fetchGistsPage()
        }
        .alert("Error", isPresented: $twStore.showErrorAlert) {
            Button("Close", role: .cancel) {}
        } message: {
            Text(twStore.errorMessage)
        }
    }
}
#Preview {
    ContentView()
        .environment(GistStore())
}
