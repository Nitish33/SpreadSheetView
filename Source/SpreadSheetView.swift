//
//  RegularGridCollectionView.swift
//  FirebaseDemo
//
//  Created by Nitish Prasad on 09/08/19.
//  Copyright © 2019 quovantis. All rights reserved.
//

import UIKit

class SpreadSheetView: UICollectionView
{
    var dataSourceDelegate  : SpreadSheetDataSourceDelegate?;
    var selectionDeleage    : SpreadSheetSelectionDelegate?;
    var layoutDelegate      : SpreadSheetLayoutDelegate?{
        didSet{
            setParamForLayout();
        }
    }
    
    var sectionSize = CGSize(width: 100, height: 50);
    var rowSize     = CGSize(width: 100, height: 50);
    var dataSize    = CGSize(width: 100, height: 50);
    
    var layoutManager = SpreadSheetLayoutManager();
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder);
        commonInit();
        setDelegate();
    }

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout)
    {
        super.init(frame: frame, collectionViewLayout: layoutManager);
        commonInit();
        setDelegate();
    }
    
    func commonInit(){
        self.collectionViewLayout = layoutManager;
    }
    
    func setDelegate(){
        delegate    = self;
        dataSource = self;
    }
    
    func setParamForLayout(){
        layoutManager.columnSize    = layoutDelegate?.sizeOfColumnCell();
        layoutManager.rowSize       = layoutDelegate?.sizeOfRowCell();
        layoutManager.cellSize      = layoutDelegate?.sizeOfDataCell();
    }
    
    override func reloadData()
    {
        layoutManager.shouldComputeAttributes = true;
        super.reloadData();
    }
}

extension SpreadSheetView : UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return (dataSourceDelegate?.noOfColumns() ?? 0) + 1;
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int
    {
        return (dataSourceDelegate?.noOfRow() ?? 0)+1;
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let row = indexPath.row;
        let section = indexPath.section;
        
        // empty right top cell
        if(section == 0 && row == 0){
           return dataSourceDelegate?.cellForPivot(gridCollectionView: self)
            ?? UICollectionViewCell();
        }
        
        // section cell
        else if(row == 0)
        {
        return dataSourceDelegate?.cellForColumn(gridCollectionView: self, at: section-1)
                ?? UICollectionViewCell();
        }
        
        else if(section == 0){
            return dataSourceDelegate?.cellForRow(gridCollectionView: self, at: row-1)
                ?? UICollectionViewCell();
        }
        
        let newIndexPath = IndexPath(row: row-1, section: section-1);
        return dataSourceDelegate?.cellForIndex(gridCollectionView: self, at: newIndexPath)
            ?? UICollectionViewCell();
    }
}

extension SpreadSheetView : UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath)
    {
        let row = indexPath.row;
        let section = indexPath.section;
        
        // empty right top cell
        if(section == 0 && row == 0)
        {
            return;
        }
        
        // section cell
        else if(row == 0)
        {
            selectionDeleage?.columnSelectedAt(index: section-1);
        }
            
        else if(section == 0){
            selectionDeleage?.rowSelectedAt(index: row-1);
        }
        
        else{
            let newIndexPath = IndexPath(row: row-1, section: section-1);
            selectionDeleage?.cellSelectedAt(index: newIndexPath);
        }
       
    }
}

