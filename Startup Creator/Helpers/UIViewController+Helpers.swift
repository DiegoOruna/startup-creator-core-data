//
//  UIViewController+Helpers.swift
//  Startup Creator
//
//  Created by Diego Oruna on 4/19/19.
//  Copyright © 2019 Diego Oruna. All rights reserved.
//

import UIKit

extension UIViewController{
    
    func setupPlusButtonInNavBar(selector:Selector){
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus"), style: .plain, target: self, action: selector)
    }
    
    func setupCancelButtonInNavBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
    }
    
    @objc fileprivate func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    func setupSaveButtonInNavBar(selector:Selector){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: selector)
    }
    
    func setupLightBlueBackgroundView(height:CGFloat) -> UIView{
        let lightBlueBackgroundView = UIView()
        lightBlueBackgroundView.backgroundColor = UIColor.lightBlue
        lightBlueBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(lightBlueBackgroundView)
        
        NSLayoutConstraint.activate([
                lightBlueBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                lightBlueBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
                lightBlueBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                lightBlueBackgroundView.heightAnchor.constraint(equalToConstant: height)
            ])
        return lightBlueBackgroundView
    }
    
}
