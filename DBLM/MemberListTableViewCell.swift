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
    private let userHelper  = UserHelper.createStaticInstance
    var leagueMember : (currentLeague : League, currentMember: Member)?{
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
        if leagueMember != nil{
            playerNameLabel?.text = (leagueMember?.currentMember.firstname)! + " " + (leagueMember?.currentMember.lastname)!
            for leagueRole in (leagueMember?.currentMember.leaguesRoles)!{
                
                if let leagueObjectId = leagueRole.league?.name, let currentLeagueObjectId = leagueMember?.currentLeague.name{
                    print("entering here")
                    print("checking league role : \(leagueObjectId)")
                    print("checking current league : \(currentLeagueObjectId)")
                    if leagueObjectId == currentLeagueObjectId{
                        playerPositionLabel?.text = leagueRole.playerPosition
                        playerNumberLabel?.text = "\(leagueRole.playerNumber!)"
                        playerRoleLabel?.text = leagueRole.role
                        break
                    }
                }
                
            }
        }
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
