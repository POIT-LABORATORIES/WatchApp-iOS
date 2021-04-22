//
//  WatchView.swift
//  WatchApp
//
//  Created by kirill on 28.03.2021.
//

import SwiftUI

struct WatchView: View {
    
    @Binding var watch: FBWatch
    
    var body: some View {
        ZStack {
            Color(.orange)
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            ScrollView(.vertical) {
                VStack {
                    Spacer()
                    WatchImageView(watch: $watch)
                    
                    Spacer()
                    CardView(watch: $watch)
                }
            }
        }
    }
}

struct WatchView_Previews: PreviewProvider {
    
    @State static var watch: FBWatch = FBWatch()
    
    static var previews: some View {
        WatchView(watch: $watch)
    }
}

struct WatchImageView: View {
    
    @Binding var watch: FBWatch
    
    var body: some View {
        TabView {
            ForEach(0 ..< 5) { _ in
                Image(uiImage: watch.avatar)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .padding()
        }
        .frame(width: UIScreen.main.bounds.width)
        .tabViewStyle(PageTabViewStyle())
    }
}


struct CardView: View {
    
    @Binding var watch: FBWatch
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text(watch.name)
                    .font(.title)
                    .fontWeight(.bold)
            }
            .padding(.top)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Group {
                HStack {
                    Text("Style: ")
                        .fontWeight(.bold)
                    
                    Text(watch.style)
                }
                
                HStack {
                    Text("Case material: ")
                        .fontWeight(.bold)
                    
                    Text(watch.caseMaterial)
                }
                
                HStack {
                    Text("Case color: ")
                        .fontWeight(.bold)
                    
                    Text(watch.caseColor)
                }
                
                VStack {
                    Text("Description: ")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(watch.description)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.top)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        
            NavigationLink(
                destination: EditWatchView(watch: $watch),
                label: {
                    Image(systemName: "pencil.circle")
                        .foregroundColor(.green)
                        .font(.system(size: 40))
                })
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(30)
    }
}
