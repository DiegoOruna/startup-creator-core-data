//
//  ViewController.swift
//  Startup Creator
//
//  Created by Diego Oruna on 4/17/19.
//  Copyright © 2019 Diego Oruna. All rights reserved.
//

import UIKit
import CoreData

class StartupsController: UITableViewController {
    
    let cellId = "cellId"
    
    var startups = [Startup]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.startups = CoreDataManager.shared.fetchStartups()
        
        tableView.register(StartupCell.self, forCellReuseIdentifier: cellId)
        tableView.backgroundColor = UIColor.darkBlue
        tableView.separatorColor = .white
        tableView.tableFooterView = UIView()
        setupNavStyle()
    }
    
    fileprivate func setupNavStyle(){
        navigationItem.title =  "Startups"
        setupPlusButtonInNavBar(selector: #selector(handleAddStartup))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset))
    }
    
    @objc fileprivate func handleReset(){
        print("Reseting...")
        let context = CoreDataManager.shared.persistantContainer.viewContext
        
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Startup.fetchRequest())
        do {
            try context.execute(batchDeleteRequest)

            var indexPathsToRemove = [IndexPath]()
            
            for (index, _) in startups.enumerated(){
                let indexPath = IndexPath(row: index, section: 0)
                indexPathsToRemove.append(indexPath)
            }
            startups.removeAll()
            tableView.deleteRows(at: indexPathsToRemove, with: .left)
        } catch let delErr {
            print("Error deleting objects from CD: ", delErr.localizedDescription)
        }
        
    }
    
    @objc fileprivate func handleAddStartup(){
        let createStartupController = CreateStartupController()
        createStartupController.delegate = self
        let navController = CustomNavigationController(rootViewController: createStartupController)
        present(navController, animated: true, completion: nil)
    }

}

