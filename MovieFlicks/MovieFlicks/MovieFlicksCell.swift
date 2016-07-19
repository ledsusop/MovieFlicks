//
//  MovieFlicksCell.swift
//  MovieFlicks
//
//  Created by Ledesma Usop Jr. on 7/18/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class MovieFlicksCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var movieFlicksImageView: UIImageView!
    
    override func awakeFromNib() {
       
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
