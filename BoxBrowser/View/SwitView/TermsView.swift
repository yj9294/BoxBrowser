//
//  TermsView.swift
//  BoxBrowser
//
//  Created by yangjian on 2022/11/23.
//

import SwiftUI

struct TermsView: View {
    
    @EnvironmentObject var store: AppStore
    
    var setting: AppState.SettingViewState {
        store.state.setting
    }
    
    var body: some View {
        VStack{
            ZStack {
                HStack{
                    Button(action: dismissAction) {
                        Image("setting_back")
                            .padding(.leading, 16)
                    }
                    Spacer()
                }
                Text("Terms of Use")
                    .foregroundColor(.white)
            }
            .frame(height: 44)
            ScrollView {
                Text(setting.terms)
                    .foregroundColor(.grayColor)
                    .padding(.all, 16)
            }
        }
        .padding()
        .background(
            Image("launch_bg").resizable().ignoresSafeArea()
        )
    }
}

extension TermsView {
    func dismissAction() {
        store.dispatch(.termsShow(false))
    }
}

struct TermsView_Previews: PreviewProvider {
    static var previews: some View {
        TermsView().environmentObject(AppStore())
    }
}
