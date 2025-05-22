//
//  Gist.swift
//  GistViewer
//
//  Created by Evgeniy Gushchin on 4/30/25.
//

import Foundation

struct Gist: Codable, Identifiable, Hashable {
    
    let id: String
    let urlString: String
    let forksUrlString: String
    let commitsUrlString: String
    let nodeId: String
    let gitPullUrlString: String
    let gitPushUrlString: String
    let htmlUrlString: String
    
    let files: [String: GistFile]
    let isPublic: Bool
    let createdAt: Date
    let updatedAt: Date
    let description: String?
    let comments: Int
    let isCommentsEnabled: Bool
    let commentsUrlString: String
    let isTruncated: Bool
    let owner: GistUser
    
    enum CodingKeys: String, CodingKey {
        case id
        case urlString = "url"
        case forksUrlString = "forks_url"
        case commitsUrlString = "commits_url"
        case nodeId = "node_id"
        case gitPullUrlString = "git_pull_url"
        case gitPushUrlString = "git_push_url"
        case htmlUrlString = "html_url"
        case files
        case isPublic = "public"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case description
        case comments
        case isCommentsEnabled = "comments_enabled"
        case commentsUrlString = "comments_url"
        case isTruncated = "truncated"
        case owner
    }
}
