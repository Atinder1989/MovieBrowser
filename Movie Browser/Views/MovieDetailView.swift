//
//  MovieDetailView.swift
//  Movie Browser
//
//  Created by Atinderpal Singh on 03/12/17.
//  Copyright © 2017 XYZ. All rights reserved.
//

import UIKit

class MovieDetailView: UIViewController {

    @IBOutlet weak var posterImgaeview          : UIImageView!
    @IBOutlet weak var titleLabel               : UILabel!
    @IBOutlet weak var ratingLabel              : UILabel!
    @IBOutlet weak var releaseDateLabel         : UILabel!
    @IBOutlet weak var synopsisTextView         : UITextView!
    
    var movie : Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let url = WebserviceManager.sharedInstance.getPosterUrl(path: movie.poster_path ?? "")
        posterImgaeview.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "MoviePlaceholder")) { (image, error, type, url) in
            
        }
        
        titleLabel.text = movie.original_title
        ratingLabel.text = "\(movie.vote_average)"
        releaseDateLabel.text = movie.release_date
        synopsisTextView.text = movie.overview
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
