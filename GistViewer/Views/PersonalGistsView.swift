//
//  PersonalGistsView.swift
//  GistViewer
//
//  Created by Evgeniy Gushchin on 5/13/25.
//

import SwiftUI

struct PersonalGistsView: View {
    
    @Environment(GistStore.self) var store
    
    var body: some View {
        @Bindable var twStore = store
        VStack {
            if !store.isAuth {
                VStack(spacing: 15) {
                    Text("Please login to view personal gists")
                    Button("Login") {
                        Task { @MainActor in 
                            await store.login()
                        }
                    }
                    .foregroundColor(Color.blue)
                    .padding(.horizontal)
                    .padding(.vertical,10)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.blue, lineWidth: 2))
                }
            } else {
                List($twStore.personalGists, id: \.self) { $gist in
                    NavigationLink(destination: DetailView(gist: gist)) {
                        GistCellView(gist: gist)
                    }
                }
                .task {
                    await store.fetchPersonalGistsPage()
                }
            }
        }
        .alert("Error", isPresented: $twStore.showErrorAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(twStore.errorMessage)
        }
        
        .onChange(of: store.isAuth) { _, newValue in
                    print("Authorization status changed to: \(newValue)")
                }
    }
}

#Preview {
    PersonalGistsView()
        .environment(GistStore())
}
