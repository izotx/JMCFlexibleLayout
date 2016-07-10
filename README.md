# JMCFlexibleCollectionLayout
> JMCFlexibleCollectionLayout is a iOS library that autoresizes collection view cells so it can display images without changing their aspect ratio. 

<!--//[![NPM Version][npm-image]][npm-url]-->
<!--//[![Build Status][travis-image]][travis-url]-->
<!--//[![Downloads Stats][npm-downloads]][npm-url]-->

The collection view is a great UI element but it doesn't handle elements with various content sizes elegantly. JMCFlexibleCollectionLayout based on customizable paramaters like spacing between cells, margins, and maximum row height calculates and displays a collection view grid. It serves role of both UICollectionViewDataSource and UICollectionViewDelegate. 

![](iPadScreenshot.png)

## Installation

iOS:

```sh
copy JMCFlexibleLayout.swift and JMCFlexibleDataSource.swift to your project 
```

## Usage example

###Step 1
At first you need to setup a collection view. You can create it programmatically or using Storyboards. 

###Step 2
Create an instance of the library and initialize it.
To initialize library you have to pass an instance of UICollectionView and the unique identifier of collection view cell. 

```swift
class ViewController: UIViewController{
    /**Instance of the JMC Flexible collection view data source */
    var datasource: JMCFlexibleCollectionViewDataSource?
        override func viewDidLoad() {
        super.viewDidLoad()
        /**Create an instance of the flexible datasource
            make sure to pass here the collection view and cell identifier
         */
        datasource  = JMCFlexibleCollectionViewDataSource(collectionView: collectionView, 
        cellIdentifier:"cell")

```


###Step 3 Provide data source items 

Data source items need to inherit from JMCDataSourceItem class. Good place to do it is in the viewDidLoad method.

```Swift

    //prepare items to display in the collection view
    var dataSourceItems = [JMCDataSourceItem]()
    for i in 0...8{
        let item = JMCDataSourceItem()
        item.image = UIImage(named: "r\(i).jpg")
        dataSourceItems.append(item)
    }
        
    //assign the items to the datasource
    datasource?.dataItems = dataSourceItems
```

###Step 4 Call the setup method
That's important. At the point when the viewDidLayoutSubviews is called, the iOS knows exactly what will be the sizes of UI elements. If called prior this point, library can produce unexpected results. 
```Swift
  override func viewDidLayoutSubviews() {
        //At this point all the views have their final dimensions so the size calculations will be accurate
        datasource?.setup()
    }
```
<img src="iPhoneScreenshot.png" alt="Drawing" width="49%"/>
<img src="iPhoneScreenshot2.png" alt="Drawing" width="49%"/>
### Step 5 
Optional Settings
You can control the look of the collection view by changing values of the following paramaters:


* maximumRowHeight - what's the maximum allowed height of the row
* margin margin around the edges of collection's view content
* spacing = spacing between the cells (rows and columns) - important currently values under 10 won't work correctly.


## Customization
Library comes with two data structures that can be subclassed to create your custom UI. 

### Subclassing DataSourceItem provided in the example project.
The items that will provide the content to collection cells view have to be subclassed from DataSourceItem class. In your implementation you need to overwrite the getSize method, and return the size of the element. For example  MyCustomDataSourceItem class is a subclass of DataSourceItem class that has an instance of UIImage associated with it: 

```swift
class MyCustomDataSourceItem:DataSourceItem{
    //Image to display in the collection view cell
    var image:UIImage?
    var description:String?    

    // Make sure to override this method to pass the size of the element to display in the collection view cell
    override func getSize()->CGSize{
        if let image = image {
            return image.size
        }
        return CGSizeZero
    }
}
```

###  Creating custom collection view cells .
To do it you have to create a data structure that inherits from FlexibleCollectionCell. 
If you decide to use your own cell, you have to override configureWithItem method and customize the look of your cell. 

```swift
class MyFlexibleCollectionCell : UICollectionViewCell{
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!    
    func configureWithItem(item:DataSourceItem, indexPath:NSIndexPath){
        if let item = item as? MyDataSourceItem{
            self.imageView.image = item.image
            self.label.text = item.description
        }
    }
}
```


## Release History

* 0.1 July 2016
    * Candidate for 1st release

## Meta

Janusz Chudzynski Izotx LLC – [@appzzman](https://twitter.com/appzzman) – janusz@izotx.com

Distributed under the BSD license. See ``LICENSE`` for more information.

[https://github.com/yourname/github-link](https://github.com/dbader/)

<!--[npm-image]: https://img.shields.io/npm/v/datadog-metrics.svg?style=flat-square-->
<!--[npm-url]: https://npmjs.org/package/datadog-metrics-->
<!--[npm-downloads]: https://img.shields.io/npm/dm/datadog-metrics.svg?style=flat-square-->
<!--[travis-image]: https://img.shields.io/travis/dbader/node-datadog-metrics/master.svg?style=flat-square-->
<!--[travis-url]: https://travis-ci.org/dbader/node-datadog-metrics-->
