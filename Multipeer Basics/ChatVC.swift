//
//  ViewController.swift
//  Multipeer Basics
//
//  Created by Charles Martin Reed on 2/18/19.
//  Copyright © 2019 Charles Martin Reed. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ChatVC: UIViewController {
    
    //MARK:- Multipeer properties
    var peerId: MCPeerID!
    var mcSession: MCSession!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    var deviceName = UIDevice.current.name
    var isHosting = false
    
    var sentMessages = [[String:Data]]()
    var receivedMessages = [[String: Data]]()
    
    //MARK:- Properties
    var messageInputBottomAnchorConstraint: NSLayoutConstraint!
    
    let messageTextView: UITextView = {
       let textView = UITextView()
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let messageInput: UITextField = {
        let input = UITextField()
        input.borderStyle = .roundedRect
        input.backgroundColor = .white
        input.placeholder = "Enter message here"
        input.translatesAutoresizingMaskIntoConstraints = false
        return input
    }()
    
//    let sendButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("Send", for: .normal)
//        button.setTitleColor(.green, for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
    
    lazy var connectionToolbar: UIToolbar = {
        let toolbar = UIToolbar()
        let chatImage = #imageLiteral(resourceName: "chat-icon").withRenderingMode(.alwaysOriginal)
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        let chatButton = UIBarButtonItem(image: chatImage, style: .plain, target: self, action: #selector(handleBarButtonTapped))
        toolbar.items = [flexSpace, chatButton, flexSpace]
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        return toolbar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 227.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1)
        
        //setup notification center to observer keyboard events
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        //set the delegate for our text field
        messageInput.delegate = self
        
        setupMCPeering()
        setupMessengerUI()
        
    }
    
    private func setupMCPeering() {
        //make sure the user isn't connected at startup
        //mcSession.disconnect()
        peerId = MCPeerID(displayName: deviceName)
        mcSession = MCSession(peer: peerId, securityIdentity: nil, encryptionPreference: .required)
        mcSession.delegate = self
    }
    
    private func setupMessengerUI() {
        view.addSubview(messageTextView)
        view.addSubview(messageInput)
        //view.addSubview(sendButton)
        view.addSubview(connectionToolbar)
        
        messageInputBottomAnchorConstraint = messageInput.bottomAnchor.constraint(equalTo: connectionToolbar.topAnchor, constant: -4)
        
        let messagesTextViewConstraints: [NSLayoutConstraint] = [
            messageTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            messageTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            messageTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            messageTextView.bottomAnchor.constraint(equalTo: messageInput.topAnchor, constant: -8)
        ]
        
        let messageInputConstraints: [NSLayoutConstraint] = [
            messageInput.bottomAnchor.constraint(equalTo: connectionToolbar.topAnchor, constant: -4),
            messageInput.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            messageInput.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            messageInput.heightAnchor.constraint(equalToConstant: 40),
            messageInputBottomAnchorConstraint
        ]
        
//        let sendButtonConstraints: [NSLayoutConstraint] = [
//            sendButton.widthAnchor.constraint(equalToConstant: 48),
//            sendButton.bottomAnchor.constraint(equalTo: connectionToolbar.topAnchor, constant: -4),
//            sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
//        ]
        
        let toolbarConstraints: [NSLayoutConstraint] = [
            connectionToolbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            connectionToolbar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            connectionToolbar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(messagesTextViewConstraints)
        NSLayoutConstraint.activate(messageInputConstraints)
        //NSLayoutConstraint.activate(sendButtonConstraints)
        NSLayoutConstraint.activate(toolbarConstraints)
        
        
    }
    
    
    //MARK:- Handler methods
    @objc func handleBarButtonTapped() {
        if mcSession.connectedPeers.count == 0 && !isHosting {
            displayActionSheet(title: "Our chat", message: "Do you want to join or host a chat?", hosting: isHosting)
        } else if mcSession.connectedPeers.count == 0 && isHosting {
            displayActionSheet(title: "Just a moment", message: "We're waiting for peers to join your session", hosting: isHosting)
        } else {
            displayActionSheet(title: "Would you like to disconnect?", message: "", hosting: nil)
        }
        
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            messageInputBottomAnchorConstraint.constant = -4
        } else {
            messageInputBottomAnchorConstraint.constant = -keyboardScreenEndFrame.height
        }
    }
    
    func displayActionSheet(title: String, message: String, hosting: Bool?) {
        if let hosting = hosting {
            if !hosting {
                let sheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
                
                sheet.addAction(UIAlertAction(title: "Host Chat", style: .default, handler: { (action) in
                    //turn assistant on, which broadcasts
                    self.mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "test-mc", discoveryInfo: nil, session: self.mcSession)
                    self.mcAdvertiserAssistant.start()
                    self.isHosting = true
                }))
                sheet.addAction(UIAlertAction(title: "Join Chat", style: .default, handler: { (_) in
                    //searches for nearby broadcasts and displays them
                    let mcBrowser = MCBrowserViewController(serviceType: "test-mc", session: self.mcSession)
                    mcBrowser.delegate = self
                    self.present(mcBrowser, animated: true, completion: nil)
                }))
                
                sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                present(sheet, animated: true, completion: nil)
                
            } else {
                let waitingSheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
                
                waitingSheet.addAction(UIAlertAction(title: "Disconnect", style: .destructive, handler: { (_) in
                    //disconnect the user from the session and set isHosting to false
                    self.mcSession.disconnect()
                    self.isHosting = false
                }))
                
                waitingSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                present(waitingSheet, animated: true, completion: nil)
            }
        } else {
            let disconnectSheet = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            disconnectSheet.addAction(UIAlertAction(title: "Disconnect", style: .destructive, handler: { (_) in
                self.mcSession.disconnect()
                //MARK:- TODO, SEND BACK TO SPLASH SCREEN
                self.messageTextView.text = ""
            }))
            
            disconnectSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(disconnectSheet, animated: true, completion: nil)
        }
    }
    
    func displayAlert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            ac.dismiss(animated: true, completion: nil)
        }))
        
        present(ac, animated: true, completion: nil)
    }
    
    func convertMessageToData(message: Message) {
        if let sender = message.sender.data(using: .utf8, allowLossyConversion: false), let contents = message.contents.data(using: .utf8, allowLossyConversion: false) {
            
            let messageDict = ["sender": sender, "contents": contents]
            //sentMessages.append(messageDict)
            sendMessageToPeer(message: messageDict)
            
        }
    }
    
    func sendMessageToPeer(message: [String: Data]) {
        //Multipeer needs to send this as data
        //MARK:- TODO: MAP MESSAGE CLASS
        //good use case for map here - look into implementing mappable class/struct for Message
        
        //convert dictionary to NSData to send it as a peer
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: message, requiringSecureCoding: true)
            try self.mcSession.send(data, toPeers: self.mcSession.connectedPeers, with: .reliable)
        } catch let error {
            print(error.localizedDescription)
        }
