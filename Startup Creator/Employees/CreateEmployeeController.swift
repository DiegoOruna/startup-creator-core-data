//
//  CreateEmployeeController.swift
//  Startup Creator
//
//  Created by Diego Oruna on 4/19/19.
//  Copyright © 2019 Diego Oruna. All rights reserved.
//

import UIKit

protocol CreateEmployeeControllerDelegate {
    func didAddEmployee(employee:Employee)
}

class CreateEmployeeController: UIViewController {
    
    var delegate:CreateEmployeeControllerDelegate?
    
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
        navigationItem.title = "Create Employee"
        setupCancelButtonInNavBar()
        setupSaveButtonInNavBar(selector: #selector(handleSave))
        view.backgroundColor = UIColor.darkBlue
        _ = setupLightBlueBackgroundView(height: 50)
        setupUI()
    }
    
    @objc fileprivate func handleSave(){
        
        guard let employeeName = nameTextField.text else {return}
        let tuple = CoreDataManager.shared.createEmployee(employeeName: employeeName)
        guard let emp = tuple.0 else {return}
        
        if let err = tuple.1{
            print(err.localizedDescription)
        }else{
            dismiss(animated: true) {
                self.delegate?.didAddEmployee(employee: emp)
            }
        }

    }
    
    func setupUI(){
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: view.topAnchor),
            nameLabel.widthAnchor.constraint(equalToConstant: 90),
            nameLabel.heightAnchor.constraint(equalToConstant: 50),
            
            nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor),
            nameTextField.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 50),
            ])
        
    }
    
}
