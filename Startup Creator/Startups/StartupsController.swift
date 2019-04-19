//
//  ViewController.swift
//  Startup Creator
//
//  Created by Diego Oruna on 4/17/19.
//  Copyright © 2019 Diego Oruna. All rights reserved.
//

import UIKit
import CoreData

class StartupsController: UITableViewController, CreateStartupControllerDelegate {
    
    fileprivate func fetchStartups(){
        let context = CoreDataManager.shared.persistantContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Startup>(entityName: "Startup")
        
        do {
            let startups = try context.fetch(fetchRequest)
            
            startups.forEach({print($0.name ?? ""); self.startups.append($0)})
            
            self.tableView.reloadData()
            
        } catch let fetchErr {
            print("Failed to fetch startups:", fetchErr.localizedDescription)
        }
    }
    
    func didAddStartup(startup: Startup) {
        startups.append(startup)
        let newIndexPath = IndexPath(row: startups.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .fade)
    }
    
    func didEditStartup(startup: Startup) {
        let row = startups.firstIndex(of: startup)
        let indexPath = IndexPath(row: row!, section: 0)
        tableView.reloadRows(at: [indexPath], with: .middle)
//        tableView.reloadData()
    }
    
    let cellId = "cellId"
    
    var startups = [Startup]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(StartupCell.self, forCellReuseIdentifier: cellId)
        tableView.backgroundColor = UIColor.darkBlue
        tableView.separatorColor = .white
        tableView.tableFooterView = UIView()
        setupNavStyle()
        fetchStartups()
    }
    
    fileprivate func setupNavStyle(){
        navigationItem.title =  "Startups"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleAddStartup))
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! StartupCell
        
        let currentStartup = startups[indexPath.row]
        cell.startup = currentStartup
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return startups.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.lightBlue
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "No Startups available..."
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return startups.count == 0 ? 150:0
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete", handler: deleteHandlerFunction)
        deleteAction.backgroundColor = UIColor.lightRed
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit", handler: editHandlerFunction)
        editAction.backgroundColor = UIColor.darkBlue
        
        return [deleteAction, editAction]
    }
    
    fileprivate func deleteHandlerFunction(action:UITableViewRowAction, indexPath:IndexPath){
        let startup = self.startups[indexPath.row]
        
        //RMV the startup from TV
        self.startups.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
        
        //RMV the startup from CD
        let context = CoreDataManager.shared.persistantContainer.viewContext
        
        context.delete(startup)
        
        do{
            try context.save()
        } catch let saveErr{
            print("Failed to delete startup", saveErr.localizedDescription)
        }
    }
    
    fileprivate func editHandlerFunction(action:UITableViewRowAction, indexPath:IndexPath){
        print("Editing startup")
        
        let startup = startups[indexPath.row]
        
        let editStartupController = CreateStartupController()
        editStartupController.delegate = self
        editStartupController.startup = startup
        
        let navController = CustomNavigationController(rootViewController: editStartupController)
    
        present(navController, animated: true, completion: nil)
    }

}

