//
//  RecorderService.swift
//  VoiceMeter
//
//  Created by Arkadiusz Jachnik on 28.12.2016.
//  Copyright © 2016 Arkadiusz Jachnik. All rights reserved.
//

import Foundation
import AVFoundation

class VoiceMeterService : NSObject, AVAudioRecorderDelegate {
    var isRecording : Bool = false
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var timer: Timer?
    
    override init() {
        recordingSession = AVAudioSession.sharedInstance()
        timer = Timer()
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryRecord)
            try recordingSession.setActive(true)
        } catch {
            print("Filed to record")
        }
    }
    
    func startRecording() {
        recordingSession.requestRecordPermission() { [unowned self] allowed in
            DispatchQueue.main.async {
                if allowed {
                    print("It is allowed")
                }
                else {
                    print("It is not allowed")
                }
            }
        }
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true;
            audioRecorder.prepareToRecord()
            audioRecorder.record()
        } catch {
            finishRecording(success: false)
        }
    }
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
    }
    
    func sampleRecord() -> Float {
        audioRecorder.updateMeters()
        return audioRecorder.averagePower(forChannel: 0)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
}
