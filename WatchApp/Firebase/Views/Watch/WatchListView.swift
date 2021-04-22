//
//  WatchListView.swift
//  WatchApp
//
//  Created by kirill on 02.04.2021.
//

import SwiftUI
import Combine

class WatchListViewModel: ObservableObject {
    
    @Published var watches = [FBWatch]()
    
    init(load: Bool) {
        if load {
            loadCollection()
        }
    }
    
    private func loadCollection() {
        FBFirestore.getCollection(collectionName: FBFirestore.Collection.watches) { documents in
            for data in documents {
                var watch = FBWatch(documentData: data)
                self.getImage(imageUrl: watch!.avatarUrl) { image in
                    watch?.avatar = image
                    self.watches.append(watch!)
                }
            }
        }
    }
    
    private func getImage(imageUrl: String, handler: @escaping (UIImage) -> Void) {
        var image: UIImage = UIImage()
        FBStorage.fetchImage(imageUrl: imageUrl) { data in
            image = UIImage(data: data)!
            handler(image)
        }
    }
}



struct WatchListView: View {
    
    @EnvironmentObject var userInfo: UserInfo;
    @State private var searchTerm: String = ""
    //@ObservedObject var watchList = WatchListViewModel(load: true)
    @EnvironmentObject var watchList: WatchListViewModel

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchTerm)
                
                NavigationLink(
                    destination: AddWatchView(watchCollection: self.$watchList.watches),
                    label: {
                        Image(systemName: "plus.square.fill")
                            .foregroundColor(.green)
                            .font(.system(size: 30))
                    })
                
                
                List(Array(watchList.watches.enumerated()).filter {
                    self.searchTerm.isEmpty ? true : $0.element.name.localizedCaseInsensitiveContains(self.searchTerm)
                }, id: \.element.id) { (i, _) in
                    WatchRowView(watch: self.$watchList.watches[i])
                }.navigationBarTitle(Text("Watch list"))
                .navigationBarItems(leading: Button("Log out") {
                    self.userInfo.isUserAuthenticated = .signedOut;
                })
            }
        }
    }
}


struct WatchListView_Previews: PreviewProvider {
    static var previews: some View {
        WatchListView()
    }
}

