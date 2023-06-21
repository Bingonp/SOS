//
//  ViewController.swift
//  SOS
//
//  Created by Neha Patil on 6/1/22.
//

import UIKit
import InstantSearchVoiceOverlay
import CoreLocation
import MessageUI
import AVKit
import ContactsUI
import Speech


class ViewController: UIViewController, SFSpeechRecognizerDelegate, VoiceOverlayDelegate, CLLocationManagerDelegate, MFMessageComposeViewControllerDelegate, AVAudioRecorderDelegate, CNContactPickerDelegate {
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            switch result {
            case .cancelled:
                print("Message cancelled")
            case .sent:
                print("Message sent")
            case .failed:
                print("Message failed")
            default:
                break
            }
            dismiss(animated: true, completion: nil)
        }
    
    
    
    
    let voiceOverlay = VoiceOverlayController()
    let locationRetriever = LocationRetriever()
    var session: AVAudioSession! = AVAudioSession.sharedInstance()
    var record = false
    var recorder: AVAudioRecorder!
    var audios : [URL] = []
    
    let defaults = UserDefaults.standard
    var number: String = ""
    var name: String = ""
    var savedEmergencyContact: String = ""
    
   
    
    

    @IBOutlet weak var words: UILabel!
    
    @IBOutlet weak var contactLabel: UILabel!
    var lat = 0.0
    var longit = 0.0
    var manager: CLLocationManager?
    let audioEngine = AVAudioEngine() //gives updates when the mic recieves audio
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest() //recognizes the speech in real time
    var recognitionTask: SFSpeechRecognitionTask? //manages the recognition task
    override func viewDidLoad() {
        super.viewDidLoad()
        if let savedEmergencyContact = defaults.string(forKey: "ECName"){
            if savedEmergencyContact != nil{
                contactLabel.text = savedEmergencyContact
            }
        } else {
            return
        }
        
    
    
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        manager = CLLocationManager()
        manager?.delegate = self
        manager?.desiredAccuracy = kCLLocationAccuracyBest
        manager?.requestWhenInUseAuthorization()
        manager?.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        guard let first = locations.first else{
            return
        }
        
        lat = first.coordinate.latitude
        longit = first.coordinate.longitude
    
        
        
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
    
        number = (contact.phoneNumbers.first?.value.stringValue)!
        
        name = (contact.givenName)
        print(number)
        contactLabel.text = name
        self.defaults.set(number, forKey: "EmergencyContact")
        self.defaults.set(name, forKey: "ECName")
        
    
    }
    
    @IBAction func callnineoneone(_ sender: UIButton) {
        self.callNumber(phoneNumber: "911")
       
        
    }
    
    
    @IBAction func text911(_ sender: UIButton) {
        
        if !MFMessageComposeViewController.canSendText() {
                   print("SMS services are not available")
                   return
               }
               
               let messageController = MFMessageComposeViewController()
               messageController.messageComposeDelegate = self
               
               // Set the recipients of the message.
        messageController.recipients = ["911"]
               
               // Set the body of the message.
        messageController.body = self.getMessage()
               
               // Present the message controller.
               self.present(messageController, animated: true, completion: nil)
        
    }
    func getNumber() -> String{
        if let savedEmergencyContact = defaults.string(forKey: "EmergencyContact"){
            return savedEmergencyContact
        } else {
            return "911"
        }
    }
    
    func getMessage() -> String{
        let message = "The app SOS detected my distress, my last known location is https://www.google.com/maps/search/" + String(lat) + "," + String(longit) + "/@" + String(lat) + "," + String(longit) + ",17z"
        print(message)
        return message
    }
    
    func removeSpecialCharacters(from string: String) -> String {
        let allowedCharacterSet = CharacterSet.alphanumerics
        return string.components(separatedBy: allowedCharacterSet.inverted)
                     .joined(separator: "")
    }
    
    private func callNumber(phoneNumber:String) {
      if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
        let application:UIApplication = UIApplication.shared
        if (application.canOpenURL(phoneCallURL)) {
            application.open(phoneCallURL, options: [:], completionHandler: nil)
        }
      }
    }

    @IBAction func addContact(_ sender: UIButton) {
        print("button clicked")
        let contactController = CNContactPickerViewController()
        contactController.delegate = self
        self.present(contactController, animated: true, completion: nil)
        
    }
    @IBAction func startListening(_ sender: UIButton) {
        
        
        do {
            try session.setCategory(.playAndRecord, mode: .default)
            try session.setActive(true)
            session.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        
                    } else {
                        // failed to record!
                    }
                }
            }
        } catch {
            // failed to record!
        }


        voiceOverlay.delegate = self
        voiceOverlay.settings.autoStop = false
