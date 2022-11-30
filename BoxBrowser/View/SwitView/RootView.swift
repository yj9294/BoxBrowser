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
            AppEnterbackground = false
            store.dispatch(.dismiss)
            store.dispatch(.launching)
            store.dispatch(.logE(.openHot))
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification), perform: { _ in
            AppEnterbackground = true
        })
        .onReceive(NotificationCenter.default.publisher(for: .nativeAdLoadCompletion), perform: { ad in
            if let ad = ad.object as? NativeViewModel {
                store.dispatch(.homeAdModel(ad))
            }
        })
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView().environmentObject(AppStore())
    }
}
