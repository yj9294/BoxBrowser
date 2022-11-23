//
//  AppUtil.swift
//  BoxBrowser
//
//  Created by yangjian on 2022/11/23.
//

import UIKit

struct AppUtil {
    static var window: UIWindow? = nil
}

extension String {
    var isUrl: Bool {
        let url = "[a-zA-z]+://.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", url)
        return predicate.evaluate(with: self)
    }
}
