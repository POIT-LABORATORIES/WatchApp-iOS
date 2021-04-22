//
//  WatchRowView.swift
//  WatchApp
//
//  Created by kirill on 03.04.2021.
//

import SwiftUI

struct WatchRowView: View {
    
    @Binding var watch: FBWatch
    
    var body: some View {
        HStack {
            Image(uiImage: watch.avatar)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .clipped()
            VStack {
                Text(watch.name)
                Text(watch.style)
                Text(watch.caseMaterial)
            }
            NavigationLink(
                destination: WatchView(watch: $watch),
                label: {})
        }
    }
}

struct WatchRowView_Previews: PreviewProvider {
    
    @State static var watch = FBWatch()
    
    static var previews: some View {
        WatchRowView(watch: $watch)
    }
}
