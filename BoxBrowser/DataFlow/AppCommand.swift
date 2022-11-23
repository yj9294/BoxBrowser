//
//  AppCommand.swift
//  BoxBrowser
//
//  Created by yangjian on 2022/11/23.
//

import Combine
import UIKit

protocol AppCommand {
    func execute(in store: AppStore)
}
class SubscriptionToken {
    var cancelable: AnyCancellable?
    func unseal() { cancelable = nil }
}

extension AnyCancellable {
    func seal(in token: SubscriptionToken) {
        token.cancelable = self
    }
}


struct WebViewCommand: AppCommand {
    func execute(in store: AppStore) {
        
        store.dispatch(.homeText(""))
        
        let webView = store.state.home.model.webView

        let goback = webView.publisher(for: \.canGoBack).sink { canGoBack in
            store.dispatch(.homeCanGoBack(canGoBack))
        }
        
        let goForword = webView.publisher(for: \.canGoForward).sink { canGoForword in
            store.dispatch(.homeCanGoForword(canGoForword))
        }
        
        let isLoading = webView.publisher(for: \.isLoading).sink { isLoading in
            store.dispatch(.homeLoading(isLoading))
        }
        
        var start = Date()
        let progress = webView.publisher(for: \.estimatedProgress).sink { progress in
            if progress == 0.1 {
                start = Date()
                store.dispatch(.logE(.loading))
            }
            if progress == 1.0 {
                let time = Date().timeIntervalSince1970 - start.timeIntervalSince1970
                store.dispatch(.logE(.loaded, ["lig": "\(ceil(time))"]))
            }
            store.dispatch(.homeProgress(progress))
        }
        
        let isNavigation = webView.publisher(for: \.url).map{$0 == nil}.sink { isNavigation in
            store.dispatch(.homeNaivgation(isNavigation))
        }
        
        let url = webView.publisher(for: \.url).compactMap{$0}.sink { url in
            store.dispatch(.homeText(url.absoluteString))
        }
        
        store.disposeBag = [goback, goForword, isLoading, progress, isNavigation, url]
    }
}

struct HideKeyboardCommand: AppCommand {
    func execute(in store: AppStore) {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