//        self.session = AVAudioSession.sharedInstance()
//        try self.session.setCategory(.playAndRecord)
//        self.session.requestRecordPermission{ (status) in
//
//        }
    
        
        voiceOverlay.start(on: self, textHandler: { text, final, _ in
            
            if text.contains("help"){
               
                self.voiceOverlay.settings.autoStop = true
                self.voiceOverlay.settings.autoStopTimeout = 0.1
                self.dismiss(animated: true)
               
                print("The user said help")
                if !MFMessageComposeViewController.canSendText() {
                           print("SMS services are not available")
                           return
                       }
                       
                       let messageController = MFMessageComposeViewController()
                       messageController.messageComposeDelegate = self
                       
                       // Set the recipients of the message.
                messageController.recipients = [self.getNumber()]
                       
                       // Set the body of the message.
                messageController.body = self.getMessage()
                       
                       // Present the message controller.
                       self.present(messageController, animated: true, completion: nil)
                
            } else if text.contains("Help"){
              
                self.voiceOverlay.settings.autoStop = true
                self.voiceOverlay.settings.autoStopTimeout = 0.1
                self.dismiss(animated: true)
                print("The user said help")
                
                if !MFMessageComposeViewController.canSendText() {
                           print("SMS services are not available")
                           return
                       }
                       
                       let messageController = MFMessageComposeViewController()
                       messageController.messageComposeDelegate = self
                
                       // Set the recipients of the message.
                messageController.recipients = [self.getNumber()]
                       
                       // Set the body of the message.
                messageController.body = self.getMessage()
                       
                       // Present the message controller.
                       self.present(messageController, animated: true, completion: nil)
                
            } else if text.contains("Call now"){
                
                self.voiceOverlay.settings.autoStop = true
                self.voiceOverlay.settings.autoStopTimeout = 0.1
                self.dismiss(animated: true)
                
                var enumber = self.getNumber()
                enumber = self.removeSpecialCharacters(from: enumber)
                print("attempting to call")
                self.callNumber(phoneNumber: enumber)
               

            }else if text.contains("call now"){
               
                self.voiceOverlay.settings.autoStop = true
                self.voiceOverlay.settings.autoStopTimeout = 0.1
                self.dismiss(animated: true)
                var enumber = self.getNumber()
                enumber = self.removeSpecialCharacters(from: enumber)
                print("attempting to call")
                self.callNumber(phoneNumber: enumber)
                
               
            }else if final{
               
                print("The user did not say the key word")
            }
//            if final {
//                print("Final text is \(text)")
//            } else {
//                print("In Progress: \(text)")
//            }
            
        }, errorHandler: { error in
        
                            })
        
        print("running successfully")
        
    }
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    

    
    func getAudios(){
           do{
               
               let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
               
               let result = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .producesRelativePathURLs)
               self.audios.removeAll()
               for i in result{
                   self.audios.append(i)
               }
           }
           catch{
               print(error.localizedDescription)
           }
       }
    
    func recording(text: String?, final: Bool?, error: Error?) {
        
    }
 
}