//        if let contents = message.contents.data(using: .utf8, allowLossyConversion: false) {
//
//            //try to send
//            do {
//                try self.mcSession.send(contents, toPeers: self.mcSession.connectedPeers, with: .reliable)
//            } catch let error {
//                print(error.localizedDescription)
//            }
//
//            //message should also appear on our screen
//            messageTextView.text = messageTextView.text + "\n\(message.sender): \(message.contents)"
//        }
        
        
        
    }
}

extension ChatVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            guard let contents = textField.text else { return false }
            
            //create a message, store it in the messages array
            let messageToSend = Message(sender: deviceName, contents: contents)
            convertMessageToData(message: messageToSend)
            //sendMessageToPeer(message: messageToSend)
            //sentMessages.append(messageToSend)
            
            //test print
//            sentMessages.forEach { (message) in
//                print("\(message.sender) said \(message.contents)")
//            }
            //message should also appear on our screen
            messageTextView.text = messageTextView.text + "\n\(messageToSend.sender): \(messageToSend.contents)"
            textField.text = ""
            
            
          return self.view.endEditing(true)
        } else {
            let alert = UIAlertController(title: "Empty message", message: "Please enter a message", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                alert.dismiss(animated: true, completion: nil)
            }))
            present(alert, animated: true, completion: nil)
        }
        return false
    }
}

extension ChatVC: MCSessionDelegate, MCBrowserViewControllerDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
        switch state {
        case .connected:
            print("Connected: \(peerID.displayName)")
        case .connecting:
            print("Connecting: \(peerID.displayName)")
        case .notConnected:
            print("Not Connected: \(peerID.displayName)")
//            displayAlert(title: "User has disconnected", message: "\(peerID.displayName) has left.")
//            self.messageTextView.text = ""
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async {
            do {
                let messageDict = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! Dictionary<String, Data>
                //pull from the dictionary
                if let messageData = messageDict["contents"], let messageSender = messageDict["sender"] {
                    let contents = String(data: messageData, encoding: .utf8)!
                    let sender = String(data: messageSender, encoding: .utf8)!
                    let newMessage = Message(sender: sender, contents: contents)
                    self.messageTextView.text = self.messageTextView.text + "\n\(newMessage.sender): \(newMessage.contents)"
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
            
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    
}

