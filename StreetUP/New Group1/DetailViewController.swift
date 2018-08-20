/// Copyright (c) 2017 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import AlamofireImage

class DetailViewController: BaseViewController {
  
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var conditionLabel: UILabel!
    @IBOutlet var sizeLabel: UILabel!
    @IBOutlet var BINButton: UIButton!
    @IBOutlet var BidButton: UIButton!
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var sendOfferButton: UIButton!
    
    @IBOutlet var priceView: UIView!
    @IBOutlet var conditionView: UIView!
    @IBOutlet var sizeView: UIView!
    
    var item: Item!
    var buttonStatus = 0
    
    private enum StoryboardNames {
        static let Main = "Main"
    }
    
    private enum ViewControllerIdentifiers {
        static let Checkout = "CheckoutViewController"
    }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupView(view: priceView, color: "A1F152", shadowColor: "417505")
    setupView(view: conditionView, color: "52D1F1", shadowColor: "054D75")
    setupView(view: sizeView, color: "529EF1", shadowColor: "054D75")
    
    setupGradient(item: BINButton, colors: [hexStringToUIColorWithAlpha(hex: "87D300", alpha: 1.0), hexStringToUIColorWithAlpha(hex: "35BA00", alpha: 1.0)], alpha: [1.0], locations: [0.0, 1.0], roundedCorners: true, cornerRadius: 7)
    setupShadow(UIItem: BINButton, offsetX: -3, offsetY: 3, spread: 0, alpha: 1.0, HEXColor: "3FBD06")
    BINButton.layer.cornerRadius = 7
    setupGradient(item: BidButton, colors: [hexStringToUIColorWithAlpha(hex: "87D300", alpha: 1.0), hexStringToUIColorWithAlpha(hex: "35BA00", alpha: 1.0)], alpha: [1.0], locations: [0.0, 1.0], roundedCorners: true, cornerRadius: 7)
    setupShadow(UIItem: BidButton, offsetX: -3, offsetY: 3, spread: 0, alpha: 1.0, HEXColor: "3FBD06")
    BidButton.layer.cornerRadius = 7
    
    title = item.name
    
    print(item)
    
    setupImageView(imageView: imageView)
    
    conditionLabel.text = "DSWT"
    sizeLabel.text = "M"
    priceLabel.text = NumberFormat.format(value: item.price)
    imageView.af_setImage(withURL: item.photoUrl) { [weak self] _ in
      guard let strongSelf = self else {
        return
      }
    }
  }
    
    // Functions
    func setupImageView(imageView: UIImageView) {
        let view = UIView(frame: imageView.frame)
        let gradient = CAGradientLayer()
            gradient.frame = view.frame
            gradient.colors = [hexStringToUIColorWithAlpha(hex: "FFFFFF", alpha: 0.0).cgColor, hexStringToUIColorWithAlpha(hex: "FFFFFF", alpha: 1.0).cgColor]
            gradient.locations = [0.2, 0.5]
            view.layer.insertSublayer(gradient, at: 0)
        
        imageView.addSubview(view)
        imageView.bringSubview(toFront: view)
    }
    
    // Factories
    func setupView(view: UIView, color: String, shadowColor: String) {
        setupGradient(item: view, colors: [hexStringToUIColorWithAlpha(hex: color, alpha: 1.0), hexStringToUIColorWithAlpha(hex: color, alpha: 1.0)], alpha: [1.0], locations: [0.0    ,1.0], roundedCorners: true, cornerRadius: 7)
        setupShadow(UIItem: view, offsetX: -3, offsetY: 3, spread: 0, alpha: 1.0, HEXColor: shadowColor)
        view.layer.cornerRadius = 7
    }
  
    @IBAction func purchaseAction(_ sender: Any) {
        CheckoutCart.shared.addItem(item)
        /*let storyboard = UIStoryboard(name: StoryboardNames.Main, bundle: nil)
        guard let CheckoutViewController = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.Checkout) as? CheckoutViewController else {
            return
        }
        navigationController?.pushViewController(CheckoutViewController, animated: true)*/
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
