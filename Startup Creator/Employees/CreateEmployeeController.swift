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
    
    var startup:Startup?
    
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
    
    let birthdayLabel:UILabel = {
        let label  = UILabel()
        label.text = "Birthday"
        label.translatesAutoresizingMaskIntoConstraints =  false
        return label
    }()
    
    let birthdayTextField:UITextField = {
        let tf = UITextField()
        tf.placeholder = "DD/MM/YYYY"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let employeeTypeSegmentedControler:UISegmentedControl = {
//        let types = ["Executive","Senior Management","Staff"]
        let types = [
            EmployeeType.Executive.rawValue,
            EmployeeType.SeniorManagement.rawValue,
            EmployeeType.Staff.rawValue
        ]
        let sc = UISegmentedControl(items: types)
        sc.selectedSegmentIndex = 0
        sc.tintColor = UIColor.darkBlue
        sc.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Create Employee"
        setupCancelButtonInNavBar()
        setupSaveButtonInNavBar(selector: #selector(handleSave))
        view.backgroundColor = UIColor.darkBlue
        _ = setupLightBlueBackgroundView(height: 150)
        setupUI()
    }
    
    @objc fileprivate func handleSave(){
        
        guard let employeeName = nameTextField.text else {return}
        guard let startup = startup else {return}
        
        guard let birthdayText = birthdayTextField.text else {return}
        
        if birthdayText.isEmpty {
            showError(title: "Birthday Empty", message: "You have not entered a Birthday")
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        guard let birthdayDate = dateFormatter.date(from: birthdayText) else {
            showError(title: "Bad Date", message: "Incorrect Format")
            return
        }
        
        guard let employeeType = employeeTypeSegmentedControler.titleForSegment(at: employeeTypeSegmentedControler.selectedSegmentIndex) else {return}
        
        let tuple = CoreDataManager.shared.createEmployee(employeeName: employeeName, birthday: birthdayDate, employeeType: employeeType, startup: startup)
        
        guard let emp = tuple.0 else {return}
        
        if let err = tuple.1{
            print(err.localizedDescription)
        }else{
            dismiss(animated: true) {
                self.delegate?.didAddEmployee(employee: emp)
            }
        }

    }
    
    fileprivate func showError(title:String, message:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func setupUI(){
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(birthdayLabel)
        view.addSubview(birthdayTextField)
        view.addSubview(employeeTypeSegmentedControler)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: view.topAnchor),
            nameLabel.widthAnchor.constraint(equalToConstant: 90),
            nameLabel.heightAnchor.constraint(equalToConstant: 50),
            
            nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor),
            nameTextField.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            birthdayLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            birthdayLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            birthdayLabel.widthAnchor.constraint(equalToConstant: 90),
            birthdayLabel.heightAnchor.constraint(equalToConstant: 50),
            
            birthdayTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor),
            birthdayTextField.leadingAnchor.constraint(equalTo: birthdayLabel.trailingAnchor),
            birthdayTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            birthdayTextField.heightAnchor.constraint(equalToConstant: 50),
            
            employeeTypeSegmentedControler.topAnchor.constraint(equalTo: birthdayLabel.bottomAnchor, constant: 5),
            employeeTypeSegmentedControler.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            employeeTypeSegmentedControler.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            employeeTypeSegmentedControler.heightAnchor.constraint(equalToConstant: 35)
            
            ])
        
    }
    
}
