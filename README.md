# JMCFlexibleCollectionLayout
> JMCFlexibleCollectionLayout is a iOS library that autoresizes collection view cells so it can display images without changing their aspect ratio. 

<!--//[![NPM Version][npm-image]][npm-url]-->
<!--//[![Build Status][travis-image]][travis-url]-->
<!--//[![Downloads Stats][npm-downloads]][npm-url]-->

The collection view is a great UI element but it doesn't handle elements with various content sizes elegantly. JMCFlexibleCollectionLayout based on customizable paramaters like spacing between cells, margins, and maximum row height calculates and displays a collection view grid.  

![](iPadScreenshot.png)

## Installation

iOS:

```sh
copy JMCFlexibleLayout.swift and JMCFlexibleDataSource.swift to your project 
```

## Usage example

###Step 1
At first you need to have a collection view. You can create it programmatically or using Storyboards. 

###Step 2
Create an instance of the library and initialize it.

```swift
class ViewController: UIViewController{
    /**Instance of the JMC Flexible collection view data source */
    var datasource: JMCFlexibleCollectionViewDataSource?
```

```swift
class ViewController: UIViewController{
    /**Instance of the JMC Flexible collection view data source */
    var datasource: JMCFlexibleCollectionViewDataSource?
        override func viewDidLoad() {
        super.viewDidLoad()
        /**Create an instance of the flexible datasource
            make sure to pass here the collection view and cell identifier
         */
        datasource  = JMCFlexibleCollectionViewDataSource(collectionView: collectionView, cellIdentifier:"cell")

```
###Step 3 Create datasource data structures
The items that will provide the content to collection cells view have to be subclassed from DataSourceItem class. In your implementation you need to overwrite the getSize method, and return the size of the element. For example: 

```swift
class MyDataSourceItem:DataSourceItem{
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
```





## Release History

* 0.1 July 2016
    * Candidate for release

## Meta

Your Name – [@appzzman](https://twitter.com/appzzman) – janusz@izotx.com

Distributed under the BSD license. See ``LICENSE`` for more information.

[https://github.com/yourname/github-link](https://github.com/dbader/)

<!--[npm-image]: https://img.shields.io/npm/v/datadog-metrics.svg?style=flat-square-->
<!--[npm-url]: https://npmjs.org/package/datadog-metrics-->
<!--[npm-downloads]: https://img.shields.io/npm/dm/datadog-metrics.svg?style=flat-square-->
<!--[travis-image]: https://img.shields.io/travis/dbader/node-datadog-metrics/master.svg?style=flat-square-->
<!--[travis-url]: https://travis-ci.org/dbader/node-datadog-metrics-->
