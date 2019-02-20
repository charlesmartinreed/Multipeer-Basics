//
//  LandingVC.swift
//  Multipeer Basics
//
//  Created by Charles Martin Reed on 2/19/19.
//  Copyright © 2019 Charles Martin Reed. All rights reserved.
//

import UIKit

class LandingVC: UIViewController, UIGestureRecognizerDelegate {
    
    //MARK: Properties
    let userImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "chat-icon").withRenderingMode(.alwaysOriginal)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let helloLabelView: UIView = {
       let labelView = UIView()
        labelView.translatesAutoresizingMaskIntoConstraints = false
        labelView.backgroundColor = UIColor(red: 207.0/255.0, green: 48.0/255.0, blue: 48.0/255.0, alpha: 1)
        labelView.layer.cornerRadius = 10
        
        return labelView
    }()
    
    let helloLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont.systemFont(ofSize: 32)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "HELLO \nmy name is"
        
        return label
    }()
    
    let nameLabelView: UIView = {
        let labelView = UIView()
        labelView.translatesAutoresizingMaskIntoConstraints = false
        labelView.backgroundColor = .white
        
        return labelView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont.systemFont(ofSize: 48)
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.text = "Charles"
        
        return label
    }()
    
    let hostButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle("Host a Chat", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 207.0/255.0, green: 48.0/255.0, blue: 48.0/255.0, alpha: 1)
        button.layer.cornerRadius = 8
        
        button.addTarget(self, action: #selector(hostChatTapped), for: .touchUpInside)
        return button
    }()
    
    let joinButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle("Join a Chat", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 207.0/255.0, green: 48.0/255.0, blue: 48.0/255.0, alpha: 1)
        button.layer.cornerRadius = 8
        
        button.addTarget(self, action: #selector(joinChatTapped), for: .touchUpInside)
        return button
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 244.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1)
        
//        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
//        tapRecognizer.delegate = self
//        view.addGestureRecognizer(tapRecognizer)
        
        setupLandingPageUI()
        

        // Do any additional setup after loading the view.
    }
    
    func setupLandingPageUI() {
        setupImageView()
        setupLabelView()
        setupLabelText()
        setupButtons()
    }
    
    func setupImageView() {
        view.addSubview(userImageView)
        
//        let imageTap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
//        view.addGestureRecognizer(imageTap)
        
        let imageViewConstraints: [NSLayoutConstraint] = [
            userImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 64),
            userImageView.heightAnchor.constraint(equalToConstant: 128),
            userImageView.widthAnchor.constraint(equalToConstant: 128),
            userImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        
        NSLayoutConstraint.activate(imageViewConstraints)
    }
    
    func setupLabelView() {
        view.addSubview(helloLabelView)
        helloLabelView.addSubview(nameLabelView)
        nameLabelView.addSubview(nameLabel)
        
//        let labelTap = UITapGestureRecognizer(target: self, action: #selector(presentTextInput))
//        view.addGestureRecognizer(labelTap)
        
        let helloViewConstraints: [NSLayoutConstraint] = [
            helloLabelView.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 32),
            helloLabelView.widthAnchor.constraint(equalToConstant: 300),
            helloLabelView.heightAnchor.constraint(equalToConstant: 200),
            helloLabelView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        
        let nameLabelViewConstraints: [NSLayoutConstraint] = [
            nameLabelView.heightAnchor.constraint(equalToConstant: 88),
            nameLabelView.leadingAnchor.constraint(equalTo: helloLabelView.leadingAnchor),
            nameLabelView.trailingAnchor.constraint(equalTo: helloLabelView.trailingAnchor),
            nameLabelView.bottomAnchor.constraint(equalTo: helloLabelView.bottomAnchor, constant: -16)
        ]
        
        
        NSLayoutConstraint.activate(helloViewConstraints)
        NSLayoutConstraint.activate(nameLabelViewConstraints)
    }
    
    func setupLabelText() {
        helloLabelView.addSubview(helloLabel)
        
        let labelConstraints: [NSLayoutConstraint] = [
            helloLabel.topAnchor.constraint(equalTo: helloLabelView.topAnchor, constant: 8),
            helloLabel.leadingAnchor.constraint(equalTo: helloLabelView.leadingAnchor, constant: 8),
            helloLabel.trailingAnchor.constraint(equalTo: helloLabelView.trailingAnchor, constant: -8),
            
        ]
        
        let nameLabelConstraints: [NSLayoutConstraint] = [
            nameLabel.centerXAnchor.constraint(equalTo: nameLabelView.centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: nameLabelView.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(labelConstraints)
        NSLayoutConstraint.activate(nameLabelConstraints)
    }
    
    func setupButtons() {
        view.addSubview(hostButton)
        view.addSubview(joinButton)
        
        let hostButtonConstraints: [NSLayoutConstraint] = [
            hostButton.topAnchor.constraint(equalTo: helloLabelView.bottomAnchor, constant: 32),
            hostButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hostButton.heightAnchor.constraint(equalToConstant: 36),
            hostButton.widthAnchor.constraint(equalToConstant: 128)
        ]
        
        let joinButtonConstraints: [NSLayoutConstraint] = [
            joinButton.topAnchor.constraint(equalTo: hostButton.bottomAnchor, constant: 16),
            joinButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            joinButton.heightAnchor.constraint(equalToConstant: 36),
            joinButton.widthAnchor.constraint(equalToConstant: 128)
        ]
        
        NSLayoutConstraint.activate(hostButtonConstraints)
        NSLayoutConstraint.activate(joinButtonConstraints)
    }
    
    
    //MARK:- Handling methods
    @objc func presentPickerView() {
        print("present picker view now")
    }
    
    @objc func presentTextInput() {
        print("present text input")
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
    }
    
    @objc func hostChatTapped() {
        print("host tapped")
    }
    
    @objc func joinChatTapped() {
        print("join tapped")
    }

}
