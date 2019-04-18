//
//  CreateStartupController.swift
//  Startup Creator
//
//  Created by Diego Oruna on 4/17/19.
//  Copyright © 2019 Diego Oruna. All rights reserved.
//

import UIKit
import CoreData

protocol CreateStartupControllerDelegate {
    func didAddStartup(startup:Startup)
    func didEditStartup(startup:Startup)
}

class CreateStartupController: UIViewController {
    
    var startup:Startup?{
        didSet{
            nameTextField.text = startup?.name
            
            guard let founded = startup?.founded else {return}
            datePicker.date = founded
        }
    }
    
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
    
    let datePicker:UIDatePicker = {
        let dp = UIDatePicker()
        dp.translatesAutoresizingMaskIntoConstraints = false
        dp.datePickerMode = .date
        return dp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.darkBlue
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = startup == nil ? "Create Startup":"Edit \(startup?.name ?? "")"
    }
    
    @objc fileprivate func handleSave(){
        if startup == nil{
            createStartup()
        }else{
            saveStartupChanges()
        }
    }
    
    fileprivate func saveStartupChanges(){
        let context = CoreDataManager.shared.persistantContainer.viewContext
        startup?.name = nameTextField.text
        startup?.founded = datePicker.date
        
        do {
            try context.save()
            
            //Success saving
            dismiss(animated: true) {
                self.delegate?.didEditStartup(startup: self.startup!)
            }
            
        } catch let err {
            print(err.localizedDescription)
        }
        
    }
    
    fileprivate func createStartup(){
        let context = CoreDataManager.shared.persistantContainer.viewContext
        
        //        let startup = NSEntityDescription.insertNewObject(forEntityName: "Startup", into: context)
        let startup = Startup(context: context)
        
        //        startup.setValue(nameTextField.text, forKey: "name")
        startup.name = nameTextField.text
        startup.founded = datePicker.date
        
        do {
            try context.save()
            
            //Success saving
            dismiss(animated: true) {
                self.delegate?.didAddStartup(startup: startup)
            }
            
        } catch let err {
            print(err.localizedDescription)
        }
    }
    
    fileprivate func setupUI(){
        let lightBlueBackgroundView = UIView()
        lightBlueBackgroundView.backgroundColor = UIColor.lightBlue
        lightBlueBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(lightBlueBackgroundView)
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(datePicker)
        
        NSLayoutConstraint.activate([
                lightBlueBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                lightBlueBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
                lightBlueBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                lightBlueBackgroundView.heightAnchor.constraint(equalToConstant: 250),
            
                nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                nameLabel.topAnchor.constraint(equalTo: view.topAnchor),
                nameLabel.widthAnchor.constraint(equalToConstant: 90),
                nameLabel.heightAnchor.constraint(equalToConstant: 50),
                
                nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor),
                nameTextField.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
                nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                nameTextField.heightAnchor.constraint(equalToConstant: 50),
                
                datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                datePicker.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
                datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                datePicker.bottomAnchor.constraint(equalTo: lightBlueBackgroundView.bottomAnchor)
            ])
    }
    
    @objc fileprivate func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    
}
