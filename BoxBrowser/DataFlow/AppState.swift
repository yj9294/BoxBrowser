//
//  AppState.swift
//  BoxBrowser
//
//  Created by yangjian on 2022/11/23.
//

import Foundation

struct AppState {
    var root = RootViewState()
    var launch = LaunchViewState()
    var home = HomeViewState()
    var setting = SettingViewState()
    var ad = GoogleAdMoble()
}

extension AppState {
    struct RootViewState {
        enum Index {
            case launch, home
        }
        
        var selection: Index = .launch
        
        var isTabShow = false
        var isCleanShow = false
        var isSettingShow = false
        var isPrivacyShow = false
        var isTermsShow = false
        var isShareShow = false
        var isAlert = false
        var isCleanAlert = false
        
        var message: String = ""
    }
}

extension AppState {
    struct LaunchViewState {
        var progress = 0.0
        var duration = 2.5
    }
}

extension AppState {
    struct HomeViewState {
        enum Item: String, CaseIterable {
            case facebook, google, youtube, twitter, instagram, amazon, gmail, yahoo
            var title: String {
                return "\(self)".capitalized
            }
            var url: String {
                return "https://www.\(self).com"
            }
            var icon: String {
                return "home_\(self)"
            }
        }
        
        var text: String = ""
        
        var isLoading: Bool = false
        var progress: Double = 0.0
        var canGoBack: Bool = false
        var canGoForword: Bool = false
        var isNavigation: Bool = true
        
        var models: [HomeViewModel] = [.navigation]
        var adModel: NativeViewModel = .None
        var model: HomeViewModel {
            models.filter {
                $0.isSelect
            }.first ?? .navigation
        }
    }
}

extension AppState {
    struct SettingViewState{
        enum Item: String, CaseIterable{
            case new, share, copy, rate, terms, privacy
            var title: String {
                switch self {
                case .rate:
                    return "Rate Us"
                case .terms:
                    return "Terms of Use"
                case .privacy:
                    return "Privacy Policy"
                default:
                    return "\(self)".capitalized
                }
            }
            var icon: String{
                return "setting_\(self)"
            }
        }
        
        var terms: String = """
Terms of use
Whether you are a new or existing user of our products and services, we hope you will take some time to familiarize yourself with our Terms of Use.By using our software and services, you hereby agree to accept these terms. If you do not accept these terms, please do not use our software and services.
Use of the application
1. You accept that we are not responsible for third party content that you access using our applications.
2. You accept that we may discontinue some or all of our services at any time without prior notice to you.
3. You may not use our applications for unauthorized commercial purposes, and you may not use our applications and services for illegal purposes.
Update
We may update these terms. If you have any questions, please contact us
Contact us
If you have any questions about these terms and conditions, or would like to suggest improvements to us, please contact us.
 zx54873741@outlook.com   
"""
        var privacy: String = """
Privacy Policy
This Privacy Policy is to let you know what information we collect about you, how we use it, and how we share it. Whether you are a new user of our products and services, or an existing user, we hope you will take some time to familiarize yourself with our Privacy Policy.
Through this Privacy Policy, we explain to you what information we collect, what we do with it, and how we protect it. By using our software and services, you hereby agree to be bound by the terms of this Privacy Policy. If you do not accept this Privacy Policy, please do not use our software and services.
Information collection
In order to enhance the experience, we may collect some information about you. This collection is only done for legitimate purposes. We will never ask for any information that personally identifies you.
In order to download and use our software and services, when you download and use our software and websites and services, we receive some standard information that web browsers usually provide, such as: browser type, language preference, recommended websites, and the date and time of each visitor request.
If you get in touch with us for any reason, you will do so via email. During this process, we will collect your name and email address, as well as the content of the email sent to us
Information Collected Automatically. In order to make our service better for you, our servers (which may be hosted by third party service providers) will collect some information from you.
Information usage
Personal information submitted to us is used to respond to user feedback and requests, and to help optimize the services provided to you. Personal information may be used in the following ways.
To improve our browser service experience.
To check and fix potential problems
Improve browser functionality or develop new features based on your feedback and needs
Provide your information to third parties, if we are obliged to do so by law.
Information sharing
We will only share your information in accordance with this Privacy Policy. We are committed to protecting your personal information and keeping it secure. We will not sell or rent your personal information to prevent any unauthorized access, use, dissemination or disclosure. We have established strict procedures and restrictions on who has access to user data.
We may share your personal information internally. We may share your personal information with trusted partners or service providers. We do not control or influence the use and privacy policies of these third parties with whom we work. If you need to know their privacy policies, please visit their websites.
We may provide your personal information to relevant law enforcement agencies or government departments in order to enforce or assist in certain legal proceedings.
Update
We may revise, update and change our privacy policy from time to time. By using and continuing to use our software and services, you indicate your acceptance of our updated Privacy Policy. If at any time you do not agree to the terms of our Privacy Policy, then you should not use our Software and/or our Services.
Contact us
If you have questions about our privacy policy or would like to suggest improvements to us, please contact us. You can contact us.
zx54873741@outlook.com
"""
    }
}

extension AppState {
    struct Firebase {
        enum Property: String {
            /// 設備
            case local = "w_5"
            
            var first: Bool {
                switch self {
                case .local:
                    return true
                }
            }
        }
        
        enum Event: String {
            
            var first: Bool {
                switch self {
                case .open:
                    return true
                default:
                    return false
                }
            }
            
            case open = "e_5"
            case openCold = "r_5"
            case openHot = "h_5"
            case homeShow = "u_5"
            case homeShowNavigation = "i_5"
            case homeNavigationClick = "o_5"
            case homeSearchClick = "p_5"
            case homeCloseClick = "z_5"
            case cleanAnimation = "x_5"
            case cleanAlert = "c_5"
            case tabShow = "b_5"
            case tabNew = "v_5"
            case shareClick = "n_5"
            case copyClick = "m_5"
            
            case loading = "k_5"
            case loaded = "ll_5"
        }
    }
}


extension AppState {
    struct GoogleAdMoble{

        @UserDefault(key: "state.ad.config")
        var config: GADConfigModel?
       
        @UserDefault(key: "state.ad.limit")
        var limit: GADLimitModel?
        
        var impressionDate:[GADPosition.Position: Date] = [:]
        
        let ads:[GADLoadModel] = GADPosition.allCases.map { p in
            GADLoadModel(position: p)
        }.filter { m in
            m.position != .all
        }
        
        func isLoaded(_ position: GADPosition) -> Bool {
            return self.ads.filter {
                $0.position == position
            }.first?.isLoaded == true
        }

        func isLimited(in store: AppStore) -> Bool {
            if limit?.date.isToday == true {
                if (store.state.ad.limit?.showTimes ?? 0) >= (store.state.ad.config?.showTimes ?? 0) || (store.state.ad.limit?.clickTimes ?? 0) >= (store.state.ad.config?.clickTimes ?? 0) {
                    return true
                }
            }
            return false
        }
    }
}

extension Date {
    var isExpired: Bool {
        Date().timeIntervalSince1970 - self.timeIntervalSince1970 > 3000
    }
    
    var isToday: Bool {
        let diff = Calendar.current.dateComponents([.day], from: self, to: Date())
        if diff.day == 0 {
            return true
        } else {
            return false
        }
    }
}
