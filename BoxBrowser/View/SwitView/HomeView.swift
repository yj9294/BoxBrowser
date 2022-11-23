//
//  HomeView.swift
//  BoxBrowser
//
//  Created by yangjian on 2022/11/23.
//

import SwiftUI
import AppTrackingTransparency

struct HomeView: View {
    
    @EnvironmentObject var store: AppStore
    
    var root: AppState.RootViewState {
        store.state.root
    }
    
    var home: AppState.HomeViewState {
        store.state.home
    }
    
    var body: some View {
        ZStack{
            HomeCenterView()
            
            if root.isTabShow {
                MyTabView()
                    .onDisappear {
                        store.dispatch(.logE(.homeShow))
                    }
            }
            
            if root.isCleanAlert {
                CleanAlertView()
            }
            
            if root.isCleanShow {
                CleanView()
                    .onDisappear {
                        store.dispatch(.logE(.homeShow))
                    }
            }
            
            if root.isSettingShow {
                SettingView()
            }
            
            if root.isPrivacyShow {
                PrivacyView()
                    .onDisappear {
                        store.dispatch(.logE(.homeShow))
                    }
            }
            
            if root.isTermsShow {
                TermsView()
                    .onDisappear {
                        store.dispatch(.logE(.homeShow))
                    }
            }
            
        }
        .sheet(isPresented: $store.state.root.isShareShow) {
            if let url = home.model.webView.url?.absoluteString {
                ShareView(url: url)
            } else {
                ShareView(url: "https://itunes.apple.com/cn/app/id")
            }
        }
        .alert(isPresented: $store.state.root.isAlert) {
            Alert(title: Text(root.message))
        }
        .onAppear {
            ATTrackingManager.requestTrackingAuthorization { _ in
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(AppStore())
    }
}
