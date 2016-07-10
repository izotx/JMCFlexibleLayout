//
//  JMCFlexibleLayout.swift
//  PerfecTour
//
//  Created by Janusz Chudzynski on 2/18/16.
//  Copyright © 2016 PerfecTour. All rights reserved.
//

import UIKit
/**Class responsible for calculating size of the cells based on available width and maximum height*/
class JMCFlexibleLayout{
    
    var spacing:CGFloat = 10{
        didSet{
            sizes = generateGrid(sizes, maxWidth: maxWidth, maxHeight: maxHeight).0
        }
    }
    
    /**Defualt maximum height of line */
    var maxHeight:CGFloat = 300{
        didSet{
            sizes = generateGrid(sizes, maxWidth: maxWidth, maxHeight: maxHeight).0
        }
    }
    
    /**Defualt maximum width of the container */
    var maxWidth:CGFloat=0{
        didSet{
            sizes = generateGrid(sizes, maxWidth: maxWidth, maxHeight: maxHeight).0
        }
    }
    
    
    
    /**Views*/
    var views = [UIView]()
    var sizes = [CGSize](){
        didSet{
            sizes = generateGrid(sizes, maxWidth: maxWidth, maxHeight: maxHeight).0
        }
    }
    
    /**Get's size of the item based on inded in array*/
    func getSizeOfItem(index:Int)->CGSize{
        return sizes[index]
    }
    
    /**
     Generates new frames and assigns them to passed views
     - paramater views - array of views
     - paramater height height of the row constraining the view
     - paramater rowY - y coordinate of the view
     
     */
    func generateNewFrames(views:[UIView], height:CGFloat,  rowY:CGFloat){
        //add vertical spacing
        var x:CGFloat = spacing
        for v in views{
            //just to have a different colors
            v.backgroundColor = JMCFlexibleLayout.generateRandomColor()
            //calculate frames
            let w = calculateNewWidth(v, height: height)
            let frame = CGRectMake(x, rowY, w, height)
            x = spacing + x + w
            v.frame = frame
        }
    }
    
    /**Generates new sizes for array of views constrained to a given height - Represents the single row*/
    func generateNewSizes(sizes:[CGSize], height:CGFloat)->[CGSize]{
        var adjustedSizes = [CGSize]()
        for v in sizes{
            //calculate frames
            let width = calculateNewWidth(v, height: height)
            adjustedSizes.append(CGSizeMake(width,height))
        }
        return adjustedSizes
    }
    
    
    /**Renders Grid of UIViews on a screen*/
    func renderGrid(grid:[Int:[UIView]],inView view:UIView){
        for (_,views) in grid{
            for v in views{
                view.addSubview(v)
            }
        }
    }
    
    
    /**Calculates height of the row based on passed array of CGSizes*/
    func calculateNewHeight(views:[CGSize], maxWidth:CGFloat)->CGFloat{
        var aspect:CGFloat = 0
        for v in views{
            let h = v.height
            let w = v.width
            let newAspect = w/h
            aspect += newAspect
        }
        return maxWidth/aspect
    }
    
    
    /*Debugging */
    func printRow( row:[CGSize])->[CGSize]{
        var sum:CGFloat = 0
        var newSum:CGFloat = 0
        
        let newRow = row.map({CGSizeMake($0.width * 0.999, $0.height)})
        var index = 0
        for e in row{
            sum += e.width
            
            newSum += e.width
            index += 1
        }
        
        
        return newRow
    }
    
    
    
    /**Function that generates a grid based on passed dimensions (Sizes)*/
    func generateGrid(sizes:[CGSize], maxWidth:CGFloat, maxHeight:CGFloat, viewHeight:CGFloat = 0 )->([CGSize],[[CGSize]]){
        //current row
        // another item
        // while height > threshold keep adding
        var grid = [CGSize]()
        var twoDGrid = [[CGSize]]()
        
        var currentRow = [CGSize]()
        var threshold:CGFloat = maxHeight
        
        //For housekeeping purposes what if number of cells is less than 4?
        if sizes.count <= 4{
            //threshold =
            threshold = viewHeight / 2.0
        }
        
        for v in sizes{
            var newArray:[CGSize] = currentRow
            newArray.append(v)
            
            //check the adjusted width of all elements based on spacing an number of elements
            let adjustedMaxWidth =  maxWidth - CGFloat(newArray.count-1) * spacing
            let height = calculateNewHeight(newArray, maxWidth: adjustedMaxWidth )
            
            if height <= threshold{
                //Magic number for some reason it doesn't fit if we don't shrink it here
                let adjustedSizes = generateNewSizes(newArray, height: 0.999 * height)
//                let adjustedSizes = generateNewSizes(newArray, height: 1 * height)
                
                grid = grid + adjustedSizes
                
                twoDGrid.append(adjustedSizes)
                
                currentRow.removeAll()
            }
            else{
                currentRow = newArray
                
            }
        }
        
        /**House keeping*/
        let adjustedSizes = generateNewSizes(currentRow, height: threshold)
        grid = grid + adjustedSizes
        
        
        return (grid, twoDGrid)
    }
    
    
    
