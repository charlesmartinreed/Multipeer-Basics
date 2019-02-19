//
//  ViewController.swift
//  Multipeer Basics
//
//  Created by Charles Martin Reed on 2/18/19.
//  Copyright © 2019 Charles Martin Reed. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var messageInputBottomAnchorConstraint: NSLayoutConstraint!
    
    //MARK:- Properties
    let messageTextView: UITextView = {
       let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let messageInput: UITextField = {
        let input = UITextField()
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
        let item = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(handleBarButtonTapped))
        toolbar.items = [item]
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
        
        setupMessengerUI()
        
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


}

