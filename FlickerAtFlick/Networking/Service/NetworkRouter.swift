//
//  NetworkRouter.swift
//  FlickerAtFlick
//
//  Created by sriharshay on 02/10/19.
//  Copyright © 2019 harsha. All rights reserved.
//

import Foundation

public typealias NetworkRouterCompletion = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> ()

protocol NetworkRouter: class {
    func request(_ route: EndPointType, completion: @escaping NetworkRouterCompletion)
    func cancel()
}
