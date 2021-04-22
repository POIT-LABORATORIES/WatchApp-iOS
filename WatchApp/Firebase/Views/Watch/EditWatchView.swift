//
//  EditWatchView.swift
//  WatchApp
//
//  Created by kirill on 05.04.2021.
//

import SwiftUI

struct EditWatchView: View {
    
    @State private var isLoading = false
    @State private var isShowingImagePicker = false
    @Binding var watch: FBWatch
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        let latitudeProxy = Binding<String>(
            get: { String(format: "%.03f", Double(self.watch.latitude)) },
            set: {
                if let value = NumberFormatter().number(from: $0) {
                    self.watch.latitude = value.doubleValue
                }
            }
        )
        let longitudeProxy = Binding<String>(
            get: { String(format: "%.03f", Double(self.watch.longitude)) },
            set: {
                if let value = NumberFormatter().number(from: $0) {
                    self.watch.longitude = value.doubleValue
                }
            }
        )
        
        ScrollView(.vertical) {
            ZStack {
                VStack {
                    
                    Image(uiImage: watch.avatar)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                        .border(Color.black, width: 1)
                        .clipped()
                    
                    
                    Button(action: {
                        self.isShowingImagePicker.toggle()
                    }, label: {
                        Text("Select image")
                            .font(.system(size: 26))
                    })
                    .sheet(isPresented: $isShowingImagePicker, content: {
                        ImagePickerView(isPresented: self.$isShowingImagePicker, selectedImage: self.$watch.avatar)
                    })
        
                    VStack {
                        Group {
                            TextField(self.watch.name, text: self.$watch.name)
                                .autocapitalization(.words)
                            
                            TextField(self.watch.style, text: self.$watch.style)
                                .autocapitalization(.words)
                            
                            TextField(self.watch.caseMaterial, text: self.$watch.caseMaterial)
                                .autocapitalization(.words)
                            
                            TextField(self.watch.caseColor, text: self.$watch.caseColor)
                                .autocapitalization(.words)
                            
                            TextField(self.watch.description, text: self.$watch.description)
                                .autocapitalization(.words)
                            
                            TextField("Latitude", text: latitudeProxy)
                                .textContentType(.location)
                                .keyboardType(.decimalPad)
                            
                            TextField("Longitude", text: longitudeProxy)
                                .textContentType(.location)
                                .keyboardType(.decimalPad)
                        }.padding(5)
                        
                        
                        VStack(spacing: 20 ) {
                            Button(action: {
                                self.isLoading = true
                                FBImage.uploadImage(image: self.watch.avatar, imageName: "\(self.watch.name)-avatar") { (imageUrl) in
                                    self.watch.avatarUrl = imageUrl
                                    
                                    print("Image is downloaded, url = \(self.watch.avatarUrl)")
                                    
                                    let data = self.watch.dataDict()
                                    
                                    FBFirestore.updateDocument(collection: FBFirestore.Collection.watches, document: self.watch.id, data: data) { isUpdated in
                                        self.isLoading = false
                                        
                                        if isUpdated {
                                            self.presentationMode.wrappedValue.dismiss()
                                        }
                                    }
                                }
                            }) {
                                Text("Save")
                                    .frame(width: 200)
                                    .padding(.vertical, 15)
                                    .background(Color.blue)
                                    .cornerRadius(8)
                                    .foregroundColor(.white)
                            }
                            .disabled(self.isLoading)
                            
                        }
                    }.padding(.bottom)
                    .frame(width: 350)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                }
                
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .red))
                        .scaleEffect(3)
                        .padding()
                }
            }
        }
        
    }
}

struct EditWatchView_Previews: PreviewProvider {
    
    @State static var editedWatch: FBWatch = FBWatch()
    
    static var previews: some View {
        EditWatchView(watch: $editedWatch)
    }
}
