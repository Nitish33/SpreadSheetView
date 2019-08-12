//
//  RegularGridCollectionDelegate.swift
//  FirebaseDemo
//
//  Created by Nitish Prasad on 09/08/19.
//  Copyright © 2019 quovantis. All rights reserved.
//

import UIKit

protocol SpreadSheetDataSourceDelegate
{
    func noOfColumns()->Int;
    func noOfRow()->Int;
    
    func cellForIndex(gridCollectionView:SpreadSheetView,
                      at index : IndexPath)->UICollectionViewCell;
    
    func cellForColumn(gridCollectionView:SpreadSheetView,
                       at index :Int) ->UICollectionViewCell;

    func cellForRow(gridCollectionView : SpreadSheetView,
                    at index : Int) ->UICollectionViewCell;
    
    func cellForPivot(gridCollectionView: SpreadSheetView)
    ->UICollectionViewCell;
    
}

protocol SpreadSheetSelectionDelegate
{
    func columnSelectedAt(index:Int);
    func rowSelectedAt(index:Int);
    func cellSelectedAt(index:IndexPath);
}

protocol SpreadSheetLayoutDelegate
{
    func sizeOfColumnCell()->CGSize;
    func sizeOfRowCell()->CGSize;
    func sizeOfDataCell()->CGSize;
}


