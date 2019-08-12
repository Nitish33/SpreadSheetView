//
//  CollectionViewGridLayout.swift
//  FirebaseDemo
//
//  Created by Nitish Prasad on 09/08/19.
//  Copyright © 2019 quovantis. All rights reserved.
//

import UIKit

class SpreadSheetLayoutManager : UICollectionViewLayout
{
    static let defaultCellWidth    = CGFloat(100);
    static let defaultCellHeight   = CGFloat(100);
    
    var columnSize  : CGSize?
    var rowSize     : CGSize?;
    var cellSize    : CGSize?;
    
    // this is changed by the regulargriecollectionview in onReloadData() method
    var shouldComputeAttributes = true{
        didSet{
            isBoundChanged = false;
        }
    };
    
    // this is to control the non-scrolling behaviour of headers.
    // this is set to true only when we are finished creating cache
    var isBoundChanged = false;
    
    var layoutAttributeCache = [IndexPath:UICollectionViewLayoutAttributes]();
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override init() {
        super.init();
    }
    
    override var collectionViewContentSize: CGSize
    {
        let count = getRowColumnCount();
        
        let rowWidth     = rowSize?.width       ?? SpreadSheetLayoutManager.defaultCellWidth;
        let columnHeight = columnSize?.height   ?? SpreadSheetLayoutManager.defaultCellHeight;
        let cellWidth    = cellSize?.width      ?? SpreadSheetLayoutManager.defaultCellWidth;
        let cellHeight   = cellSize?.height     ?? SpreadSheetLayoutManager.defaultCellHeight;
        
        let totalWidth  = rowWidth      + CGFloat(count.column-1)*cellWidth;
        let totalHeight = columnHeight  + CGFloat(count.rows-1)  * cellHeight;
        
        return CGSize(width: totalWidth, height: totalHeight);
    }
    
    override func prepare()
    {
        guard  let collectionView = collectionView
            else {
                return
        }
        
         let count = getRowColumnCount();
        
        let rowWidth     = rowSize?.width       ?? SpreadSheetLayoutManager.defaultCellWidth;
        let rowHeight    = rowSize?.height      ?? SpreadSheetLayoutManager.defaultCellWidth;
        let columnWidth  = columnSize?.width    ?? SpreadSheetLayoutManager.defaultCellHeight;
        let columnHeight = columnSize?.height   ?? SpreadSheetLayoutManager.defaultCellHeight;
        let cellWidth    = cellSize?.width      ?? SpreadSheetLayoutManager.defaultCellWidth;
        let cellHeight   = cellSize?.height     ?? SpreadSheetLayoutManager.defaultCellHeight;
        
        let collectionXOffset = collectionView.contentOffset.x
        let collectionYOffset = collectionView.contentOffset.y
        
        if(isBoundChanged){
          
            for row in 0..<count.rows
            {
                for section in 0..<count.column
                {
                    let index = IndexPath(row: row, section: section);
                
                    let attribute   = layoutAttributeCache[index]!;
                    var frame       = attribute.frame;
                    
                    if(row == 0 && section == 0)
                    {
                        frame.origin.x = collectionXOffset;
                        frame.origin.y = collectionYOffset;
                        
                        attribute.frame = frame;
                        layoutAttributeCache[index] = attribute;
                    }
                        
                    else if(row == 0)
                    {
                        frame.origin.y = collectionYOffset;
                        attribute.frame = frame;
                        
                    }
                        
                    else if(section == 0)
                    {
                        frame.origin.x = collectionXOffset;
                        attribute.frame = frame;
                    }
                    
                    setAttributeElevation(section, row,attribute);
                    layoutAttributeCache[index] = attribute;
                    
                }
            }
            
            return;
        }
        
        
        if !shouldComputeAttributes
        {
            return;
        }
        
        shouldComputeAttributes = false;
        layoutAttributeCache.removeAll();
        
        for row in 0..<count.rows
        {
            for section in 0..<count.column
            {
                let index = IndexPath(row: row, section: section);
                
                var xOffSet = CGFloat(0);
                var yOffSet = CGFloat(0);
                var width   = CGFloat(0);
                var height  = CGFloat(0);
                
                if(row == 0 && section == 0)
                {
                    xOffSet = collectionXOffset;
                    yOffSet = collectionYOffset;
                    width   = rowWidth;
                    height  = columnHeight;
                }
                
                else if(row == 0)
                {
                    xOffSet = rowWidth + (CGFloat(section-1) * columnWidth);
                    yOffSet = collectionYOffset;
                    width   = columnWidth;
                    height  = columnHeight;
                }
                
                else if(section == 0)
                {
                    xOffSet = collectionXOffset;
                    yOffSet = columnHeight + (CGFloat(row-1) * rowHeight);
                    width   = rowWidth;
                    height  = rowHeight;
                }
                
                else{
                    xOffSet = rowWidth + (CGFloat(section-1) * columnWidth);
                    yOffSet = columnHeight + (CGFloat(row-1) * rowHeight);
                    width   = cellWidth;
                    height  = cellHeight;
                }
                
                let frame = CGRect(x: xOffSet, y: yOffSet, width: width, height: height);
                let insetFrame = frame.insetBy(dx: 1, dy: 1);
                
                let attribute   = UICollectionViewLayoutAttributes(forCellWith: index);
                attribute.frame = insetFrame;
                
                setAttributeElevation(section, row,attribute);
                layoutAttributeCache[index] = attribute;
                
            }
        }
        
        isBoundChanged = true;
    }
    
    fileprivate func setAttributeElevation(_ section: Int, _ row: Int ,
                                           _ attributes : UICollectionViewLayoutAttributes)
    {
        if( section == 0 && row == 0){
            attributes.zIndex = 4;
        }
        else if(section == 0){
            attributes.zIndex = 3;
        }
        else if(row == 0){
            attributes.zIndex = 2;
        }
        else {
            attributes.zIndex = 1;
        }
    }
    
    func getRowColumnCount() -> (rows : Int ,column : Int){
        
        guard  let collectionView =  collectionView
            else {
                return (0,0);
            }
        
        // row and count is of size atlease one , because of its implementation in
        // RegularGridCollectionView
        let section = collectionView.numberOfSections;
        let row  = collectionView.numberOfItems(inSection: 0);
        
        return (row,section);
    }
    
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]?
    {
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes in layoutAttributeCache.keys
        {
            let cell = layoutAttributeCache[attributes]!;
     
            if cell.frame.intersects(rect)
            {
                visibleLayoutAttributes.append(cell);
            }
        }
        
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath)
        -> UICollectionViewLayoutAttributes?
    {
        return layoutAttributeCache[indexPath]
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect)
        -> Bool
    {
        return true;
    }

    
}
