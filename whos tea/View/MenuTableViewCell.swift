//
//  MenuTableViewCell.swift
//  whos tea
//
//  Created by 林靖芳 on 2024/6/29.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
    
    let drinkNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "NatsuzemiMaruGothic-Black", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let drinkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor(named: "mainColor")
        imageView.clipsToBounds = true
        return imageView
        
    }()
    
    let stackView: UIStackView = {
       let stackview = UIStackView()
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .vertical
        stackview.spacing = 4
        stackview.alignment = .center
        stackview.distribution = .fill
        return stackview
    }()
    
    var drink: Records?
        
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(drinkImageView)
        stackView.addArrangedSubview(drinkNameLabel)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            
            drinkImageView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 8),
            drinkImageView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -8),
            drinkImageView.heightAnchor.constraint(equalTo: drinkImageView.widthAnchor)
        ])
        
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        drinkImageView.layer.cornerRadius = drinkImageView.frame.width * 0.2
    }
    

    
}



