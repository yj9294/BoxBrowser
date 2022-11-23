//
//  HomeCommand.swift
//  BoxBrowser
//
//  Created by yangjian on 2022/11/23.
//

import Foundation

struct HomeSearchCommand: AppCommand {
    func execute(in store: AppStore) {
        let text = store.state.home.text
        if text.count == 0 {
            store.dispatch(.alert("Please enter your search content.  "))
            return
        }
        store.state.home.model.load(text)
    }
}

struct HomeStopSearchCommand: AppCommand {
    func execute(in store: AppStore) {
        store.state.home.model.stopLoad()
    }
}

struct HomeGoCommand: AppCommand {
    let isGoback: Bool
    func execute(in store: AppStore) {
        if isGoback {
            store.state.home.model.goBack()
        } else {
            store.state.home.model.goForword()
        }
    }
}
