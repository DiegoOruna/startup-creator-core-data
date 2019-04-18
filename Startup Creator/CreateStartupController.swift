//
//  CreateStartupController.swift
//  Startup Creator
//
//  Created by Diego Oruna on 4/17/19.
//  Copyright © 2019 Diego Oruna. All rights reserved.
//

import UIKit

protocol CreateStartupControllerDelegate {
    func didAddStartup(startup:Startup)
}

class CreateStartupController: UIViewController {
    
    var delegate:CreateStartupControllerDelegate?
    
    let nameLabel:UILabel = {
        let label  = UILabel()
        label.text = "Name"
        label.translatesAutoresizingMaskIntoConstraints =  false
        return label
    }()
    
    let nameTextField:UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.darkBlue
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        navigationItem.title = "Create Startup"
        setupUI()
    }
    
    @objc fileprivate func handleSave(){
    
        dismiss(animated: true) {
            guard let name = self.nameTextField.text else {return}
            let startup = Startup(name: name, founded: Date())
            self.delegate?.didAddStartup(startup: startup)
        }
        
    }
    
    fileprivate func setupUI(){
        let lightBlueBackgroundView = UIView()
        lightBlueBackgroundView.backgroundColor = UIColor.lightBlue
        lightBlueBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(lightBlueBackgroundView)
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        
        NSLayoutConstraint.activate([
                lightBlueBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                lightBlueBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
                lightBlueBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                lightBlueBackgroundView.heightAnchor.constraint(equalToConstant: 50),
            
                nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                nameLabel.topAnchor.constraint(equalTo: view.topAnchor),
                nameLabel.widthAnchor.constraint(equalToConstant: 90),
                nameLabel.heightAnchor.constraint(equalToConstant: 50),
                
                nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor),
                nameTextField.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
                nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                nameTextField.heightAnchor.constraint(equalToConstant: 50)
            ])
    }
    
    @objc fileprivate func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    
}
