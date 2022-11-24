//
//  HomeViewModifier.swift
//  BoxBrowser
//
//  Created by yangjian on 2022/11/23.
//

import SwiftUI

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

extension View {
    @MainActor
    func alert(title: String, isPresent: Binding<Bool>) -> some View {
        ZStack{
            self
            if isPresent.wrappedValue {
                Color(hex: 0x333333, alpha: 0.6).ignoresSafeArea()
                Text(title).padding(.all, 16)
                    .background(Color.white.cornerRadius(8))
                    .foregroundColor(.blue)
                    .onAppear{
                        Task{
                            if !Task.isCancelled {
                                try await Task.sleep(nanoseconds: 2_000_000_000)
                                isPresent.wrappedValue.toggle()
                            }
                        }
                    }
            }
        }
    }
}
