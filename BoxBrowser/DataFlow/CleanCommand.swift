//
//  CleanCommand.swift
//  BoxBrowser
//
//  Created by yangjian on 2022/11/25.
//

import Foundation
import WebKit

struct CleanCommand: AppCommand {
    func execute(in store: AppStore) {
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: [WKWebsiteDataTypeCookies]) {
           _ = $0.map {
                WKWebsiteDataStore.default().removeData(ofTypes: $0.dataTypes, for: [$0]) {
                    NSLog("clean all cookies")
                }
            }
        }
        
        var progress = 0.0
        var duration = 16.0
        let token = SubscriptionToken()

        Timer.publish(every: 0.01, on: .main, in: .common).autoconnect().sink { _ in
            let totalCount = 1.0 / 0.01 * duration
            progress = progress + 1 / totalCount
            if AppEnterbackground {
                token.unseal()
                store.dispatch(.cleanShow(false))
                return
            }
            if progress >= 1.0 {
                token.unseal()
                store.dispatch(.adShow(.interstitial) { _ in
                    store.dispatch(.tabClean)
                    store.dispatch(.webview)
                    store.dispatch(.cleanShow(false))
                    store.dispatch(.alert("Clean Successfully."))
                                        
                    store.dispatch(.logE(.cleanAnimation))
                    store.dispatch(.logE(.cleanAlert))
                })
            }
            
            if store.state.ad.isLoaded(.interstitial) {
                duration = 0.1
            }
        }.seal(in: token)
    }
}
