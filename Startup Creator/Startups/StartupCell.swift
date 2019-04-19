//
//  StartupCell.swift
//  Startup Creator
//
//  Created by Diego Oruna on 4/19/19.
//  Copyright © 2019 Diego Oruna. All rights reserved.
//

import UIKit

class StartupCell: UITableViewCell {
    
    var startup:Startup?{
        didSet{
            if let imageData = startup?.imageData, let name = startup?.name, let founded = startup?.founded{
                startupImageView.image = UIImage(data: imageData)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd MMM, yyyy"
                
                let foundedDateString = dateFormatter.string(from: founded)
                
                let dateString = "\(name) - Founded: \(foundedDateString)"
                
                nameFoundedDate.text = dateString
            }else{
                nameFoundedDate.text = startup?.name
            }
            
        }
    }
    
    let startupImageView:UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "select_photo_empty"))
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 20
        iv.clipsToBounds = true
        return iv
    }()
    
    let nameFoundedDate:UILabel = {
        let lbl = UILabel()
        lbl.text = "CCCCC"
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .white
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    fileprivate func setupLayout(){
        addSubview(startupImageView)
        addSubview(nameFoundedDate)
        
        NSLayoutConstraint.activate([
                startupImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                startupImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
                startupImageView.widthAnchor.constraint(equalToConstant: 40),
                startupImageView.heightAnchor.constraint(equalToConstant: 40),
                
                nameFoundedDate.leadingAnchor.constraint(equalTo: startupImageView.trailingAnchor, constant: 8),
                nameFoundedDate.centerYAnchor.constraint(equalTo: centerYAnchor),
//                nameFoundedDate.topAnchor.constraint(equalTo: topAnchor),
//                nameFoundedDate.bottomAnchor.constraint(equalTo: bottomAnchor),
                nameFoundedDate.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
        
        backgroundColor = UIColor.tealColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
