//
//  FlickerImageModel.swift
//  FlickerAtFlick
//
//  Created by sriharshay on 28/09/19.
//  Copyright © 2019 harsha. All rights reserved.
//

import Foundation

struct FlickerImageModel: Codable {
    let id: String
    let owner: String?
    let secret: String
    let server: String
    let farm: Int
    let title: String?
    let ispublic: Int?
    let isfriend: Int?
    let isfamily: Int?
}
