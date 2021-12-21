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
}

func FirebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference {
    return Firestore.firestore().collection(collectionReference.rawValue)
    
}

