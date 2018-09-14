//
//  MovieDetailViewController.swift
//  Flicks
//
//  Created by NikitaPrakash Patil on 6/7/18.
//  Copyright © 2018 NikitaPrakash Patil. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController{

    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var MovieTitle: UILabel!
    @IBOutlet weak var MovieOverview: UITextView!
    @IBOutlet weak var scrollview: UIScrollView!
    
    
    var movie: NSDictionary!
    
    @objc func slideUpInfoView(_ sender: UIPanGestureRecognizer) {
        
        UIView.animate(withDuration: 0.3) {
            self.infoView.frame.origin.y = self.detailImage.frame.size.height - self.infoView.frame.size.height
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
     self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.hidesBackButton = false
    //   scrollview.contentSize = CGSize(width: scrollview.frame.size.width , height: 314)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(slideUpInfoView(_:)))
        
        infoView.addGestureRecognizer(gesture)
        let title = movie?["title"] as! String
        self.MovieTitle.text = title
        
        let Overview = movie?["overview"] as! String
        self.MovieOverview.text = Overview
        
        if let posterPath = movie?["poster_path"] as? String{
            
            let baseurl = "https://image.tmdb.org/t/p/original"
            let imageurl = NSURL(string: baseurl+posterPath)
            detailImage.setImageWith(imageurl as! URL)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
