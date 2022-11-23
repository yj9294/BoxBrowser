//
//  PrivacyView.swift
//  BoxBrowser
//
//  Created by yangjian on 2022/11/23.
//

import SwiftUI

struct PrivacyView: View {
    
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
                Text("Privacy Policy")
                    .foregroundColor(.white)
            }
            .frame(height: 44)
            ScrollView {
                Text(setting.privacy)
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

extension PrivacyView {
    func dismissAction() {
        store.dispatch(.privacyShow(false))
    }
}

struct PrivacyView_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyView().environmentObject(AppStore())
    }
}
