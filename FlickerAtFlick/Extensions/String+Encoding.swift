//
//  String+Encoding.swift
//  FlickerAtFlick
//
//  Created by sriharshay on 02/10/19.
//  Copyright © 2019 harsha. All rights reserved.
//

import Foundation

extension String {
    
    func urlSafeString() -> String? {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
}
