//
//  CleanAlertView.swift
//  BoxBrowser
//
//  Created by yangjian on 2022/11/23.
//

import SwiftUI

struct CleanAlertView: View {
    
    @EnvironmentObject var store: AppStore
    var body: some View {
        VStack{
            HStack{
                Spacer()
            }
            Spacer()
            VStack {
                VStack(spacing: 16){
                    HStack{
                        Spacer()
                    }
                    Image("clean_icon")
                    Text("Close Tabs and Clear Data")
                        .foregroundColor(.grayColor)
                    Button {
                        action()
                    } label: {
                        ZStack{
                            Image("clean_button")
                            Text("Confirm")
                                .foregroundColor(.white)
                        }
                    }
                    
                    Button(action: dismissAction) {
                        Text("Cancel")
                            .foregroundColor(.grayColor)
                    }

                }
                .padding(.vertical, 24)
                .background(Color(hex: 0x181B3D).cornerRadius(12))
            }
            .padding(.horizontal, 40)
            Spacer()
        }
        .background(Color(hex: 0x333333, alpha: 0.6).ignoresSafeArea())
    }
}

extension CleanAlertView {
    
    @MainActor
    func action() {
        store.dispatch(.cleanAlertShow(false))
        store.dispatch(.cleanShow(true))
        Task{
            if !Task.isCancelled {
                try await Task.sleep(nanoseconds: 2_000_000_000)
                store.dispatch(.clean)
            }
        }
    }
    
    func dismissAction() {
        store.dispatch(.cleanAlertShow(false))
    }
}

struct CleanAlertView_Previews: PreviewProvider {
    static var previews: some View {
        CleanAlertView().environmentObject(AppStore())
    }
}
