//
//  MapView.swift
//  WatchApp
//
//  Created by kirill on 02.04.2021.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @EnvironmentObject var watchList: WatchListViewModel
    @State private var region = MKCoordinateRegion(

        center: CLLocationCoordinate2D(latitude: 34.011_286, longitude: -116.166_868),

        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)

    )
    
    var body: some View {
        
        Map(coordinateRegion: $region, annotationItems: watchList.watches) { place in
            MapAnnotation(coordinate: place.coordinate) {
                Group {
                    Image(systemName: "mappin.circle.fill")
                      .resizable()
                      .frame(width: 30.0, height: 30.0)
                    Circle()
                      .frame(width: 8.0, height: 8.0)
                }
                .foregroundColor(.red)
                Text(place.name)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
