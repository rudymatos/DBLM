//
//  SelectTeamTableViewCell.swift
//  DBLM
//
//  Created by Rudy E. Matos Perez on 2/23/16.
//  Copyright © 2016 Polygons. All rights reserved.
//

import UIKit

class SelectLeagueTableViewCell: UITableViewCell {
    
    @IBOutlet weak var leagueNameLabel: UILabel!
    @IBOutlet weak var nextGamesDateLabel: UILabel!
    @IBOutlet weak var membersConfirmedLabel: UILabel!
    @IBOutlet weak var currentUserRoleLabel: UILabel!
    @IBOutlet weak var leagueLogoImage: UIImageView!
    var currentLeagueRole : LeagueRole?{
        didSet{
            self.configureView()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func configureView(){
        ImageConfiguration().transformImage(leagueLogoImage, shape: Shape.Square(0.5, UIColor.blackColor()))
        leagueNameLabel.text = currentLeagueRole?.league?.name!.uppercaseString
        nextGamesDateLabel.text = "Schedule not yet opened".uppercaseString
        if let playerNumber = currentLeagueRole?.playerNumber , let playerPosition = currentLeagueRole?.playerPosition{
            membersConfirmedLabel.text = "Player #\(playerNumber) Position \(playerPosition)".uppercaseString
        }else{
            membersConfirmedLabel.text = "PLAYER IS NEW IN THE LEAGUE"
        }
        currentUserRoleLabel.text = currentLeagueRole?.role
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
