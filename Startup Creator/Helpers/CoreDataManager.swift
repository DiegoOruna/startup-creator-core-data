//
//  CoreDataManager.swift
//  Startup Creator
//
//  Created by Diego Oruna on 4/18/19.
//  Copyright © 2019 Diego Oruna. All rights reserved.
//

import CoreData

struct CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let persistantContainer:NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "StartupCreatorModel")
        
        container.loadPersistentStores { (storeDesc, err) in
            if let err = err{
                fatalError("Loading of store failed: \(err.localizedDescription)")
            }
        }
        
        return container
        
    }()
    
    func fetchStartups() -> [Startup]{
        
        let context = persistantContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Startup>(entityName: "Startup")
        
        do {
            let startups = try context.fetch(fetchRequest)
            return startups
            
        } catch let fetchErr {
            print("Failed to fetch startups:", fetchErr.localizedDescription)
            return []
        }
        
    }
    
    func createEmployee(employeeName:String, birthday:Date, employeeType:String, startup:Startup) -> (Employee?,Error?){
        
        let context = persistantContainer.viewContext
        
        let employee = Employee(context: context)
        
        employee.startup = startup
        employee.name = employeeName
        employee.type = employeeType
        
        let employeeInformation = EmployeeInformation(context: context)
        employeeInformation.taxId = "455"
        employeeInformation.birthday = birthday
        
        employee.employeeInformation = employeeInformation
        
        do {
            try context.save()
            return (employee,nil)
        } catch let err {
            print("Failed to create employee",err.localizedDescription)
            return (nil,err)
        }
        
    }
}
