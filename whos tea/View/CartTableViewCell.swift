//
//  CartTableViewCell.swift
//  whos tea
//
//  Created by 林靖芳 on 2024/7/5.
//

import UIKit

class CartTableViewCell: UITableViewCell {
    
   var drinkLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "NatsuzemiMaruGothic-Black", size: 24)
        return label
        
    }()
    
    var sugarIceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "NatsuzemiMaruGothic-Black", size: 12)
        return label
        
    }()
    
    var totalPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "GillSans-SemiBold", size: 24)
        label.textAlignment = .left
        return label
        
    }()
    
    var qtyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "NatsuzemiMaruGothic-Black", size: 12)
        return label
        
    }()
    
    var unitPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "NatsuzemiMaruGothic-Black", size: 12)
        return label
        
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "NatsuzemiMaruGothic-Black", size: 12)
        return label
        
    }()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor(named: "mainColor")
        
        contentView.addSubview(drinkLabel)
        contentView.addSubview(sugarIceLabel)
        contentView.addSubview(totalPriceLabel)
        contentView.addSubview(qtyLabel)
        contentView.addSubview(unitPriceLabel)
        contentView.addSubview(nameLabel)
        
        
        
        //auto layout
        NSLayoutConstraint.activate([
            
            drinkLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            drinkLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            
            sugarIceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            sugarIceLabel.topAnchor.constraint(equalTo: drinkLabel.bottomAnchor, constant: 4),
         
            
            qtyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            qtyLabel.topAnchor.constraint(equalTo: sugarIceLabel.bottomAnchor, constant: 4),
      
            
            unitPriceLabel.leadingAnchor.constraint(equalTo: qtyLabel.trailingAnchor),
            unitPriceLabel.topAnchor.constraint(equalTo: sugarIceLabel.bottomAnchor, constant: 4),
            
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            nameLabel.topAnchor.constraint(equalTo: qtyLabel.bottomAnchor, constant: 4),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            totalPriceLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            totalPriceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
    //        totalPriceLabel.leadingAnchor.constraint(equalTo: drinkLabel.trailingAnchor, constant: 12)
            
        ])
        
     //   totalPriceLabel.setContentHuggingPriority(UILayoutPriority(251), for: .horizontal)
      //  drinkLabel.setContentHuggingPriority(UILayoutPriority(250), for: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
