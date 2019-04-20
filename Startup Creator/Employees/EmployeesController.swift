//
//  EmployeeController.swift
//  Startup Creator
//
//  Created by Diego Oruna on 4/19/19.
//  Copyright © 2019 Diego Oruna. All rights reserved.
//

import UIKit
import CoreData

class IndentedLabel: UILabel {
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        let customRect = rect.inset(by: insets)
        super.drawText(in: customRect)
    }
    
}

class EmployeesController: UITableViewController, CreateEmployeeControllerDelegate {
    
    func didAddEmployee(employee: Employee) {
//        employees.append(employee)
//        let newIndexPath = IndexPath(row: employees.count - 1, section: 0)
//        tableView.insertRows(at: [newIndexPath], with: .fade)
        
//        fetchEmployees()
//        tableView.reloadData()
        guard let section = employeeTypes.firstIndex(of: employee.type!) else {return}
        let row = allEmployees[section].count
        
        let insertionIndexPath = IndexPath(row: row, section: section)
        
        allEmployees[section].append(employee)
        
        tableView.insertRows(at: [insertionIndexPath], with: .middle)
    }
    
    var startup:Startup?
//    var employees = [Employee]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.darkBlue
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        setupPlusButtonInNavBar(selector: #selector(handleAdd))
        fetchEmployees()
    }
    
    @objc fileprivate func handleAdd(){
        print("Trying to add new employee")
        let createEmployeeController = CreateEmployeeController()
        createEmployeeController.delegate = self
        createEmployeeController.startup = startup
        let navController = CustomNavigationController(rootViewController: createEmployeeController)
        present(navController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = startup?.name
    }
    
    var allEmployees = [[Employee]]()
    
    var employeeTypes = [
        EmployeeType.Executive.rawValue,
        EmployeeType.SeniorManagement.rawValue,
        EmployeeType.Staff.rawValue
    ]
    
    fileprivate func fetchEmployees(){
        
        allEmployees = []
        
        guard let startupEmployees = startup?.employees?.allObjects as? [Employee] else {return}
        
        employeeTypes.forEach { (employeeType) in
            allEmployees.append(
                startupEmployees.filter{$0.type == employeeType}
            )
        }
        
//        let executives = startupEmployees.filter{$0.type == EmployeeType.Executive.rawValue}
//
//        let seniorManagement = startupEmployees.filter{$0.type == EmployeeType.SeniorManagement.rawValue}
//
//        let staff = startupEmployees.filter{$0.type == EmployeeType.Staff.rawValue}
        
//        allEmployees = [
//            executives, seniorManagement, staff
//        ]

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        
        let employee = allEmployees[indexPath.section][indexPath.row]
        
        if let birthdayDate = employee.employeeInformation?.birthday{
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMMM, yyyy"
            cell.textLabel?.text = "\(employee.name ?? "") | \(dateFormatter.string(from: birthdayDate))"
            
        }else{
            cell.textLabel?.text = employee.name
        }
        cell.backgroundColor = UIColor.tealColor
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allEmployees[section].count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return allEmployees.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label = IndentedLabel()

        label.text = employeeTypes[section]
        
        label.backgroundColor = UIColor.lightBlue
        label.textColor = UIColor.darkBlue
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
}
