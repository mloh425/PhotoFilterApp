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
  let picker: UIImagePickerController = UIImagePickerController()
  var originalImage : UIImage? = nil
  var doneButton = UIBarButtonItem()
  
  var filters : [(UIImage) -> (UIImage?)] = [FilterService.sepiaImageFromOriginalImage]
  
  //Mark: Action Sheets
  let alert = UIAlertController(title: "Button Clicked", message: "Yes the button was clicked", preferredStyle: UIAlertControllerStyle.ActionSheet)
  
  let imageSelector = UIAlertController(title: "Image Source", message: "Select image from: ", preferredStyle: UIAlertControllerStyle.ActionSheet)
  
  let filterSelector = UIAlertController(title: "Filters", message: "Apply a filter: ", preferredStyle: UIAlertControllerStyle.ActionSheet)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.picker.delegate = self
    collectionView.dataSource = self //?
    collectionView.delegate = self
    doneButton.title = ""
    // Do any additional setup after loading the view, typically from a nib.
    
    //Create instances of the actions
    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (alert) -> (Void) in
      println("Alert Cancelled")
    }
    
    //Mark: Choosing Image Source Menu
    let chooseImageSource = UIAlertAction(title: "Choose Image From...", style: UIAlertActionStyle.Default) { (alert) -> (Void) in
      self.presentViewController(self.imageSelector, animated: true, completion: nil)
    }
    
    let chooseImageFromPhotoLibrary = UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.Default) { (alert) -> (Void) in
      self.picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
      self.presentViewController(self.picker, animated: true, completion: nil)
      println("Alert Confirmed")
    }
    
 //   if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
      let chooseImageFromCamera = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default) { (alert) -> (Void) in
        //Should check if camera exists on device.
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
          self.picker.sourceType = UIImagePickerControllerSourceType.Camera //Choose the source type
          self.presentViewController(self.picker, animated: true, completion: nil) //Present the camera
        }
      }
//    }

    let uploadAction = UIAlertAction(title: "Upload", style: UIAlertActionStyle.Default) { (alert) -> Void in
      let post = PFObject(className: "Post")
      //create a text field for entering text? save the text somehow from the object in SB?
      
      if let image = self.chosenImageView.image {
        let resizeDimensions = CGSize(width: 600, height: 600)
        let resizedImage = ImageResizer.resizeImage(image, size: resizeDimensions)
        let data = UIImageJPEGRepresentation(resizedImage, 1.0)
        let file = PFFile(name: "photo.jpeg", data: data)
        post["image"] = file
      }
      post.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
        if let error = error {
          println(error.localizedDescription)
        } else {
          println("Success!")
        }
      })
    }
    
    let revert = UIAlertAction(title: "Revert Changes", style: UIAlertActionStyle.Destructive) {
      (alert) -> (Void) in
      self.chosenImageView.image = self.originalImage
    }
    
    //Mark: Filters via UIAlert Actions
    let filterAction = UIAlertAction(title: "Filters", style: UIAlertActionStyle.Default) { (alert) -> (Void) in
      self.presentViewController(self.filterSelector, animated: true, completion: nil)
    }
    
    let sepiaAction = UIAlertAction(title: "Sepia", style: UIAlertActionStyle.Default) {
      (alert) -> (Void) in
//      let image = CIImage(image: self.chosenImageView.image!)
//      let sepiaFilter = CIFilter(name: "CISepiaTone")
//      sepiaFilter.setValue(image, forKey: kCIInputImageKey)
//      let processedImage = FilterService.filterProcess(sepiaFilter)
//      self.chosenImageView.image = processedImage
      self.chosenImageView.image = FilterService.sepiaImageFromOriginalImage(self.chosenImageView.image!)
    }
    
    let noirAction = UIAlertAction(title: "Noir", style: UIAlertActionStyle.Default) { (alert) -> Void in
      let image = CIImage(image: self.chosenImageView.image!)
      let noirFilter = CIFilter(name: "CIPhotoEffectNoir")
      noirFilter.setValue(image, forKey: kCIInputImageKey)
      let processedImage = FilterService.filterProcess(noirFilter)
      self.chosenImageView.image = processedImage
    }
    
    let chromeAction = UIAlertAction(title: "Chrome Effect", style: UIAlertActionStyle.Default) { (alert) -> Void in
      let image = CIImage(image: self.chosenImageView.image!)
      let chromeFilter = CIFilter(name: "CIPhotoEffectChrome")
      chromeFilter.setValue(image, forKey: kCIInputImageKey)
      let processedImage = FilterService.filterProcess(chromeFilter)
      self.chosenImageView.image = processedImage
    }
    
    let bloomAction = UIAlertAction(title: "Bloom Effect", style: UIAlertActionStyle.Default) { (alert) -> Void in
      let image = CIImage(image: self.chosenImageView.image!)
      let bloomFilter = CIFilter(name: "CIBloom", withInputParameters: ["inputRadius" : 10.0, "inputIntensity" : 1.00])
      bloomFilter.setValue(image, forKey: kCIInputImageKey)
      let processedImage = FilterService.filterProcess(bloomFilter)
      self.chosenImageView.image = processedImage
    }
    
    //Entering filter mode
    if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
      
      let filterAction = UIAlertAction(title: "Filter", style: UIAlertActionStyle.Default) { (alert) -> Void in
        self.enterFilterMode()
      }
      
      alert.addAction(filterAction)
    }
    
    //Mark: Adding actions to alert pop up.
    alert.addAction(cancelAction)
    alert.addAction(uploadAction)
    alert.addAction(chooseImageSource)
    alert.addAction(filterAction)
    filterSelector.addAction(cancelAction)
    filterSelector.addAction(sepiaAction)
    filterSelector.addAction(noirAction)
    filterSelector.addAction(chromeAction)
    filterSelector.addAction(bloomAction)
    filterSelector.addAction(revert)
    imageSelector.addAction(cancelAction)
    imageSelector.addAction(chooseImageFromPhotoLibrary)
    imageSelector.addAction(chooseImageFromCamera)
  }
  
  func enterFilterMode() {
    imageLeadingEdge.constant = 40
    imageTrailingEdge.constant = -40
    imageTopEdge.constant = 40
    imageBottomEdge.constant = 70
    collectionBottomEdge.constant = 8
    
    UIView.animateWithDuration(0.3, animations: { () -> Void in
      self.view.layoutIfNeeded()
    })
    
    self.doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "closeFilterMode")
    navigationItem.rightBarButtonItem = doneButton
  }
  
  func closeFilterMode() {
    imageLeadingEdge.constant = 0
    imageTrailingEdge.constant = 0
    imageTopEdge.constant = 8
    imageBottomEdge.constant = 8
    collectionBottomEdge.constant = -150
    doneButton.title = ""

    UIView.animateWithDuration(0.3, animations: { () -> Void in
      self.view.layoutIfNeeded()
    })
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
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
    //imageview set
    self.chosenImageView.image = image
    self.originalImage = image
    self.picker.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    self.picker.dismissViewControllerAnimated(true, completion: nil)
    println("Picker Cancelled")
  }
  
}

extension ViewController : UICollectionViewDataSource, UICollectionViewDelegate {
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
 //   return 20 //change it
    return filters.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ThumbnailCell", forIndexPath: indexPath) as! UICollectionViewCell
    let filter = filters[indexPath.row] //Retrieve the function for the appropriate filter
    if let image = chosenImageView.image {
      let filteredImage = filter(chosenImageView.image!)
    }
    
    cell.backgroundColor = UIColor.redColor()
    return cell
  }
}