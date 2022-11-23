//
//  AppAction.swift
//  BoxBrowser
//
//  Created by yangjian on 2022/11/23.
//

import Foundation

enum AppAction {
    
    case webview
    case hideKeyboard
    case alert(String)
    
    case launching
    case launchProgress(Double)
    case launched
    
    case homeText(String)
    case homeSearch
    case homeStopSearch
    case homeCanGoBack(Bool)
    case homeCanGoForword(Bool)
    case homeProgress(Double)
    case homeNaivgation(Bool)
    case homeLoading(Bool)
    case homeGoBack(Bool)
    
    case tabShow(Bool)
    case cleanShow(Bool)
    case cleanAlertShow(Bool)
    case settingShow(Bool)
    case privacyShow(Bool)
    case termsShow(Bool)
    case shareShow(Bool)
    
    
    case tabNew
    case tabSelect(HomeViewModel)
    case tabDelete(HomeViewModel)
    case tabClean
    
    case settingCopy
    
    case logP(AppState.Firebase.Property, String? = nil)
    case logE(AppState.Firebase.Event, [String: String]? = nil)
}
