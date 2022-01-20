//
//  FColloctionReferenc.swift
//  Just-Talk
//
//  Created by AryafAlaqabali on 16/05/1443 AH.
//

import Foundation
import Firebase

enum FCollectionReference: String{
    case User
    case Chat
    case Message
    case Typing
    
}

func FirestoreReference(_ collectionReference: FCollectionReference) -> CollectionReference {
    return Firestore.firestore().collection(collectionReference.rawValue)
    
}

