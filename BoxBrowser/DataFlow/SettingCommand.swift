//
//  SettingCommand.swift
//  BoxBrowser
//
//  Created by yangjian on 2022/11/23.
//

import Foundation
import MobileCoreServices
import UIKit

struct SettingCopyCommand: AppCommand {
    func execute(in store: AppStore) {
        if store.state.home.model.isNavigation {
            UIPasteboard.general.setValue("", forPasteboardType: kUTTypePlainText as String)
        } else {
            UIPasteboard.general.setValue(store.state.home.text, forPasteboardType: kUTTypePlainText as String)
        }
    }
}
