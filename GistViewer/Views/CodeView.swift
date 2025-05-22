//
//  CodeView.swift
//  GistViewer
//
//  Created by Evgeniy Gushchin on 5/22/25.
//

import SwiftUI

struct CodeView: View {
    let url: URL
    @State private var text: String = "Загрузка..."
    @State private var isLoading = true
    
    var body: some View {
        ScrollView {
            Text(text)
                .padding()
                .onAppear(perform: loadTextFromURL)
        }
        .overlay(
            isLoading ? ProgressView() : nil
        )
    }
    
    private func loadTextFromURL() {
        isLoading = true
        Task {
            do {
                let (data, response) = try await URLSession.shared.data(from: url)
                guard (response as? HTTPURLResponse)?.statusCode == 200,
                      let loadedText = String(data: data, encoding: .utf8)
                else {
                        await fillValues(text: nil, errorStr: nil)
                    return
                }
                await fillValues(text: loadedText, errorStr: nil)
            } catch {
                await fillValues(text: nil, errorStr: error.localizedDescription)
            }
        }
    }
    
    private func fillValues(text: String?, errorStr: String?) async {
        var tmp = "Не удалось загрузить текст: Неизвестная ошибка"
        if let erStr = errorStr {
            tmp = "Не удалось загрузить текст: \(erStr)"
        } else if let tStr = text {
            tmp = tStr
        }
        await MainActor.run {
            self.text = tmp
            self.isLoading = false
        }
    }
}

#Preview {
    CodeView(url: URL(string: "https://gist.githubusercontent.com/EvgeniyGushchin/55e94d481f984f7f85fcd8dc5001b7a2/raw/49adb5cc5804d2326108f3ed5992afb179f28bad/VpnCheck.m")!)
}
