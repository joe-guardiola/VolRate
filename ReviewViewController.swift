//
//  ReviewViewController.swift

import UIKit

class ReviewViewController: UIViewController {

    @IBOutlet var backgroundImageView:UIImageView!
    @IBOutlet var ratingStackView:UIStackView!
    var rating:String?
    
    @IBOutlet var dislikeButton: UIButton!
    @IBOutlet var goodButton: UIButton!
    @IBOutlet var greatButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Blur the background image of the view
        let blurEffect = UIBlurEffect(style: .Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
        
        // Set the initial state to animate the rating stack view from
//        ratingStackView.transform = CGAffineTransformMakeScale(0.0, 0.0)
//        ratingStackView.transform = CGAffineTransformMakeTranslation(0, 500)
//        let scale = CGAffineTransformMakeScale(0.0, 0.0)
//        let translate = CGAffineTransformMakeTranslation(0, 500)
//        ratingStackView.transform = CGAffineTransformConcat(scale, translate)
        dislikeButton.transform = CGAffineTransformMakeTranslation(0, 500)
        goodButton.transform = CGAffineTransformMakeTranslation(0, 500)
        greatButton.transform = CGAffineTransformMakeTranslation(0, 500)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // Set the end state of the animation.
        // CGAffineTransformIdentity returns the view to
        // it's original dimensions.
//        UIView.animateWithDuration(0.7, delay: 0.0, options: [], animations: {
//                self.ratingStackView.transform = CGAffineTransformIdentity
//            }, completion: nil)
        
        // Spring animation version
//        UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
//                self.ratingStackView.transform = CGAffineTransformIdentity
//            }, completion: nil)
                UIView.animateWithDuration(0.3, delay: 0.0, options: [], animations: {
                        self.dislikeButton.transform = CGAffineTransformIdentity
                    }, completion: nil)
        
                UIView.animateWithDuration(0.7, delay: 0.0, options: [], animations: {
                        self.goodButton.transform = CGAffineTransformIdentity
                    }, completion: nil)
        
                UIView.animateWithDuration(0.9, delay: 0.0, options: [], animations: {
                        self.greatButton.transform = CGAffineTransformIdentity
                    }, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func ratingSelected(sender:UIButton) {
        switch(sender.tag) {
        case 100:
            rating = "dislike"
        case 200:
            rating = "good"
        case 300:
            rating = "great"
        default:
            break
        }
        
        performSegueWithIdentifier("unwindToDetailView", sender: sender)
    }

}
