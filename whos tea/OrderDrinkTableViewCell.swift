//
//  OrderDrinkTableViewCell.swift
//  whos tea
//
//  Created by 林靖芳 on 2024/7/2.
//

import UIKit

class OrderDrinkTableViewCell: UITableViewCell {

    let drinkImageView: UIImageView = {
        
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFit
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.backgroundColor = UIColor(named: "mainColor")
       
        return imageview
    }()
    
    let drinkLabel: UILabel = {
       
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "NatsuzemiMaruGothic-Black", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(drinkLabel)
        contentView.addSubview(drinkImageView)
        
        self.selectionStyle = .none
        self.selectedBackgroundView?.backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            
            drinkLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            drinkLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            drinkLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            drinkLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            drinkImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            drinkImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            drinkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            drinkImageView.topAnchor.constraint(equalTo: drinkLabel.bottomAnchor, constant: 12),
            drinkImageView.heightAnchor.constraint(equalTo: drinkImageView.widthAnchor),
            drinkImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
