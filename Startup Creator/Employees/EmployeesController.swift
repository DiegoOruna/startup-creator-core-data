//
//  EmployeeController.swift
//  Startup Creator
//
//  Created by Diego Oruna on 4/19/19.
//  Copyright © 2019 Diego Oruna. All rights reserved.
//

import UIKit
import CoreData

class EmployeesController: UITableViewController, CreateEmployeeControllerDelegate {
    
    func didAddEmployee(employee: Employee) {
        employees.append(employee)
        let newIndexPath = IndexPath(row: employees.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .fade)
    }
    
    var startup:Startup?
    var employees = [Employee]()
    
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
        let navController = CustomNavigationController(rootViewController: createEmployeeController)
        present(navController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = startup?.name
    }
    
    fileprivate func fetchEmployees(){
        let context = CoreDataManager.shared.persistantContainer.viewContext
        
        let request = NSFetchRequest<Employee>(entityName: "Employee")
        
        do {
            let emp = try context.fetch(request)
            
            emp.forEach({employees.append($0)})
            
        } catch let errFetch {
            print("Failed to fetch employees: ", errFetch.localizedDescription)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        let currentEmployee = employees[indexPath.row]
        cell.textLabel?.text = currentEmployee.name
        
        if let taxId = currentEmployee.employeeInformation?.taxId{
            cell.textLabel?.text = "\(currentEmployee.name ?? "") \(taxId)"
        }
        cell.backgroundColor = UIColor.tealColor
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    
}
