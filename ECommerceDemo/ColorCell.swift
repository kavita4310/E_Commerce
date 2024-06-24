//
//  ColorCell.swift
//  ECommerceDemo
//
//  Created by kavita chauhan on 23/06/24.
//

import UIKit

class ColorCell: UICollectionViewCell {

    @IBOutlet weak var imgColor: UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgColor.layer.cornerRadius = 28
        imgColor.layer.borderWidth = 1.5
        imgColor.layer.borderColor = UIColor.darkGray.cgColor
        
        
    }
    

}
