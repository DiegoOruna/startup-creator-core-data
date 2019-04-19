//
//  StartupController + CreateStartup.swift
//  Startup Creator
//
//  Created by Diego Oruna on 4/19/19.
//  Copyright © 2019 Diego Oruna. All rights reserved.
//

import UIKit

extension StartupsController:CreateStartupControllerDelegate{
    
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
    
}
