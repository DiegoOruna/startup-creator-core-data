//
//  StartupController+UITableView.swift
//  Startup Creator
//
//  Created by Diego Oruna on 4/19/19.
//  Copyright © 2019 Diego Oruna. All rights reserved.
//

import UIKit

extension StartupsController{
    
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
