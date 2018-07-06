//
//  ViewController.swift
//  CupOfMemes
//
//  Created by Victor Krusenstråhle on 2017-04-02.
//  Copyright © 2017 Victor Krusenstråhle. All rights reserved.
//

import UIKit
import Koloda
import pop

struct Post {
    
    let Name: String // Username
    let Image: UIImage! // Image
    let Price: NSNumber // Price
    let Currency: String // Currency
    let Title: String // Title
    let PostID: String
    let Media_url: String
    
    var description: String {
        return "Name: \(Name), \n Image: \(Image), Price: \(Price), Currency: \(Currency), Title: \(Title), PostID: \(PostID), Media_url: \(Media_url)"
    }
    
    init(name: String?, image: UIImage?, price:NSNumber?, currency: String?, title: String?, postID:String?, media_url:String?) {
        self.Name = name ?? ""
        self.Image = image
        self.Price = price ?? 0
        self.Currency = currency ?? ""
        self.Title = title ?? ""
        self.PostID = postID ?? ""
        self.Media_url = media_url ?? ""
    }
    
}

private let frameAnimationSpringBounciness: CGFloat = 9
private let frameAnimationSpringSpeed: CGFloat = 16
private let kolodaCountOfVisibleCards = 2
private let kolodaAlphaValueSemiTransparent: CGFloat = 0.1

class ViewController: UIViewController {
    
    // Setup array
    var posts:[Post] = []
    
    @IBOutlet var kolodaView: CustomKolodaView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kolodaView.alphaValueSemiTransparent = kolodaAlphaValueSemiTransparent
        kolodaView.countOfVisibleCards = kolodaCountOfVisibleCards
        kolodaView.delegate = self
        kolodaView.dataSource = self
        kolodaView.animator = BackgroundKolodaAnimator(koloda: kolodaView)
        
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        append()
    }
    
    func append() {
        self.posts.append(Post(name: "username", image: #imageLiteral(resourceName: "image"), price: 5499, currency: "kr", title: "Supreme Bogo Pink", postID: "id", media_url: "media_url"))
        self.posts.append(Post(name: "username", image: #imageLiteral(resourceName: "image2"), price: 899, currency: "kr", title: "Bape Tee", postID: "id", media_url: "media_url"))
        self.posts.append(Post(name: "username", image: #imageLiteral(resourceName: "image3"), price: 4500, currency: "kr", title: "Supreme x Stone Island", postID: "id", media_url: "media_url"))
        self.posts.append(Post(name: "username", image: #imageLiteral(resourceName: "image4"), price: 5800, currency: "kr", title: "NMD Human Race OG", postID: "id", media_url: "media_url"))
        kolodaView.resetCurrentCardIndex()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//MARK: KolodaViewDelegate
extension ViewController: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        kolodaView.resetCurrentCardIndex()
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        print("User clicked on card number \(index)!")
    }
    
    func kolodaShouldApplyAppearAnimation(_ koloda: KolodaView) -> Bool {
        return true
    }
    
    func kolodaShouldMoveBackgroundCard(_ koloda: KolodaView) -> Bool {
        return true
    }
    
    func kolodaShouldTransparentizeNextCard(_ koloda: KolodaView) -> Bool {
        return false
    }
    
    func koloda(kolodaBackgroundCardAnimation koloda: KolodaView) -> POPPropertyAnimation? {
        let animation = POPSpringAnimation(propertyNamed: kPOPViewFrame)
            animation?.springBounciness = frameAnimationSpringBounciness
            animation?.springSpeed = frameAnimationSpringSpeed
        return animation
    }
}

// MARK: KolodaViewDataSource
extension ViewController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return posts.count
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        
        let post = posts[index]
            
            let customCard = Bundle.main.loadNibNamed("CardView", owner: self, options: nil)?.first as! CardView
                customCard.imageView = UIImageView(image: post.Image)
                customCard.titleLabel.text = post.Title
                customCard.priceLabel.text = "\(post.Price)\(post.Currency)"
        
                customCard.view.layer.shadowColor = UIColor.black.cgColor
                customCard.view.layer.shadowOpacity = 0.5
                customCard.view.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
                customCard.view.layer.shadowRadius = 2.0
        
            return customCard
        }
}
