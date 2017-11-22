//
//  RightMenuCell.swift
//  PTO
//
//  Created by fiplmac1 on 23/08/16.
//  Copyright © 2016 fusion. All rights reserved.
//

import UIKit

class RightMenuCell: UITableViewCell
{
    @IBOutlet var lblMenuTitle: UILabel!
    @IBOutlet var imgMenuIcon: UIImageView!
    @IBOutlet var btnBG: UIButton!
    
    override func awakeFromNib()
    {
        btnBG.layer.cornerRadius = 3
        btnBG.clipsToBounds = true
        
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
    
}
