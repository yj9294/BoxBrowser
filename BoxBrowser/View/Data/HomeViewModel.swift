//
//  HomeViewModel.swift
//  BoxBrowser
//
//  Created by yangjian on 2022/11/23.
//

import Combine
import WebKit
import Foundation

class HomeViewModel: NSObject, ObservableObject {
    init(webView: WKWebView, isSelect: Bool) {
        self.webView = webView
        self.isSelect = isSelect
    }
    var webView: WKWebView
    var isSelect: Bool
    var isNavigation: Bool {
        return webView.url == nil
    }
    
    static func == (lhs: HomeViewModel, rhs: HomeViewModel) -> Bool {
        return lhs.webView == rhs.webView
    }
}

extension HomeViewModel {
    static var navigation: HomeViewModel {
        let webView = WKWebView()
        webView.backgroundColor = .clear
        webView.isOpaque = false
        return HomeViewModel(webView: webView, isSelect: true)
    }
    
    func load(_ url: String) {
        webView.navigationDelegate = self
        if url.isUrl, let Url = URL(string: url) {
            let request = URLRequest(url: Url)
            webView.load(request)
        } else {
            let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let reqString = "https://www.google.com/search?q=" + urlString
            self.load(reqString)
        }
    }
    
    func stopLoad() {
        webView.stopLoading()
    }
    
    func goBack() {
        webView.goBack()
    }
    
    func goForword() {
        webView.goForward()
    }
}

extension HomeViewModel: WKNavigationDelegate, WKUIDelegate {
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        webView.load(navigationAction.request)
        return nil
    }
}
