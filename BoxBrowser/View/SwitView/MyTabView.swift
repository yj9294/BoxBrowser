//
//  MyTabView.swift
//  BoxBrowser
//
//  Created by yangjian on 2022/11/23.
//

import SwiftUI

struct MyTabView: View {
    @EnvironmentObject var store: AppStore
    
    var home: AppState.HomeViewState {
        store.state.home
    }
    
    let colums = [GridItem(.flexible(minimum: 150, maximum: 200), spacing: 16), GridItem(.flexible(minimum: 150, maximum: 200), spacing: 16)]

    
    var body: some View {
        VStack{
            ScrollView{
                LazyVGrid(columns: colums) {
                    ForEach(home.models, id: \.self) { model in
                        ZStack {
                            if model.isSelect {
                                Color.blue.cornerRadius(8)
                            } else {
                                Color.gray.cornerRadius(8)
                            }
                            
                            
                            // cell
                            Button {
                                selectAction(model)
                            } label: {
                                if model.isNavigation {
                                    Image("tab_navigation").resizable()
                                        .padding(.all, 2)
                                } else {
                                    WebView(webView: model.webView)
                                        .onAppear {
                                            model.webView.isUserInteractionEnabled = false
                                        }
                                        .onDisappear {
                                            model.webView.isUserInteractionEnabled = true
                                        }
                                }
                            }
                            .cornerRadius(8)
                            .clipped()
                            .padding(.all, 2)
                            
                            // 删除按钮
                            VStack{
                                HStack{
                                    Spacer()
                                    if home.models.count > 1 {
                                        Button {
                                            deleteAction(model)
                                        } label: {
                                            Image("tab_close").padding(.all, 8)
                                        }
                                    }
                                }
                                Spacer()
                            }
                            .frame(height: 220)
                        }
                    }
                }
                .padding(.top, 32)
                .padding(.horizontal, 20)
            }
            Spacer()
            
            VStack {
                NativeView(model: home.adModel)
                    .frame(height: 78)
            }
            .padding(.horizontal, 12)
            .onAppear {
                adApear()
            }
            
            // 底部
            ZStack{
                HStack{
                    Spacer()
                    Button(action: addAction) {
                        Image("tab_new")
                    }
                    Spacer()
                }
                .padding(.vertical, 8)
                .frame(height: 58)

                HStack{
                    Spacer()
                    Button(action: backAction) {
                        Text("Back").foregroundColor(Color(hex: 0x9D9BCA))
                            .font(.body)
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 8)
                }
                .frame(height: 58)
            }
            .background(Image("home_bottom_bg").resizable().ignoresSafeArea())
        }
        .background(
            Image("launch_bg")
                .resizable()
                .ignoresSafeArea()
        )
    }
}

extension MyTabView{
    func selectAction(_ model: HomeViewModel) {
        store.dispatch(.tabSelect(model))
        store.dispatch(.webview)
        store.dispatch(.tabShow(false))
    }
    
    func deleteAction(_ model: HomeViewModel) {
        store.dispatch(.tabDelete(model))
        store.dispatch(.webview)
    }
    
    func addAction() {
        store.dispatch(.logE(.tabNew, ["lig": "tab"]))
        
        store.dispatch(.tabNew)
        store.dispatch(.webview)
        store.dispatch(.tabShow(false))
    }
    
    func backAction() {
        store.dispatch(.adDisappear(.native))
        store.dispatch(.tabShow(false))
    }
    
    func adApear() {
        store.dispatch(.adLoad(.native, .tab))
        store.dispatch(.adLoad(.interstitial))
    }
}

struct MyTabView_Previews: PreviewProvider {
    static var previews: some View {
        MyTabView().environmentObject(AppStore())
    }
}
