//
//  ViewController.swift
//  JMCFlexibleLayout
//
//  Created by Janusz Chudzynski on 7/9/16.
//  Copyright © 2016 izotx. All rights reserved.
//

import UIKit

/**var classString = NSStringFromClass(self.dynamicType)
 Using that string, you can create an instance of your Swift class by executing:
 
 var anyobjectype : AnyObject.Type = NSClassFromString(classString)
 var nsobjectype : NSObject.Type = anyobjectype as NSObject.Type
 var rec: AnyObject = nsobjectype()**/



class ViewController: UIViewController{
    /**Instance of the JMC Flexible collection view data source */
    var datasource: JMCFlexibleCollectionViewDataSource?
    
    /**Outlets*/
    @IBOutlet weak var spacingTextField: UITextField!
    @IBOutlet weak var marginTextField: UITextField!
    @IBOutlet weak var maximumHeightTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionControls: UIStackView!
    
    var tapGesture:UITapGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /**Register collection view cell */
        collectionView.registerClass(FlexibleCollectionCell.self, forCellWithReuseIdentifier: "cell")
 
        /** Create an instance of the flexible datasource make sure to pass here the collection view and cell identifier */
        datasource  = JMCFlexibleCollectionViewDataSource(collectionView: collectionView, cellIdentifier:"cell")
        
        //prepare items to display in the collection view
        var dataSourceItems = [JMCDataSourceItem]()
 
        for i in 0...8{
            let item = JMCDataSourceItem()
            item.image = UIImage(named: "r\(i).jpg")
            dataSourceItems.append(item)
        }
        
        //assign the items to the datasource
        datasource?.dataItems = dataSourceItems

        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(
            self,
            selector: #selector(updateUI),
            name:UITextFieldTextDidChangeNotification,
            object: nil
        )
    
        
        collectionControls.hidden = true
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        tapGesture?.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture!)
    }

    /**Show/hide the controls*/
    func viewTapped(){
        collectionControls.hidden = !collectionControls.hidden
    }
    
    override func viewDidLayoutSubviews() {
        //At this point all the views have their final dimensions so the size calculations will be accurate
        datasource?.setup()
    }

    
    /**Updates UI - example of what happens when you play with paramaters. */
    func updateUI(){
        var spacing = CGFloat((spacingTextField.text! as NSString).floatValue)
        let margin = CGFloat((marginTextField.text! as NSString).floatValue)
        var maxH = CGFloat(( maximumHeightTextField.text! as NSString).floatValue)

        //min row height 50 so it won'd dissappear from view
        if maxH < 50 {
            maxH = 50
        }

        if spacing < 10 {
            spacing = 10
        }

        
        datasource?.maximumRowHeight = maxH
        datasource?.margin = margin
        datasource?.spacing = spacing
    }
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        updateUI()
        
        return true
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