    /**
     Generates a two dimensional grid of UIViews
     // step 1 get list of all views
     // add it to the processing one by one if the height is more than threshold keep adding
     // if it is less then a threshold render a row
     */
    
    func generateGrid(views:[UIView], maxWidth:CGFloat, maxHeight:CGFloat)->[Int:[UIView]]{
        //current row
        // another item
        // while height > threshold keep adding
        var grid = [Int:[UIView]]()
        var currentRow = [UIView]()
        
        //Maximum height threshold
        var threshold:CGFloat = maxHeight
        
        //Maximum height threshold whenever items are less th
        if views.count < 4{
            threshold = 400
        }
        
        var rowCount = 0
        var rowY:CGFloat = 0// keep track of the row Y coordinates
        
        
        for v in views{
            var newArray:[UIView] = currentRow
            newArray.append(v)
            let adjustedMaxWidth = maxWidth - CGFloat(newArray.count + 1) * spacing
            
            
            let height = calculateNewHeight(newArray, maxWidth: adjustedMaxWidth )
            
            if height <= threshold{
                grid[rowCount] = newArray
                newArray.count
                //increment row number
                rowCount += 1
                //update frames based on height
                generateNewFrames(newArray, height: height, rowY: rowY + spacing)
                rowY += height + spacing
                //reset the row
                currentRow.removeAll()
            }
            else{
                currentRow = newArray
            }
        }
        
        /**House keeping*/
        generateNewFrames(currentRow, height:threshold, rowY: rowY + spacing)
        grid[rowCount] = currentRow
        
        currentRow.count
        
        
        return grid
    }
    
    
    /**Scales entire UIIMage to fit the size - it doesn't care about the aspect ratio*/
    func scaleUIImageToSize(let image: UIImage, let size: CGSize) -> UIImage {
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        image.drawInRect(CGRect(origin: CGPointZero, size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    
    /**Returns size of the image scaled to fit square of side widht equal to maxSide*/
    func scaledSize(let image: UIImage, maxSide:CGFloat) -> CGSize {
        
        
        let w = image.size.width
        let h = image.size.height
        var scaleFactor:CGFloat = 0
        var newWidth:CGFloat = 0
        var newHeight:CGFloat = 0
        
        if max(w,h) < maxSide{
            return image.size
        }
        
        if w > h {
            scaleFactor =  maxSide / w
            
        }
        else{
            scaleFactor = maxSide / h
        }
        newWidth = w * scaleFactor
        newHeight = h * scaleFactor
        
        return CGSizeMake(newWidth, newHeight)
        
    }
    
    
    /**Calculates new height of the row for given array of views */
    func calculateNewHeight(views:[UIView], maxWidth:CGFloat)->CGFloat{
        let sizes:[CGSize] = views.map({(v) in return v.frame.size})
        return calculateNewHeight(sizes, maxWidth: maxWidth)
    }
    
    func calculateNewWidth(view:UIView, height:CGFloat)->CGFloat{
        
        let w = CGRectGetWidth(view.frame ) * height / CGRectGetHeight(view.frame)
        return w
    }
    
    func calculateNewWidth(size:CGSize, height:CGFloat)->CGFloat{
        
        let w = size.width * height / size.height
        return w
    }
    
    /**
     Generates random views
     - parameter count number of views to generate
     - returns: generated views
     */
    
    func generateRandomViews(count:Int)->[UIView]{
        var views = [UIView]()
        for _ in 0..<count {
            let v = UIView(frame:self.generateRandomFrame())
            v.backgroundColor = JMCFlexibleLayout.generateRandomColor()
            v.contentMode = .ScaleAspectFit
            v.layer.borderColor = UIColor.whiteColor().CGColor
            v.layer.borderWidth = 2.0
            v.layer.cornerRadius = 2
            views.append(v)
        }
        return views
    }
    
    
    
    /**Generates random frames. It's used for testing purposes */
    func generateRandomFrame()->CGRect{
        let x:CGFloat = 0
        let y:CGFloat = 0
        let width:CGFloat = 400 + CGFloat(arc4random_uniform(500))
        let height:CGFloat = 300 + CGFloat(arc4random_uniform(500))
        let frame = CGRectMake(x, y, width, height)
        return frame
    }
    
    
    
    /**Generates random color*/
    static func generateRandomColor()->UIColor{
        let r = Float(Float(arc4random()) / Float(UINT32_MAX))
        let g = Float(Float(arc4random()) / Float(UINT32_MAX))
        let b = Float(Float(arc4random()) / Float(UINT32_MAX))
        return UIColor(colorLiteralRed: r, green: g, blue: b, alpha: 1)
    }
    
}
