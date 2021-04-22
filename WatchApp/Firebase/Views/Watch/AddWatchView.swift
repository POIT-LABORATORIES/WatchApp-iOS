//
//  AddWatchView.swift
//  WatchApp
//
//  Created by kirill on 28.03.2021.
//

import SwiftUI

struct AddWatchView: View {
    
    @State var isLoading = false
    @State private var isShowingImagePicker = false
    @State private var image: UIImage = UIImage()
    @State private var watch: FBWatch = FBWatch()
    @Binding var watchCollection: [FBWatch]
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
                    
                    Image(uiImage: image)
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
                        ImagePickerView(isPresented: self.$isShowingImagePicker, selectedImage: self.$image)
                    })
        
                    VStack {
                        Group {
                            TextField("Name", text: self.$watch.name)
                                .autocapitalization(.words)
                            
                            TextField("Style", text: self.$watch.style)
                                .autocapitalization(.words)
                            
                            TextField("Case material", text: self.$watch.caseMaterial)
                                .autocapitalization(.words)
                            
                            TextField("Case color", text: self.$watch.caseColor)
                                .autocapitalization(.words)
                            
                            TextField("Description", text: self.$watch.description)
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
                                FBImage.uploadImage(image: self.image, imageName: "\(self.watch.name)-avatar") { (imageUrl) in
                                    self.watch.avatarUrl = imageUrl
                                    self.watch.avatar = self.image
                                    print("Image is downloaded, url = \(self.watch.avatarUrl)")
                                    self.watch.id = UUID().uuidString
                                    let data = self.watch.dataDict()
                                    
                                    FBFirestore.mergeData(data: data, collection: "watches", document: self.watch.id) { (isMerged) in
                                        self.isLoading = false
                                        
                                        if isMerged {
                                            // Append new item to existing watch collection.
                                            watchCollection.append(self.watch)
                                            self.presentationMode.wrappedValue.dismiss()
                                        }
                                    }
                                }
                            }) {
                                Text("Create")
                                    .frame(width: 200)
                                    .padding(.vertical, 15)
                                    .background(Color.green)
                                    .cornerRadius(8)
                                    .foregroundColor(.white)
                            }
                            .disabled(self.isLoading)
                            
                        }
                    }
                    .padding(.bottom)
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

struct AddWatchView_Previews: PreviewProvider {
    
    @State static var collection: [FBWatch] = []
    
    static var previews: some View {
        AddWatchView(watchCollection: $collection)
    }
}


struct ImagePickerView: UIViewControllerRepresentable {
    
    @Binding var isPresented: Bool
    @Binding var selectedImage: UIImage
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePickerView>) -> UIViewController {
        let controller = UIImagePickerController()
        controller.delegate = context.coordinator
        return controller
    }
    
    func makeCoordinator() -> ImagePickerView.Coordinator {
        return Coordinator(parent: self)
    }
    
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        let parent: ImagePickerView
        
        init(parent: ImagePickerView) {
            self.parent = parent
        }
        
        // Notify when the image is selected
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                print(selectedImage)
                self.parent.selectedImage = selectedImage
            }
            
            // Close ImagePickerView
            self.parent.isPresented = false
        }
        
    }
    
    
    func updateUIViewController(_ uiViewController: ImagePickerView.UIViewControllerType, context: UIViewControllerRepresentableContext<ImagePickerView>) {
        
    }
}
