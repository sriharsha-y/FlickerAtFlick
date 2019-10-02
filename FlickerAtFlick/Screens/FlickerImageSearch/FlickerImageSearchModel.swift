//
//  FlickerImageSearchModel.swift
//  FlickerAtFlick
//
//  Created by sriharshay on 28/09/19.
//  Copyright © 2019 harsha. All rights reserved.
//

import Foundation

struct FlickerImageSearchModel: Codable {
    
    let photos: FlickerImageSearchPageModel
    
    struct FlickerImageSearchPageModel: Codable {
        let page: Int
        let pages: Int
        let perpage: Int
        let total: String
        let photo: [FlickerImageModel]
    }
}
