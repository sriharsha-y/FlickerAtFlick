//
//  ImagesAPI.swift
//  FlickerAtFlick
//
//  Created by sriharshay on 02/10/19.
//  Copyright © 2019 harsha. All rights reserved.
//

import Foundation

public enum ImagesAPI {
    case searchImage(text: String, pageNumber: Int)
    case downloadImage(url: URL)
}

extension ImagesAPI: EndPointType {
    var baseURL: URL {
        switch self {
        case .searchImage(_,_):
            guard let url = URL(string: "https://api.flickr.com/") else { fatalError("Could'nt configure base url.") }
            return url
        case .downloadImage(let url):
            return url
        }
    }
    
    var path: String {
        switch self {
        case .searchImage(_,_):
            return "services/rest/"
        default:
            return ""
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .searchImage(let text,let pageNumber):
            return .requestParameters(bodyParameters: nil, urlParameters: [
                "method": "flickr.photos.search",
                "api_key": "3e7cc266ae2b0e0d78e279ce8e361736",
                "format": "json",
                "nojsoncallback": "1",
                "safe_search": "1",
                "text": "\(text)",
                "page": "\(pageNumber)"
            ])
        case .downloadImage(_):
            return .request
        }
    }
    
    var headers: HTTPHeaders {
        return [:]
    }
    
    
}
