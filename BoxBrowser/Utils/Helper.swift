//
//  Helper.swift
//  BoxBrowser
//
//  Created by yangjian on 2022/11/23.
//

import SwiftUI
import Combine

extension Color {
    init(hex: Int, alpha: Double = 1) {
        let components = (
            R: Double((hex >> 16) & 0xff) / 255,
            G: Double((hex >> 08) & 0xff) / 255,
            B: Double((hex >> 00) & 0xff) / 255
        )
        self.init(.sRGB, red: components.R, green: components.G, blue: components.B, opacity: alpha)
    }
    
    static var randomColor: Color {
        let r = Double.random(in: 40..<150)
        let g = Double.random(in: 40..<200)
        let b = Double.random(in: 40..<200)
        if #available(iOS 15.0, *) {
            return Color(uiColor: UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0))
        } else {
            return Color(red: r / 255.0, green: g / 255.0, blue: b / 255.0)
        }
    }
    
    static var grayColor: Color {
        return .init(hex: 0x9D9BCA)
    }
}

