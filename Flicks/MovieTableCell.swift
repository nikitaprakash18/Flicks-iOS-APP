//
//  MovieTableCell.swift
//  Flicks
//
//  Created by NikitaPrakash Patil on 6/6/18.
//  Copyright © 2018 NikitaPrakash Patil. All rights reserved.
//

import UIKit

class MovieTableCell: UITableViewCell {
    
    
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieOverview: UITextView!
    
    @IBOutlet weak var CustomCell: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
