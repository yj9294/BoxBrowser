//
//  RootView.swift
//  BoxBrowser
//
//  Created by yangjian on 2022/11/23.
//

import SwiftUI

struct RootView: View {
    
    @EnvironmentObject var store: AppStore
    
    var body: some View {
        TabView(selection: $store.state.root.selection) {
            LaunchView()
                .tag(AppState.RootViewState.Index.launch)
            HomeView()
                .tag(AppState.RootViewState.Index.home)
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            store.dispatch(.launching)
            store.dispatch(.logE(.openHot))
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView().environmentObject(AppStore())
    }
}
