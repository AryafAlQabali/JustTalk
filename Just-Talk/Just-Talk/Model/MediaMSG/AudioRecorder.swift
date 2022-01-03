//
//  AudioRecorder.swift
//  Just-Talk
//
//  Created by AryafAlaqabali on 30/05/1443 AH.
//

import Foundation
import AVFoundation
// مازبطت

class AudioRecorder: NSObject, AVAudioRecorderDelegate {
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var isAudioRecordingGranted: Bool!
    
    
    static let shared = AudioRecorder()
    
    private override init() {
        super.init()
        checkForRecordPermission()
    }
    
    //صلاحيات موافقه المستخدم
    func checkForRecordPermission() {
        switch AVAudioSession.sharedInstance().recordPermission {
        
        case .granted:
            isAudioRecordingGranted = true
            break
        case .denied:
            isAudioRecordingGranted = false
            break
            
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { (isAllowed) in
                
                self.isAudioRecordingGranted = isAllowed
            }
            
        default:
            break
        
        }
        
    }
    
    func setupRecorder() {
        
        if isAudioRecordingGranted {
            recordingSession = AVAudioSession.sharedInstance()
            
            do {
                try recordingSession.setCategory(.playAndRecord, mode: .default)
                try recordingSession.setActive(true)
                
            } catch {
                print (" Error setting up audio recording session", error.localizedDescription)
            }
            
        }
        
    }
    
    func startRecording(fileName: String) {
        
        let audioFileName = getDocumentURL().appendingPathComponent(fileName + ".m4a", isDirectory: false)
        
        let settings = [
        // من النت
            AVFormatIDKey : Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        
        ]
        
        do {
            
            audioRecorder = try AVAudioRecorder(url: audioFileName, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            
        } catch {
            print ("Error recording", error.localizedDescription)
            finishRecording()
        }
        
        
        
    }
    
    func finishRecording() {
        if audioRecorder != nil {
            audioRecorder.stop()
            audioRecorder = nil
        }
        
    }
    
}
