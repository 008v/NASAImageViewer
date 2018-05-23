//
//  ItemTableViewCell.swift
//  Demo
//
//  Created by 秦伟 on 2018/5/23.
//  Copyright © 2018 秦伟. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    @IBOutlet weak var leftImgView: UIImageView!
    @IBOutlet weak var rightImgView: UIImageView!
    var clickCallback: ((Bool)->())?
    var isLeft = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        leftImgView.layer.cornerRadius = 6.0
        rightImgView.layer.cornerRadius = 6.0
        leftImgView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(clickLeft)))
        rightImgView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(clickRight)))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func clickLeft() {
        isLeft = true
        if let cb = clickCallback {
            cb(isLeft)
        }
    }
    
    @objc func clickRight() {
        isLeft = false
        if let cb = clickCallback {
            cb(isLeft)
        }
    }
    
}
