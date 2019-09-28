//
//  Utils.swift
//  FlickerAtFlick
//
//  Created by sriharshay on 28/09/19.
//  Copyright © 2019 harsha. All rights reserved.
//

import Foundation

struct Utils {
    
    static func createFlickerImageUrlStringFrom(_ model: FlickerImageModel) -> String {
        return "https://farm\(model.farm).static.flickr.com/\(model.server)/\(model.id)_\(model.secret).jpg"
    }
}
