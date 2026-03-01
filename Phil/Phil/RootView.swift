//
//  RootView.swift
//  Phil
//
//  Placeholder root view. Will be replaced by AppCoordinator-driven navigation
//  once auth and feature modules are wired.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Image(systemName: "figure.run.circle")
                    .font(.system(size: 64))
                    .foregroundStyle(.blue)

                Text("Philoctetes")
                    .font(.system(size: 28, weight: .bold, design: .rounded))

                Text("Health & Fitness Tracking")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    RootView()
}
