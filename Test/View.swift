//
//  View.swift
//  Test
//
//  Created by sanju on 07/09/22.
//

import Foundation
import UIKit


class JokesCell:UITableViewCell{
    var jokeLabel:UILabel = UILabel()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(jokeLabel)
        jokeLabel.textColor = .black
        jokeLabel.numberOfLines = 0
        jokeLabel.font = UIFont.systemFont(ofSize: 20)
        jokeLabel.translatesAutoresizingMaskIntoConstraints = false
        jokeLabel.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 10).isActive = true
        jokeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: 10).isActive = true
        jokeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 8).isActive = true
        jokeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: 8).isActive = true
//            contentView.backgroundColor = .white
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
}
