//
//  HomeCenterView.swift
//  BoxBrowser
//
//  Created by yangjian on 2022/11/23.
//

import SwiftUI

struct HomeCenterView: View {
    
    @EnvironmentObject var store: AppStore
        
    let columns:[GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var home: AppState.HomeViewState {
        store.state.home
    }
    
    var root: AppState.RootViewState {
        store.state.root
    }
    
    var body: some View {
        VStack{
            
            // search View
            VStack {
                HStack{
                    TextField("", text: $store.state.home.text, onCommit: searchAction)
                        .placeholder(when: home.text.isEmpty, placeholder: {
                            Text("Seaech Or Enter Address")
                                .foregroundColor(Color(hex: 0x293966))
                        })
                        .foregroundColor(.white)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                    if home.isLoading {
                        Button(action: closeAction) {
                            Image("home_close")
                        }
                    } else {
                        Button(action: searchAction) {
                            Image("home_search")
                        }
                    }
                }
                .padding(.all, 16)
                .background(Color(hex: 0x161638))
                .cornerRadius(28)
                
                if home.isLoading {
                    VStack{
                        ProgressView(value: home.progress)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .padding(.top, 36)
            .padding(.horizontal, 25)
            .padding(.bottom, 8)
            
            // center
            if !home.isNavigation, !root.isTabShow {
                WebView(webView: home.model.webView)
            } else if !root.isCleanShow, !root.isPrivacyShow, !root.isTermsShow, !root.isTabShow {
                VStack{
                    Image("home_icon")
                    Spacer()
                    LazyVGrid(columns: columns, content: {
                        ForEach(AppState.HomeViewState.Item.allCases, id: \.self) { model in
                            Button {
                                navigationButtonAction(model.url)
                            } label: {
                                VStack(spacing: 7){
                                    Image(model.icon)
                                    Text(model.title)
                                        .foregroundColor(Color(hex: 0x9D9BCA))
                                }
                            }
                        }
                    })
                    Spacer()
                    NativeView(model: home.adModel)
                        .frame(height: 78)
                }
                .padding(.horizontal, 20)
                .onDisappear {
                    if !root.isTabShow {
                        navigationDisappear()
                    }
                }
                .onAppear {
                    navigationApear()
                }
            }
            Spacer()
            // bottom
            VStack {
                HStack(spacing: 45){
                    Spacer()
                    
                    Button(action: backAction) {
                        Image(home.canGoBack ? "home_last" : "home_last_1")
                    }
                    
                    Button(action: nextAction) {
                        Image(home.canGoForword ? "home_next" : "home_next_1")
                    }
                    
                    Button(action: cleanAction) {
                        Image("home_clean")
                    }
                    
                    Button(action: tabAction) {
                        ZStack{
                            Image("home_tab_num")
                            Text("\(home.models.count)")
                                .foregroundColor(Color(hex: 0x9D9BCA))
                        }
                    }
                    
                    Button(action: settingAction) {
                        Image("home_setting")
                    }
                    Spacer()
                }
            }
            .frame(height: 56)
            .background(Image("home_bottom_bg").resizable().ignoresSafeArea())
        }
        .background(
            Image("launch_bg")
                .resizable()
                .ignoresSafeArea()
        )
    }
}

extension HomeCenterView {
    
    func navigationButtonAction(_ url: String) {
        store.dispatch(.logE(.homeNavigationClick, ["lig": url]))
        
        store.dispatch(.hideKeyboard)
        store.dispatch(.homeText(url))
        store.dispatch(.homeSearch)
    }
    
    func searchAction() {
        store.dispatch(.logE(.homeSearchClick, ["lig": home.text]))
        
        store.dispatch(.hideKeyboard)
        store.dispatch(.homeSearch)
    }
    
    func closeAction() {
        store.dispatch(.logE(.homeCloseClick))

        store.dispatch(.homeText(""))
        store.dispatch(.homeStopSearch)
    }
    
    func backAction() {
        store.dispatch(.homeGoBack(true))
    }
    
    func nextAction() {        
        store.dispatch(.homeGoBack(false))
    }
    
    func cleanAction() {
        store.dispatch(.cleanAlertShow(true))
        store.dispatch(.adLoad(.interstitial))
    }
    
    func tabAction() {
        store.dispatch(.hideKeyboard)
        store.dispatch(.tabShow(true))
        store.dispatch(.logE(.tabShow))
        
        store.dispatch(.adDisappear(.native))
    }
    
    func settingAction() {
        store.dispatch(.settingShow(true))
    }
    
    func navigationDisappear() {
        store.dispatch(.adDisappear(.native))
    }
    
    func navigationApear() {
        store.dispatch(.adLoad(.interstitial))
        store.dispatch(.adLoad(.native, .home))
    }
}

struct HomeCenterView_Previews: PreviewProvider {
    static var previews: some View {
        HomeCenterView().environmentObject(AppStore())
    }
}
