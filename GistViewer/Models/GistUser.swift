//
//  GistUser.swift
//  GistViewer
//
//  Created by Evgeniy Gushchin on 4/30/25.
//

import Foundation

struct GistUser: Codable, Identifiable, Hashable {
    
    let id: Int
    let nodeId: String
    let login: String
    let avatarUrlString: String
    let gravatarId: String
    let urlString: String
    let htmlUrlString: String
    let gistsUrlString: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case nodeId = "node_id"
        case login
        case avatarUrlString = "avatar_url"
        case gravatarId = "gravatar_id"
        case urlString = "url"
        case htmlUrlString = "html_url"
        case gistsUrlString = "gists_url"
    }
    
}
