//
//  HomeView.swift
//  WatchApp
//
//  Created by kirill on 22.03.2021.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var userInfo: UserInfo;
    
    var body: some View {
        TabView {
            WatchListView()
                .tabItem {
                    VStack {
                        Image(systemName: "list.bullet")
                        Text("List")
                    }
                    
                }
            MapView()
                .tabItem {
                    VStack {
                        Image(systemName: "mappin.and.ellipse")
                        Text("Map")
                    }
                }
            SettingsView()
                .tabItem {
                    VStack {
                        Image(systemName: "gearshape")
                        Text("Settings")
                    }
                }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
