SwiftCollection
===============

Collection of various Swift sources: Controllers, Classes, Extensions, and more, that I have put together my self and from samples found while googling around.

Requires: **Swift 3**

### Extensions

* **eArray.swift**
  * removeObject() -> Remove object from array.
  * replaceNull() -> Replaces alll null(nil) objects.
  * categorise() -> Make dict from array based on key.

* **eAVAsset.swift**
  * firstVideoFrameFromURL() -> Class method that returns instance of UIImage containing first frame of video asset loaded from the url specified by "url" parameter.
  * firstVideoFrame() -> Returns instance of UIImage containing first frame of current video asset.
  * videoFrameAt() -> Returns instance of UIImage containing frame at time specified by "seconds" parameter.
  * videoFrameAt() -> Returns instance of UIImage containing frame at time specified by "time" parameter.

* **eBundle.swift**
  * pathForResource() -> Returns path for app's resources.

* **eDate.swift**
  * dateComponents -> Access date's components.
  * format() -> Returns formatted string.

* **eDictionary.swift**
  * jsonString() -> Returns jsonString made from current NSDictionary.
  * init() -> Inits NSDictionary object from json string.
  * replaceNull() -> Replaces all null(nil) elements.

* **eString.swift**
  * containsOnly() -> Returns whether current string contains only characters in a set. passed as parameter.
  * isValidEmail() -> Validates email address.

* **eUIColor.swift**
  * init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> Helper to init UIColor based on RGBA value.

* **eUIImage.swift**
  * init?(color: UIColor, size: CGSize) -> Init blank image with background color and size.
  * crop() -> Crop image to specific size.
  * cropToSquare() -> Crop image to squared size by searching the shortest first.
  * resize() -> Resize image based on size and ContentMode.
  * fixImageOrientation() -> Fix image orientation by rotating and setting its rotation tags as them should be.

* **eUINavigationController.swift**
  * popViewControllerAnimatedWithHandler() -> Pop view controller animated + call completion handler after animation is done animating.

* **eUIView.swift**
  * viewWithTagRecursive() -> Search for a view with tag recursively.


### Controllers
* **BasicSearchController** - A template for a UITableView search controller.


### Classes
* **CacheObject** - Load, save, use data, currently only supports UserDefaults.standard.
* **CUIButton** - Custom button that allows setting background colors for multiple button modes in interface builder.
* **PaddedUITextField** - Add padding to UITextField.
