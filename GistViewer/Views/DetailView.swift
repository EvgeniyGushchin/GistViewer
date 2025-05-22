//
//  DetailView.swift
//  GistViewer
//
//  Created by Evgeniy Gushchin on 5/10/25.
//

import SwiftUI

struct DetailView: View {
    
    var gist: Gist
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if let aUrl = URL(string: gist.owner.avatarUrlString){
                    AsyncImage(url: aUrl) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 70, height: 70)
                }
                VStack(alignment: .leading) {
                    Text(gist.owner.login)
                        .font(.title)
                    Text(gist.owner.htmlUrlString)
                        .font(.subheadline)
                }
            }
            .padding(.top)
            .padding(.leading)
            Text(gist.description ?? "")
                .padding(.leading)
            List {
                ForEach(gist.files.sorted(by: { $0.key < $1.key }), id: \.key) { key, file in
                    DisclosureGroup(key) {
                        if let url = URL(string: file.rawUrlString) {
                            CodeView(url: url)
                        } else {
                            Text("Couldn't load file's url")
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
        .task {
        }
    }
}
#Preview {
    DetailView(gist: Gist(id: "", urlString: "", forksUrlString: "", commitsUrlString: "", nodeId: "", gitPullUrlString: "", gitPushUrlString: "", htmlUrlString: "", files: ["VPnCheck.m" : GistFile(filename: "VPnCheck.m", type: "text/plain", language: "Objective-C", rawUrlString: "https://gist.githubusercontent.com/EvgeniyGushchin/55e94d481f984f7f85fcd8dc5001b7a2/raw/49adb5cc5804d2326108f3ed5992afb179f28bad/VpnCheck.m", size: 806), "VPN2": GistFile(filename: "VPnCheck2.m", type: "text/plain", language: "Objective-C", rawUrlString: "https://gist.githubusercontent.com/EvgeniyGushchin/55e94d481f984f7f85fcd8dc5001b7a2/raw/49adb5cc5804d2326108f3ed5992afb179f28bad/VpnCheck.m", size: 806)], isPublic: true, createdAt: Date.now, updatedAt: Date.now, description: "ыщь дщтп вуыскшзешщт фвфывфыв  ывфывфы фвфыв ", comments: 2, isCommentsEnabled: true, commentsUrlString: "", isTruncated: false, owner: GistUser(id: 23506375, nodeId: "", login: "login", avatarUrlString: "https://avatars.githubusercontent.com/u/2247181?v=4", gravatarId: "", urlString: "", htmlUrlString: "https://gist.githubuserconten", gistsUrlString: "")))
}
