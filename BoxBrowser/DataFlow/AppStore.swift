//
//  AppStore.swift
//  BoxBrowser
//
//  Created by yangjian on 2022/11/23.
//

import Foundation
import Combine

class AppStore: ObservableObject {
    @Published var state = AppState()
    var disposeBag = [AnyCancellable]()
    
    init(){
        commonInit()
    }
    
    private func commonInit() {
        dispatch(.adRequestConfig)
        dispatch(.launching)
        dispatch(.webview)
        
        dispatch(.logP(.local))
        dispatch(.logE(.open))
        dispatch(.logE(.openCold))
    }
    
    public func dispatch(_ action: AppAction) {
        debugPrint("[ACTION]: \(action)")
        let result = AppStore.reduce(state: state, action: action)
        state = result.0
        if let command = result.1 {
            debugPrint("[COMMAND]: \(command)")
            command.execute(in: self)
        }
    }
}

extension AppStore{
    private static func reduce(state: AppState, action: AppAction) -> (AppState, AppCommand?) {
        var appState = state
        var appCommand: AppCommand? = nil
        
        switch action {
        case .webview:
            appCommand = WebViewCommand()
        case .hideKeyboard:
            appCommand = HideKeyboardCommand()
        case .alert(let message):
            appState.root.message = message
            appState.root.isAlert = true
        case .dismiss:
            appCommand = DismissCommand()
            
        case .launching:
            appState.launch.progress = 0
            appState.root.selection = .launch
            appCommand = LaunchCommand()
        case .launchProgress(let double):
            appState.launch.progress = double
            if double >= 1.0 {
                appState.launch.progress = 1.0
            }
        case .launchDuration(let duration):
            appState.launch.duration = duration
        case .launched:
            appState.root.selection = .home
            
        case .homeText(let text):
            appState.home.text = text
        case .homeSearch:
            appCommand = HomeSearchCommand()
        case .homeStopSearch:
            appCommand = HomeStopSearchCommand()
        case .homeGoBack(let isGoBack):
            appCommand = HomeGoCommand(isGoback: isGoBack)
            
            
        case .homeCanGoBack(let ret):
            appState.home.canGoBack = ret
        case .homeCanGoForword(let ret):
            appState.home.canGoForword = ret
        case .homeProgress(let progress):
            appState.home.progress = progress
        case .homeNaivgation(let ret):
            appState.home.isNavigation = ret
        case .homeLoading(let ret):
            appState.home.isLoading = ret
            
        case .tabShow(let isShow):
            appState.root.isTabShow = isShow
        case .cleanShow(let isShow):
            appState.root.isCleanShow = isShow
        case .settingShow(let isShow):
            appState.root.isSettingShow = isShow
        case .privacyShow(let isShow):
            appState.root.isPrivacyShow = isShow
        case .termsShow(let isShow):
            appState.root.isTermsShow = isShow
        case.shareShow(let isShow):
            appState.root.isShareShow = isShow
        case .cleanAlertShow(let isShow):
            appState.root.isCleanAlert = isShow
            
        case .tabNew:
            appState.home.models.forEach {
                $0.isSelect = false
            }
            appState.home.models.insert(.navigation, at: 0)
        case .tabSelect(let model):
            appState.home.models.forEach {
                $0.isSelect = false
            }
            model.isSelect = true
        case .tabDelete(let model):
            if model.isSelect {
                appState.home.models = appState.home.models.filter({
                    !$0.isSelect
                })
                appState.home.models.first?.isSelect = true
            } else {
                appState.home.models = appState.home.models.filter({
                    $0.webView != model.webView
                })
            }
        case .tabClean:
            appState.home.models = [.navigation]
            
        case .settingCopy:
            appCommand = SettingCopyCommand()
            
        case .logP(let property, let value):
            appCommand = FirebasePropertyCommand(property, value)
        case .logE(let event, let params):
            appCommand = FirebaseEvnetCommand(event, params)
            
        case .adRequestConfig:
            appCommand = GADRequestConfigCommand()
        case .adUpdateConfig(let config):
            appState.ad.config = config
        case .adUpdateLimit(let state):
            appCommand = GADLimitedCommand(state)
        case .adAppear(let position):
            appCommand = GADAppearCommand(position)
        case .adDisappear(let position):
            appCommand = GADDisappearCommand(position)
        case .adClean(let position):
            appCommand = GADCleanCommand(position)
        
        case .adLoad(let position, let p):
            appCommand = GADLoadCommand(position, p)
        case .adShow(let position, let p, let completion):
            appCommand = GADShowCommand(position, p, completion)
            
        case .adNativeImpressionDate(let p):
            appState.ad.impressionDate[p] = Date()
        case .homeAdModel(let model):
            appState.home.adModel = model
            
        case .clean:
            appCommand = CleanCommand()
        }

        
        return (appState, appCommand)
    }
}
