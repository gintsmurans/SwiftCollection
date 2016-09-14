SwiftCollection
===============

Collection of various Swift sources: Controllers, Classes, Extensions, and more, that I have put together my self and from samples found while googling around.

Requires: **Swift 3**

### Extensions

* **EALAssetsLibrary.swift** - for managing assets library, for example to save an image to specific photo album (deprecated as of iOS 9.0)

* **EArray.swift**
  * removeObject() -> Remove object from array.

* **EAVAsset.swift**
  * firstVideoFrameFromURL() -> Class method that returns instance of UIImage containing first frame of video asset loaded from the url specified by "url" parameter.
  * firstVideoFrame() -> Returns instance of UIImage containing first frame of current video asset.
  * videoFrameAt() -> Returns instance of UIImage containing frame at time specified by "seconds" parameter.
  * videoFrameAt() -> Returns instance of UIImage containing frame at time specified by "time" parameter.

* **ENSBundle.swift**
  * pathForResource() -> Returns path for app's resources.

* **ENSDictionary.swift**
  * jsonString() -> Returns jsonString made from current NSDictionary.
  * init(jsonString: String) -> Inits NSDictionary object from json string.

* **EString.swift**
  * length -> Shortcut to "".characters.count.
  * containsOnly() -> Returns whether current string contains only characters in a set. passed as parameter
  * substr() -> Substring helper.
  * isValidEmail() -> Validates email address.

* **EUIColor.swift**
  * init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> Helper to init UIColor based on RGBA value.

* **EUIImage.swift**
  * init?(color: UIColor, size: CGSize) -> Init blank image with background color and size.
  * crop() -> Crop image to specific size.
  * cropToSquare() -> Crop image to squared size by searching the shortest first.
  * resize() -> Resize image based on size and ContentMode.
  * fixImageOrientation() -> Fix image orientation by rotating and setting its rotation tags as them should be.

* **EUINavigationController.swift**
  * popViewControllerAnimatedWithHandler() -> Pop view controller animated + call completion handler after animation is done animating.

* **EUIView.swift**
  * viewWithTagRecursive() -> Search for a view with tag recursively.


### Controllers
* **BasicSearchController** - A template for a UITableView search controller.


### Classes
* **CUIButton** - Custom button that allows setting background colors for multiple button modes in interface builder.
