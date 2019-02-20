//
//  LandingVC.swift
//  Multipeer Basics
//
//  Created by Charles Martin Reed on 2/19/19.
//  Copyright © 2019 Charles Martin Reed. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class LandingVC: UIViewController, UIGestureRecognizerDelegate {
    
    var currentUserName: String?
    var currentUserPhoto: UIImage?
    var currentUserID: MCPeerID?
    
    //MARK: Properties
    lazy var userImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "chat-icon").withRenderingMode(.alwaysOriginal)
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 3
        
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        tapGestureRecognizer.delegate = self
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
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
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        
        label.font = UIFont.systemFont(ofSize: 48)
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.minimumScaleFactor = 0.5
        label.text = "Tony Rando"
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        tapGestureRecognizer.delegate = self
        label.addGestureRecognizer(tapGestureRecognizer)
        
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
            hostButton.widthAnchor.constraint(equalToConstant: 150)
        ]
        
        let joinButtonConstraints: [NSLayoutConstraint] = [
            joinButton.topAnchor.constraint(equalTo: hostButton.bottomAnchor, constant: 16),
            joinButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            joinButton.heightAnchor.constraint(equalToConstant: 36),
            joinButton.widthAnchor.constraint(equalToConstant: 150)
        ]
        
        NSLayoutConstraint.activate(hostButtonConstraints)
        NSLayoutConstraint.activate(joinButtonConstraints)
    }
    
    func updateUserInfo(for: User) {
        
    }
    
    func createNewUser(user: User) {
        
    }
    
    
    //MARK:- Handling methods
    private func presentPickerView() {
        print("image view tapped")
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.sourceType = .camera
        imagePickerVC.allowsEditing = true
        imagePickerVC.delegate = self
        present(imagePickerVC, animated: true, completion: nil)
    }
    
    private func presentTextInput() {
        let ac = UIAlertController(title: "What's your name?", message: nil, preferredStyle: .alert)
        ac.addTextField(configurationHandler: nil)
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned ac] _  in
            //update the text in our name label
            if let newName = ac.textFields?.first?.text {
                self.nameLabel.text = newName
                self.currentUserName = newName
            }
            
        }
        ac.addAction(submitAction)
        present(ac, animated: true, completion: nil)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.view is UIImageView {
           presentPickerView()
        } else if sender.view is UILabel {
            presentTextInput()
        }
    }
    
    @objc func hostChatTapped() {
        //create a user with the given information, or, if none given, use the default.
        print("host tapped")
    }
    
    @objc func joinChatTapped() {
        print("join tapped")
    }

}

extension LandingVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[.editedImage] as? UIImage else { return }
        
        //update user photo and add the photo to the photo ID
        self.currentUserPhoto = image
        userImageView.image = image
    }
    
}
