//
//  LeagueOptionTableViewCell.swift
//  DBLM
//
//  Created by Rudy E. Matos Perez on 2/25/16.
//  Copyright © 2016 Polygons. All rights reserved.
//

import UIKit

class LeagueOptionTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var optionLabel: UILabel!
    @IBOutlet weak var optionImage: UIImageView!
    var currentOption : Option? {
        didSet{
            configureView()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }
    
    func configureView(){
        optionLabel.text = currentOption?.name
        optionImage.image = currentOption?.image
    
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
