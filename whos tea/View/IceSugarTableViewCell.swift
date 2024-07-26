//
//  IceSugarTableViewCell.swift
//  whos tea
//
//  Created by 林靖芳 on 2024/7/2.
//

import UIKit

class IceSugarTableViewCell: UITableViewCell {
    
    let iceSugarLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont(name: "NatsuzemiMaruGothic-Black", size: 20)
        label.textColor = UIColor.black.withAlphaComponent(0.6)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let radioButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.setImage(UIImage(systemName: "circle.fill"), for: .selected)
        button.tintColor = UIColor(named: "mainColor")
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(radioButton)
        contentView.addSubview(iceSugarLabel)
      
        self.selectionStyle = .none
        
        NSLayoutConstraint.activate([
            
            radioButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            radioButton.widthAnchor.constraint(equalToConstant: 30),
            radioButton.heightAnchor.constraint(equalTo: radioButton.widthAnchor),
            radioButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            radioButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            iceSugarLabel.leadingAnchor.constraint(equalTo: radioButton.trailingAnchor, constant: 12),
            iceSugarLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 8),
            
            iceSugarLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            iceSugarLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}


