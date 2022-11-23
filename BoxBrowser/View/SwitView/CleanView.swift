//
//  CleanView.swift
//  BoxBrowser
//
//  Created by yangjian on 2022/11/23.
//

import SwiftUI

struct CleanView: View {
    
    @EnvironmentObject var store: AppStore
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
            }
            Spacer()
            ZStack {
                LottieView(fileName: "clean")
                Text("Clearing…")
                    .foregroundColor(.grayColor)
                    .padding(.top, 400)
            }
            Spacer()
        }
        .background(
            Image("launch_bg").resizable().ignoresSafeArea()
        )
        .onAppear{
            Task{
                if !Task.isCancelled {
                    try await Task.sleep(nanoseconds: 2_000_000_000)
                    dismissAction()
                }
            }
        }
    }
}

extension CleanView {
    func dismissAction() {
        store.dispatch(.logE(.cleanAnimation))
        store.dispatch(.cleanShow(false))
        store.dispatch(.tabClean)
        store.dispatch(.webview)
        store.dispatch(.logE(.cleanAlert))
        store.dispatch(.alert("Clean Successfully."))
    }
}

struct CleanView_Previews: PreviewProvider {
    static var previews: some View {
        CleanView().environmentObject(AppStore())
    }
}
