//
//  GistFile.swift
//  GistViewer
//
//  Created by Evgeniy Gushchin on 4/30/25.
//

struct GistFile: Codable, Hashable {
    
    let filename: String
    let type: String
    let language: String?
    let rawUrlString: String
    let size: Int
    
    enum CodingKeys: String, CodingKey {
        case filename
        case type
        case language
        case size
        case rawUrlString = "raw_url"
    }
}
