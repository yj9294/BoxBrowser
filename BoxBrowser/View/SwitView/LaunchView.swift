//
//  LaunchView.swift
//  BoxBrowser
//
//  Created by yangjian on 2022/11/23.
//

import SwiftUI

struct LaunchView: View {
    
    @EnvironmentObject var store: AppStore
    
    var launch: AppState.LaunchViewState {
        store.state.launch
    }
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
            }
            ZStack{
                Image("launch_icon")
                Image("launch_title")
                    .padding(.top, 220)
            }
            Spacer()
            VStack{
                ProgressView(value: launch.progress)
            }
            .padding(.horizontal, 80)
            .padding(.bottom, 20)
        }
        .background(
            Image("launch_bg").resizable().ignoresSafeArea()
        )
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView().environmentObject(AppStore())
    }
}
