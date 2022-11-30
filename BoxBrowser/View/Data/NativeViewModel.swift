//
//  NativeViewModel.swift
//  BoxBrowser
//
//  Created by yangjian on 2022/11/25.
//

import Foundation

class NativeViewModel: NSObject {
    let ad: GADNativeModel?
    let view: UINativeAdView
    init(ad: GADNativeModel? = nil, view: UINativeAdView) {
        self.ad = ad
        self.view = view
        self.view.refreshUI(ad: ad?.nativeAd)
    }
    
    static var None:NativeViewModel {
        NativeViewModel(view: UINativeAdView())
    }
}
