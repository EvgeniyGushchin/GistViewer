//
//  GistViewerApp.swift
//  GistViewer
//
//  Created by Evgeniy Gushchin on 4/30/25.
//

import SwiftUI

@main
struct GistViewerApp: App {
    
    @State var store = GistStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(store)
        }
    }
}
