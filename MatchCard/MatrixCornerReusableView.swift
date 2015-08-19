//
//  MatrixCornerReusableView.swift
//  MatchCard
//
//  Created by EDGARDO AGNO on 19/08/2015.
//  Copyright (c) 2015 EDGARDO AGNO. All rights reserved.
//

import Foundation

/*
    The section header of the collection view inside the horizontal scrolling Away players collection view (MatchPlayersReusableView), which serves as the upper left corner of the matrix columns and rows.
*/

class MatrixCornerReusableView : UICollectionReusableView {
    struct Collection {
        static let Kind = "UICollectionElementKind_MatrixCornerReusableView"
        static let ReuseIdentifier = "MatrixCornerReusableView"
        static let Nib = Collection.ReuseIdentifier
        struct Cell {
            static let Width = CGFloat(UIScreen.mainScreen().bounds.size.width / 4 + 1) // there's a 1 gap in iphone 6...
            static let Height = MatchPlayersReusableView.Collection.Cell.Height
            static let Size = CGSizeMake(Width, Height)
        }
    }    
    
    @IBOutlet weak var diagonalLineImage: UIImageView!
    @IBOutlet weak var homeScore: UILabel!
    @IBOutlet weak var homeTeam: UILabel!
    @IBOutlet weak var awayScore: UILabel!
    @IBOutlet weak var awayTeam: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        diagonalLineImage.image = getDiagonalLine()
    }
    
    func getDiagonalLine() -> UIImage {
        
        let w = Collection.Cell.Width
        let h = Collection.Cell.Height
        
        // Some core graphics manipulation
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(w, h), false, 1.0)
        var context = UIGraphicsGetCurrentContext()
        
        UIColor.whiteColor().set()
        CGContextSetLineWidth(context, 0.5)
        CGContextMoveToPoint(context, 0.0, 0.0)
        CGContextAddLineToPoint(context, w, h)
        CGContextStrokePath(context)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
