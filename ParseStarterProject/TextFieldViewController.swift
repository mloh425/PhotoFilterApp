//
//  TextFieldViewController.swift
//  ParseStarterProject
//
//  Created by Sau Chung Loh on 8/14/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//
import UIKit
import Parse

class TextFieldViewController: UITableViewController, UITextFieldDelegate {
  var comment : String?
  var imageReference : UIImage? //Get the image from a passed in reference
  
  @IBOutlet weak var filteredImageDisplay: UIImageView!
  @IBOutlet weak var commentField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commentField.delegate = self
        self.filteredImageDisplay.image = imageReference
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  func upload() {
    let post = PFObject(className: "Post")
    if let image = imageReference {
      let resizeDimensions = CGSize(width: 600, height: 600)
      let resizedImage = ImageResizer.resizeImage(image, size: resizeDimensions)
      let data = UIImageJPEGRepresentation(resizedImage, 1.0)
      let file = PFFile(name: "photo.jpeg", data: data)
      post["image"] = file
      if let comment = comment {
        post["comment"] = comment
      } else {
        post["comment"] = ""
      }
    }
    post.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
      if let error = error {
        println(error.localizedDescription)
      } else {
        println("Success!")
      }
    })
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return false
  }
  
  func textFieldDidEndEditing(textField: UITextField) {
    comment = textField.text
  }

  @IBAction func submitButtonPressed(sender: UIButton) {
    self.dismissViewControllerAnimated(true, completion: { () -> Void in
      self.upload()
    })
  }
}




