//
//  MemberListTableViewCell.swift
//  DBLM
//
//  Created by Rudy E. Matos Perez on 3/28/16.
//  Copyright © 2016 Polygons. All rights reserved.
//

import UIKit

class MemberListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var playerNumberLabel: UILabel!
    @IBOutlet weak var playerPositionLabel: UILabel!
    @IBOutlet weak var playerRoleLabel: UILabel!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var playerImageView: UIImageView!
    var member : Member?{
        didSet{
            configureView()
        }
    }
    
    private let imageConfigurator = ImageConfiguration()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureView()
    }
    
    func configureView(){
        
        imageConfigurator.transformImage(playerImageView, shape: Shape.Circle(0.5, UIColor.blackColor()))
//        imageConfigurator.transformImage(playerPositionImageView, shape: Shape.Square(3.0, UIColor.whiteColor()))
//        imageConfigurator.transformImage(playerNumberImageView, shape: Shape.Square(3.0, UIColor.whiteColor()))
        
        if member != nil{
            playerNameLabel?.text = (member?.firstname)! + " " + (member?.lastname)!
//            member.le
        }
        
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
