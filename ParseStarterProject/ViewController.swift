//
//  ViewController.swift
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {
  
  @IBOutlet weak var alertButton: UIButton!
  @IBOutlet weak var chosenImageView: UIImageView!
  
  //chosenImageView Constraints
  @IBOutlet weak var imageLeadingEdge: NSLayoutConstraint!
  @IBOutlet weak var imageTrailingEdge: NSLayoutConstraint!
  @IBOutlet weak var imageTopEdge: NSLayoutConstraint!
  @IBOutlet weak var imageBottomEdge: NSLayoutConstraint!
  @IBOutlet weak var collectionBottomEdge: NSLayoutConstraint!
  @IBOutlet weak var collectionView: UICollectionView!
  
  let kImageLeadingEdgeConstantAdjustment : CGFloat = 40
  let kImageTrailingEdgeConstantAdjustment : CGFloat = -40
  let kImageTopEdgeConstantAdjustment : CGFloat = 40
  let kImageBottomEdgeConstantAdjustment : CGFloat = 70
  let kCollectionBottomEdgeConstantAdjustment : CGFloat = 8
  
  let kImageLeadingEdgeOriginalConstant: CGFloat = 0
  let kImageTrailingEdgeOriginalConstant : CGFloat = 0
  let kImageTopEdgeOriginalConstant : CGFloat = 8
  let kImageBottomEdgeOriginalConstant : CGFloat = 8
  let kCollectionBottomEdgeOriginalConstant : CGFloat = -150
  
  let kThumbnailSize = CGSize(width: 100, height: 100)
  let picker: UIImagePickerController = UIImagePickerController()
  var originalImage : UIImage? = nil
  var doneButton = UIBarButtonItem()
  var thumbnail : UIImage!
  let imageQueue = NSOperationQueue()
  var filters : [(UIImage) -> (UIImage?)] = [FilterService.sepiaImageFromOriginalImage, FilterService.noirImageFromOriginalImage, FilterService.chromeImageFromOriginalImage, FilterService.bloomImageFromOriginalImage, FilterService.instantFadeImageFromOriginalImage]
  
  var displayImage : UIImage! {
    didSet {
      chosenImageView.image = displayImage
      originalImage = chosenImageView.image
      thumbnail = ImageResizer.resizeImage(chosenImageView.image!, size: kThumbnailSize)
      thumbnail = displayImage
      collectionView.reloadData()
    }
  }
  
  //Mark: Action Sheets
  let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
  let imageSelector = UIAlertController(title: "Image Source", message: "Select image from: ", preferredStyle: UIAlertControllerStyle.ActionSheet)
  let filterSelector = UIAlertController(title: "Filters", message: "Apply a filter: ", preferredStyle: UIAlertControllerStyle.ActionSheet)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    picker.delegate = self
    collectionView.dataSource = self //?
    collectionView.delegate = self
    doneButton.title = " "
    title = "Home"
    // Do any additional setup after loading the view, typically from a nib.
    chosenImageView.image = UIImage(named: "placeholder.jpeg")
    
    //Create instances of the actions
    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (alert) -> (Void) in
    }
    
    //Mark: Choosing Image Source Menu
    let chooseImageSource = UIAlertAction(title: "Choose Image From...", style: UIAlertActionStyle.Default) { (alert) -> (Void) in
      self.presentViewController(self.imageSelector, animated: true, completion: nil)
    }
    
    let chooseImageFromPhotoLibrary = UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.Default) { (alert) -> (Void) in
      self.picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
      self.presentViewController(self.picker, animated: true, completion: nil)
    }
    
    let galleryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.Default) { (alert) -> Void in
      self.performSegueWithIdentifier("ShowGallery", sender: self)
    }
    
    //If the device has access to a camera, then it can take a picture for its image.
    let chooseImageFromCamera = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default) { (alert) -> (Void) in
      if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
        self.picker.sourceType = UIImagePickerControllerSourceType.Camera //Choose the source type
        self.presentViewController(self.picker, animated: true, completion: nil) //Present the camera
      }
    }
    
    let uploadAction = UIAlertAction(title: "Upload", style: UIAlertActionStyle.Default) { (alert) -> Void in
      self.performSegueWithIdentifier("ShowCommentField", sender: self)
    }
    
    let revert = UIAlertAction(title: "Revert Changes", style: UIAlertActionStyle.Destructive) {
      (alert) -> (Void) in
      self.chosenImageView.image = self.originalImage
    }
    

    
    //Entering filter mode
    if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
      let filterAction = UIAlertAction(title: "Filter", style: UIAlertActionStyle.Default) { (alert) -> Void in
        self.enterFilterMode()
      }
      alert.addAction(filterAction)
    }
    
    displayImage = UIImage(named: "placeholder.jpeg")
    
    //Mark: Adding actions to alert pop up.
    alert.addAction(cancelAction)
    alert.addAction(uploadAction)
    alert.addAction(chooseImageSource)
    alert.addAction(revert)
    imageSelector.addAction(cancelAction)
    imageSelector.addAction(galleryAction)
    imageSelector.addAction(chooseImageFromPhotoLibrary)
    imageSelector.addAction(chooseImageFromCamera)
  }
  
  func enterFilterMode() {
    imageLeadingEdge.constant = kImageLeadingEdgeConstantAdjustment
    imageTrailingEdge.constant = kImageTrailingEdgeConstantAdjustment
    imageTopEdge.constant = kImageTopEdgeConstantAdjustment
    imageBottomEdge.constant = kImageBottomEdgeConstantAdjustment
    collectionBottomEdge.constant = kCollectionBottomEdgeConstantAdjustment
    UIView.animateWithDuration(0.3, animations: { () -> Void in
      self.view.layoutIfNeeded()
    })
    self.doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "closeFilterMode")
    navigationItem.rightBarButtonItem = doneButton
  }
  
  func closeFilterMode() {
    imageLeadingEdge.constant = kImageLeadingEdgeOriginalConstant
    imageTrailingEdge.constant = kImageTrailingEdgeOriginalConstant
    imageTopEdge.constant = kImageTopEdgeOriginalConstant
    imageBottomEdge.constant = kImageBottomEdgeOriginalConstant
    collectionBottomEdge.constant = kCollectionBottomEdgeOriginalConstant
    doneButton.title = " "
    
    UIView.animateWithDuration(0.3, animations: { () -> Void in
      self.view.layoutIfNeeded()
    })
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "ShowGallery" {
      if let galleryViewController = segue.destinationViewController as? GalleryViewController {
        galleryViewController.delegate = self
        galleryViewController.desiredFinalImageSize = chosenImageView.frame.size
      }
    }
    
    if segue.identifier == "ShowCommentField" {
      if let textFieldController = segue.destinationViewController as? TextFieldViewController {
        textFieldController.imageReference = self.chosenImageView.image
      }
    }
  }
  
  @IBAction func actionButtonPressed(sender: AnyObject) {
    //Presents an alert
    alert.modalPresentationStyle = UIModalPresentationStyle.PageSheet
    if let popover = alert.popoverPresentationController {
      popover.sourceView = view
      popover.sourceRect = alertButton.frame
    }
    self.presentViewController(alert, animated: true, completion: nil)
  }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
    let image: UIImage = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
    displayImage = image
    self.originalImage = image
    self.picker.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    self.picker.dismissViewControllerAnimated(true, completion: nil)
    println("Picker Cancelled")
  }
  
}

//Mark: UICollectionViewDataSource and UICollectionViewDelegate
extension ViewController : UICollectionViewDataSource, UICollectionViewDelegate {
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return filters.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ThumbnailCell", forIndexPath: indexPath) as! ThumbnailCell
    cell.filterPreview.image = nil
    let filter = filters[indexPath.row] //Retrieve the function for the appropriate filter
    cell.tag++
    let tag = cell.tag
    imageQueue.addOperationWithBlock { () -> Void in
      let filteredImage = filter(self.thumbnail)
      NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
        if cell.tag == tag {
          cell.filterPreview.image = filteredImage
        }
      })
    }
    return cell
  }
  
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    let filter = filters[indexPath.item]
    chosenImageView.image = filter(displayImage)
  }
}

//Mark: ImageSelectedDelegate Protocol
extension ViewController : ImageSelectedDelegate {
  func controllerDidSelectImage(newImage: UIImage) {
    displayImage = newImage
  }
}
