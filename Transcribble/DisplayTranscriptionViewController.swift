//
//  DisplaySavedTranscriptionViewController.swift
//  Transcribble
//
//  Created by Ananya Bhat on 7/10/17.
//  Copyright © 2017 Ananya Bhat. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import AVFoundation
import AVKit
import Speech

enum SpeechStatus {
    case ready
    case recognizing
    case unavailable
}

class DisplayTranscriptionViewController: UIViewController, AVAudioPlayerDelegate {
    
   
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var pauseButton: UIButton!
    
    
    @IBOutlet weak var audioSlider: UISlider!
    
    var files : [Audio] = []   
    var dataRecieved : Int = 0
    var audioPlayer = AVAudioPlayer()
    
    var localURL : URL!
    
    var transcription : String = ""
    
    var status = SpeechStatus.ready

    @IBOutlet weak var noteTitle: UINavigationItem!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        noteTitle.title = files[dataRecieved].title
        
        self.playButton.isHidden = false
        self.pauseButton.isHidden = true

        
        switch SFSpeechRecognizer.authorizationStatus() {
        case .notDetermined:
            askSpeechPermission()
        case .authorized:
            self.status = .ready
        case .denied, .restricted:
            self.status = .unavailable
        }
        setTextView()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func askSpeechPermission() {
        SFSpeechRecognizer.requestAuthorization { status in
            OperationQueue.main.addOperation {
                switch status {
                case .authorized:
                    self.status = .ready
                default:
                    self.status = .unavailable
                }
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var preRecordedAudioURL: URL = {
        return Bundle.main.url(forResource: "sound", withExtension: "m4a")!
    }()
    
    func downloadAudio() -> URL {
        let dispatchGroup = DispatchGroup()
        var voiceNoteToDownload = files[dataRecieved].link
        
        
        dispatchGroup.notify(queue: .main) {
            let downloadRef = Storage.storage().reference().child("vn").child("\(User.current.uid)/\(voiceNoteToDownload).m4a")
            
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            self.localURL = documentsURL.appendingPathComponent("voicememos/\(voiceNoteToDownload).m4a")
            print("LOOK A URL:\(self.localURL)")
            
            let downloadTask = downloadRef.write(toFile: self.localURL, completion: { (url, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                

                
            })
        }
        
        return localURL
    }
    
    
    func setUpAudio() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
            
            localURL = downloadAudio()
            print("localURL: \(localURL)")
            
            let audiodata = try Data(contentsOf: self.localURL)
            
            self.audioPlayer = try AVAudioPlayer(data:audiodata)
            
            self.audioPlayer.delegate = self as! AVAudioPlayerDelegate
            
            self.audioPlayer.prepareToPlay()
            
            self.audioPlayer.volume = 1.5
        
            print("Audio ready to play")
            
        } catch let error {
            print(error.localizedDescription)
        }
        

    }
    
    func setTextView(){
        if (files[dataRecieved].transcription == "" ){
            textView.text = "Please wait, your recording is being transcribed"
            localURL = downloadAudio()
            self.recognizeFile(url: self.localURL)
        }else{
            textView.text = files[dataRecieved].transcription
        }
    }
    
    func recognizeFile(url: URL) {
        //print("ARE YOU COMING HERE?")
        guard let recognizer = SFSpeechRecognizer(), recognizer.isAvailable else {
            return
        }
        
        let request = SFSpeechURLRecognitionRequest(url: url)
        recognizer.recognitionTask(with: request) { result, error in

            if let result = result {
                self.transcription = result.bestTranscription.formattedString
                self.textView.text = self.transcription
                if result.isFinal {
                    self.textView.textColor = UIColor.black
                    self.transcription = result.bestTranscription.formattedString
                    self.textView.text = self.transcription
                    

                    let ref = Database.database().reference().child("posts").child("\(User.current.uid)").child("\(self.files[self.dataRecieved].title)").child("transcription")
                    ref.setValue(self.transcription)
                }
            } else if let error = error {
                print(error)
            }
        }
    }

    
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        self.playButton.isHidden = true
        self.pauseButton.isHidden = false
        setUpAudio()
        self.audioPlayer.play()
    }
    
    @IBAction func pauseButtonTapped(_ sender: UIButton) {
        setUpAudio()
        self.playButton.isHidden = false
        self.pauseButton.isHidden = true
        self.audioPlayer.pause()
    }
    
    
    
    
    func updateSlider() {
        audioSlider.value = Float(audioPlayer.currentTime)
    }
    
    //hello
    
}
