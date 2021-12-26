//
//  FileStorage.swift
//  Just-Talk
//
//  Created by AryafAlaqabali on 20/05/1443 AH.
//

import Foundation
import UIKit
import ProgressHUD
import FirebaseStorage


let storage = Storage.storage()

class FileStorage {
    
    //MARK:- Images
    class func uploadeImage (_ image: UIImage, directory: String, completion: @escaping (_ documentLink: String?)-> Void) {
        
        //1. Create folder on firestore
        let storageRef = storage.reference(forURL: kFILEREFERENCE).child(directory)
        
        //2. Convert the image to data
        let imageData = image.jpegData(compressionQuality: 0.5)
        
        //3. Put the data into firestore and return the link
        var task : StorageUploadTask!
        
        task = storageRef.putData(imageData!, metadata: nil, completion: { (metadata, error) in
            task.removeAllObservers()
            ProgressHUD.dismiss()
            
            if error != nil {
                print("Error uploading image \(error!.localizedDescription)")
            }
            storageRef.downloadURL { (url, error) in
                
                
                guard let downloadUrl = url else {
                    completion (nil)
                    return
                    
                }
                completion(downloadUrl.absoluteString)
            }
        })
        //4. Observe percentage uplaod
        task.observe(StorageTaskStatus.progress) { (snapshot) in
            
            let progress = snapshot.progress!.completedUnitCount /
            snapshot.progress!.totalUnitCount
            
            ProgressHUD.showProgress(CGFloat(progress))
        }
        
        
    }
    
    class func downloadImage(imageUrl: String, completion: @escaping (_ image: UIImage?)->Void) {
       
        
        let imageFileName = fileNameFrom(fileUrl: imageUrl)
        
        if fileExistsAtPath(path: imageFileName) {
            if let contentsOfFile = UIImage(contentsOfFile: fileInDocumentsDirectory(fileName: imageFileName)) {
                completion (contentsOfFile)
            }else {
                
                print("could not convert local image")
                completion(UIImage(named: "profail")!)
            }
            //get it locally
        }else{
            if imageUrl != "" {
                 let documentUrl = URL(string: imageUrl)
                let downloadQueue = DispatchQueue (label: "imageDownloadQueue")
                
                downloadQueue.async {
                    let data = NSData(contentsOf: documentUrl!)
                    if data != nil {
                        
                        FileStorage.saveFileLocally(fileData: data!, fileName: imageFileName)
                        DispatchQueue.main.async {
completion(UIImage(data: data! as Data))
                        }
                        
                    }else {
                        print("no document found in database")
                        completion(nil)
                    }
                }
            }
        }
        
        
        
    }
    //MARK:- Save file locally
    class func saveFileLocally (fileData: NSData, fileName: String) {
        let docUrl  = getDocumentURL().appendingPathComponent(fileName, isDirectory: false)
        
        fileData.write(to: docUrl, atomically: true)
    }
    
    
    
}


//Helpers

func getDocumentURL() -> URL {
    
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
}

func fileInDocumentsDirectory(fileName: String) -> String {
    
    return getDocumentURL().appendingPathComponent(fileName).path
}

func fileExistsAtPath(path: String) -> Bool {
    
    return FileManager.default.fileExists(atPath: fileInDocumentsDirectory(fileName: path))
}
