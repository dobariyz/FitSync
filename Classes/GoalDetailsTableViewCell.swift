//
//  GoalDetailsTableViewCell.swift
//  FitSync
//
//  Created by Viraj Barvalia on 2025-04-13.
//

import UIKit

class GoalDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
        @IBOutlet weak var stepGoalLabel: UILabel!
        @IBOutlet weak var energyGoalLabel: UILabel!
        @IBOutlet weak var distanceGoalLabel: UILabel!
        @IBOutlet weak var exerciseGoalLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
