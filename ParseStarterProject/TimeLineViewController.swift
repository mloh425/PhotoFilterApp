//
//  TimeLineViewController.swift
//
//
//  Created by Sau Chung Loh on 8/13/15.
//
//

import UIKit
import Parse

class TimeLineViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  var postArray = []
  var postImageQueue = NSOperationQueue()
  var pullToRefresh : UIRefreshControl!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    setUpPullToRefresh()
    downloadPosts()
    title = "Timeline"
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  private func downloadPosts() {
    let query = PFQuery(className: "Post")
    query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
      if let error = error {
        println(error.localizedDescription)
      } else if let posts = results as? [PFObject] {
        self.postArray = posts.reverse()
        self.tableView.reloadData()
      }
    }
  }
  
  private func setUpPullToRefresh() {
    self.pullToRefresh = UIRefreshControl()
    self.pullToRefresh.attributedTitle = NSAttributedString(string: "Pull to refresh")
    self.pullToRefresh.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
    self.tableView.addSubview(pullToRefresh)
  }
  
  func refresh(sender : AnyObject) {
    downloadPosts()
    self.tableView.reloadData()
    self.pullToRefresh.endRefreshing()
  }
}

extension TimeLineViewController : UITableViewDataSource, UITableViewDelegate {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return postArray.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("TimeLineCell", forIndexPath: indexPath) as! TimeLineCell
    var postImage: AnyObject = self.postArray[indexPath.row]
    cell.tag++
    let tag = cell.tag
    if let post = postArray[indexPath.row] as? PFObject,
      imageFile = postImage["image"] as? PFFile {
        imageFile.getDataInBackgroundWithBlock({ (data, error) -> Void in
          if let error = error {
            println(error.localizedDescription)
          } else if let data = data,
            image = UIImage(data: data),
            date = post.createdAt {
              NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
                dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
                let dateString = dateFormatter.stringFromDate(date)
                if cell.tag == tag {
                  cell.timeLineCellImage.image = image
                  cell.timeLineDateLabel.text = dateString
                  if let commentFile = postImage["comment"] as? String {
                    cell.timeLineCommentLabel.text = commentFile
                  }
                }
              })
          }
        })
    }
    return cell
  }
}