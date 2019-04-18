//
//  ViewController.swift
//  Startup Creator
//
//  Created by Diego Oruna on 4/17/19.
//  Copyright © 2019 Diego Oruna. All rights reserved.
//

import UIKit

class StartupsController: UITableViewController, CreateStartupControllerDelegate {
    
    func didAddStartup(startup: Startup) {
        startups.append(startup)
        let newIndexPath = IndexPath(row: startups.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    let cellId = "cellId"
    
    var startups = [
        Startup(name: "Uber", founded: Date()),
        Startup(name: "Rappi", founded: Date()),
        Startup(name: "Platzi", founded: Date()),
        Startup(name: "Glovo", founded: Date())
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.backgroundColor = UIColor.darkBlue
        tableView.separatorColor = .white
        setupNavStyle()
    }
    
    fileprivate func setupNavStyle(){
        
        navigationItem.title =  "Startups"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleAddStartup))
    }
    
    @objc fileprivate func handleAddStartup(){
        let createStartupController = CreateStartupController()
        createStartupController.delegate = self
        let navController = CustomNavigationController(rootViewController: createStartupController)
        present(navController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let startup = startups[indexPath.row]
        
        cell.textLabel?.text = startup.name
        cell.backgroundColor = UIColor.tealColor
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return startups.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.lightBlue
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

}

