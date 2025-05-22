//
//  GistCellView.swift
//  GistViewer
//
//  Created by Evgeniy Gushchin on 5/12/25.
//

import SwiftUI

struct GistCellView: View {
    
    var gist: Gist
    
    var body: some View {
        HStack {
            if let aUrl = URL(string: gist.owner.avatarUrlString){
                AsyncImage(url: aUrl) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 50, height: 50)
            }
            VStack(alignment: .leading) {
                if let descr = gist.description, descr.count > 0  {
                    Text(descr)
                } else {
                    Text("Empty description")
                }
                Text("Author: \(gist.owner.login)")
                    .font(.footnote)
            }
        }
        
    }
}

#Preview {
    GistCellView(gist: Gist(id: "", urlString: "", forksUrlString: "", commitsUrlString: "", nodeId: "", gitPullUrlString: "", gitPushUrlString: "", htmlUrlString: "", files: [String : GistFile](), isPublic: true, createdAt: Date.now, updatedAt: Date.now, description: "", comments: 2, isCommentsEnabled: true, commentsUrlString: "", isTruncated: false, owner: GistUser(id: 23506375, nodeId: "", login: "login", avatarUrlString: "https://avatars.githubusercontent.com/u/2247181?v=4", gravatarId: "", urlString: "", htmlUrlString: "", gistsUrlString: "")))
}
