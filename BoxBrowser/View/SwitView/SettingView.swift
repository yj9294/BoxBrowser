//
//  SettingView.swift
//  BoxBrowser
//
//  Created by yangjian on 2022/11/23.
//

import SwiftUI

struct SettingView: View {
    
    @EnvironmentObject var store: AppStore
    @Environment(\.openURL) private var openURL
    
    let columns:[GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    
    var body: some View {
        VStack{
            HStack{Spacer()}
            Spacer()
            VStack{
                LazyVGrid(columns: columns) {
                    ForEach(AppState.SettingViewState.Item.allCases, id: \.self) { item in
                        Button {
                            buttonAction(item)
                        } label: {
                            VStack{
                                Image(item.icon)
                                Text(item.title)
                                    .font(.footnote)
                                    .lineLimit(1)
                                    .foregroundColor(.grayColor)
                            }
                        }
                    }
                }
                .padding(.vertical, 20)
                .background(Color(hex: 0x181B3D).cornerRadius(12))
            }
            .padding(.all, 20)
        }
        .background(Color(hex: 0x333333, alpha: 0.6).ignoresSafeArea().onTapGesture {
            dismissAction()
        })
    }
}

extension SettingView {
    func dismissAction() {
        store.dispatch(.settingShow(false))
    }
    
    func buttonAction(_ item: AppState.SettingViewState.Item) {
        store.dispatch(.settingShow(false))
        switch item {
        case .new:
            newAction()
        case .share:
            shareAction()
        case .copy:
            copyAction()
        case .rate:
            rateAction()
        case .terms:
            termsAction()
        case .privacy:
            privacyAction()
        }
    }
    
    func newAction() {
        store.dispatch(.logE(.tabNew, ["lig": "tab"]))

        store.dispatch(.tabNew)
        store.dispatch(.webview)
    }
    
    func shareAction() {
        store.dispatch(.logE(.shareClick))

        store.dispatch(.shareShow(true))
    }
    
    func copyAction() {
        store.dispatch(.logE(.copyClick))
        
        store.dispatch(.settingCopy)
        store.dispatch(.alert("Copy Successfully."))
    }
    
    func rateAction() {
        if let url = URL(string: "https://itunes.apple.com/cn/app/id") {
            openURL(url)
        }
    }
    
    func termsAction() {
        store.dispatch(.termsShow(true))
    }
    
    func privacyAction() {
        store.dispatch(.privacyShow(true))
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView().environmentObject(AppStore())
    }
}
