//
//  JMCFlexibleDatasource.swift
//  JMCFlexibleLayout
//
//  Created by Janusz Chudzynski on 7/9/16.
//  Copyright © 2016 izotx. All rights reserved.
//
import UIKit

/**Protocol that needs to be implemented by the cells implemented by the cells to be displayed in the layout*/
protocol JMCFlexibleCellProtocol{
    func configureWithItem(item:DataSourceItem, indexPath:NSIndexPath)
}

/**Item Selected Protocol*/
protocol JMCFlexibleCellSelection  {
    func cellDidSelected(indexPath:NSIndexPath, item:DataSourceItem)
}

/**Generic Data source item*/
class DataSourceItem: NSObject{
    
    func getSize()->CGSize{
        return CGSizeZero
    }
}

/**Not that Generic Data source item*/
class JMCDataSourceItem:DataSourceItem{
    //Image to display in the collection view cell
    var image:UIImage?
    
    // Make sure to override this method to pass the size of the element to display in the collection view cell
    override func getSize()->CGSize{
        if let image = image {
            return image.size
        }
        return CGSizeZero
    }
}


class FlexibleCollectionCell : UICollectionViewCell{
    @IBOutlet weak var imageView: UIImageView!
    func configureWithItem(item:DataSourceItem, indexPath:NSIndexPath){
        if let item = item as? JMCDataSourceItem{
            self.imageView.image = item.image
        }
    }
}

/*Datasource for the collection view*/
class JMCFlexibleCollectionViewDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    /**Layout Methods*/
    private let layoutHelper = JMCFlexibleLayout()
    /**Collection view*/
    private weak var collectionView:UICollectionView?
    
    private var cellSizes = [CGSize]()
    
    private var cellIdentifier:String
    
    var delegate: JMCFlexibleCellSelection?
    
    /**Margins around the collection view*/
    var margin:CGFloat = 25{
        didSet{
            setup()
        }
    }

    /**Spacing between the cells*/
    var spacing:CGFloat = 14{
        didSet{
            setup()
        }
    }
    /**Determines how tall can the row be*/
    var maximumRowHeight:CGFloat = 300{
        didSet{
            setup()
        }
    }
    
    /**Data source elements to display*/
    var dataItems = [JMCDataSourceItem](){
        didSet{
            setup()
        }
    }
    
    init(collectionView:UICollectionView, cellIdentifier:String) {
        self.collectionView = collectionView
        self.cellIdentifier = cellIdentifier
        super.init()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func setup(){
        collectionView?.contentInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        prepareSizes()
        collectionView?.reloadData()
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return spacing
    }
    
    //MARK: Collection view delegate
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return dataItems.count
    }
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as!  FlexibleCollectionCell
        cell.configureWithItem(dataItems[indexPath.row], indexPath: indexPath)
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    
    //MARK: Delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        delegate?.cellDidSelected(indexPath, item: dataItems[indexPath.row])
    }
    
    
    
    
    /**This method generates a dynamic grid based on the image sizes*/
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        if cellSizes.count <= indexPath.row {
            return CGSizeZero
        }
        
        return cellSizes[indexPath.row]
    }
    
    /**If for any reason you decide to deal with static sizes */
    private func staticSize(indexPath:NSIndexPath) -> CGSize {
        guard let collectionView = collectionView else {
            return CGSizeZero
        }
        let width = collectionView.frame.width
        let cellWidth = (width -  2 * margin - 1 * spacing ) * 1.0/2.0
        let cellHeight = cellWidth
        return  CGSizeMake(cellWidth, cellHeight)
    }
    
    /**Calculates size of */
    private func prepareSizes(){
        let sizes = dataItems.map({return $0.getSize()})
        let width = CGRectGetWidth(self.collectionView!.frame) - 2 * margin
        //Maximum height of the row
        let height:CGFloat = maximumRowHeight
        layoutHelper.spacing = spacing
        /**we should be calling this method only once */
        cellSizes = layoutHelper.generateGrid(sizes, maxWidth: width, maxHeight: height, viewHeight: CGRectGetHeight(collectionView!.frame)).0
    }
    
    
    deinit{
        
    }
}

