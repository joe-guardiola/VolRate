//
//  ReviewViewController.swift

import UIKit
import Firebase

class ReviewViewController: UIViewController {

    @IBOutlet var backgroundImageView:UIImageView!
    @IBOutlet var ratingStackView:UIStackView!
    var rating:String?
    var organization: Organization!
    
    @IBOutlet var hatedIt: UIButton!
    @IBOutlet var itWasAlrightIGuess: UIButton!
    @IBOutlet var perfect: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let blurEffect = UIBlurEffect(style: .Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
        
        hatedIt.transform = CGAffineTransformMakeTranslation(0, 500)
        itWasAlrightIGuess.transform = CGAffineTransformMakeTranslation(0, 500)
        perfect.transform = CGAffineTransformMakeTranslation(0, 500)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
                UIView.animateWithDuration(0.3, delay: 0.0, options: [], animations: {
                        self.hatedIt.transform = CGAffineTransformIdentity
                    }, completion: nil)
        
                UIView.animateWithDuration(0.7, delay: 0.0, options: [], animations: {
                        self.itWasAlrightIGuess.transform = CGAffineTransformIdentity
                    }, completion: nil)
        
                UIView.animateWithDuration(0.9, delay: 0.0, options: [], animations: {
                        self.perfect.transform = CGAffineTransformIdentity
                    }, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func ratingSelected(sender:UIButton) {
        switch(sender.tag) {
        case 100:
            rating = "hatedIt"
        case 200:
            rating = "itWasAlrightIGuess"
        case 300:
            rating = "perfect"
        default:
            break
        }
        
        performSegueWithIdentifier("unwindToDetailView", sender: sender)
    }

}
