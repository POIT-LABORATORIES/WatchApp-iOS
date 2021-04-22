import FirebaseFirestore

enum FBFirestore {
    
    enum Collection {
        static let watches = "watches"
    }
    
    static func updateDocument(collection: String, document: String, data: [String: Any], handler: @escaping (Bool) -> Void) {
        let docRef = Firestore.firestore().collection(collection).document(document)
        
        docRef.updateData(data) { err in
            if let err = err {
                print("Error updating document: \(err.localizedDescription)")
                handler(false)
            } else {
                print("Document successfully updated")
                handler(true)
            }
        }
    }
    
    static func getCollection(collectionName: String, handler: @escaping ([[String: Any]]) -> Void) {
        let reference = Firestore.firestore().collection(collectionName)
        var documents = [[String: Any]]()
        reference.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                handler([[:]])
            } else {
                for document in querySnapshot!.documents {
                    documents.append(document.data())
                }
                handler(documents)
            }
        }
    }

    static func retrieveFBUser(uid: String, completion: @escaping (Result<FBUser, Error>) -> ()) {
        let reference = Firestore
            .firestore()
            .collection(FBKeys.CollectionPath.users)
            .document(uid)
        getDocument(for: reference) { (result) in
            switch result {
            case .success(let data):
                guard let user = FBUser(documentData: data) else {
                    completion(.failure(FireStoreError.noUser))
                    return
                }
                completion(.success(user))
            case .failure(let err):
                completion(.failure(err))
            }
        }
        
    }
    
    static func mergeFBUser(_ data: [String: Any], uid: String, completion: @escaping (Result<Bool, Error>) -> ()) {
        let reference = Firestore
            .firestore()
            .collection(FBKeys.CollectionPath.users)
            .document(uid)
        reference.setData(data, merge: true) { (err) in
            if let err = err {
                completion(.failure(err))
                return
            }
            completion(.success(true))
        }
    }
    
    
    fileprivate static func getDocument(for reference: DocumentReference, completion: @escaping (Result<[String : Any], Error>) -> ()) {
        reference.getDocument { (documentSnapshot, err) in
            if let err = err {
                completion(.failure(err))
                return
            }
            guard let documentSnapshot = documentSnapshot else {
                completion(.failure(FireStoreError.noDocumentSnapshot))
                return
            }
            guard let data = documentSnapshot.data() else {
                completion(.failure(FireStoreError.noSnapshotData))
                return
            }
            completion(.success(data))
        }
    }
    
    
    static func mergeData(data: [String: Any], collection: String, document: String, handler: @escaping (Bool) -> Void) {
        let reference = Firestore.firestore().collection(collection).document(document)
        reference.setData(data, merge: true) { (err) in
            if let err = err {
                print("Cannot upload document, message: \(err.localizedDescription)")
                handler(false)
                return
            }
            print("Document is uploaded")
            handler(true)
        }
    }
}
