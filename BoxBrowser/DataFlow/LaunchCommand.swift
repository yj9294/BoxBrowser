//
//  LaunchCommand.swift
//  BoxBrowser
//
//  Created by yangjian on 2022/11/23.
//

import Foundation

struct LaunchCommand: AppCommand {
    func execute(in store: AppStore) {
        
        let token = SubscriptionToken()
        
        Timer.publish(every: 0.01, on: .main, in: .common).autoconnect().sink { _ in
            let iv =  store.state.launch.duration / 0.01
            let progress = store.state.launch.progress + 1 / iv
            if progress < 1.0 {
                store.dispatch(.launchProgress(progress))
            } else {
                token.unseal()
                store.dispatch(.launched)
                store.dispatch(.logE(.homeShow))
            }
        }.seal(in: token)
    }
}
