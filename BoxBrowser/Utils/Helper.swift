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

@propertyWrapper
struct UserDefault<T: Codable> {
    var value: T?
    let key: String
    init(key: String) {
        self.key = key
        self.value = UserDefaults.standard.getObject(T.self, forKey: key)
    }
    
    var wrappedValue: T? {
        set  {
            value = newValue
            UserDefaults.standard.setObject(value, forKey: key)
            UserDefaults.standard.synchronize()
        }
        
        get { value }
    }
}


extension UserDefaults {
    func setObject<T: Codable>(_ object: T?, forKey key: String) {
        let encoder = JSONEncoder()
        guard let object = object else {
            self.removeObject(forKey: key)
            return
        }
        guard let encoded = try? encoder.encode(object) else {
            return
        }
        self.setValue(encoded, forKey: key)
    }
    
    func getObject<T: Codable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = self.data(forKey: key) else {
            return nil
        }
        guard let object = try? JSONDecoder().decode(type, from: data) else {
            return nil
        }
        return object
    }
}


