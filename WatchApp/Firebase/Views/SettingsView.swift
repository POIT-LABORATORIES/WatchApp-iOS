//
//  SettingsView.swift
//  WatchApp
//
//  Created by kirill on 06.04.2021.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            List {
                Text("Title color")
                Text("Font")
                Text("Set font")
            }
            .navigationBarTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
