//
//  SplashScreenView.swift
//  677676 Pokedex App
//
import SwiftUI

struct SplashScreenView: View {
    @State private var logoScale: CGFloat = 0.8
    @State private var logoOpacity: Double = 0.5

    var body: some View {
        ZStack {
            Color(.white)
                .edgesIgnoringSafeArea(.all)

            Image("logo.svg")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .scaleEffect(logoScale)
                .opacity(logoOpacity)
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.5)) {
                        logoScale = 1.0
                        logoOpacity = 1.0
                    }
                }
        }
    }
}
