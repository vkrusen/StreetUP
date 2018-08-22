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
import Stripe

class CheckoutViewController: BaseViewController {

  let cellSpacingHeight: CGFloat = 20
    
  private enum Section: Int {
    case items = 0
    
    static func cellIdentifier(for section: Section) -> String {
      switch section {
      case .items:
        return "CheckoutItemTableViewCell"
      /*case .total:
        return "CheckoutTotalTableViewCell"*/
      }
    }
  }

  @IBOutlet var tableView: UITableView!
    @IBOutlet var totalLabel: UILabel!
    @IBOutlet var checkoutButton: UIButton!
    
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Utcheckning"
    totalLabel.text = "0 kr"
    
    setupGradient(item: checkoutButton, colors: [hexStringToUIColorWithAlpha(hex: "87D300", alpha: 1.0), hexStringToUIColorWithAlpha(hex: "35BA00", alpha: 1.0)], alpha: [1.0], locations: [0.0    ,1.0], roundedCorners: true, cornerRadius: 7)
    setupShadow(UIItem: checkoutButton, offsetX: -3, offsetY: 3, spread: 0, alpha: 1.0, HEXColor: "3FBD06")
    checkoutButton.layer.cornerRadius = 7
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    tableView.reloadData()
  }
  
    @IBAction func empty(_ sender: Any) {
    }
    
    @IBAction func continueDidTap(_ sender: Any) {
    // 1
    guard CheckoutCart.shared.canPay else {
      let alertController = UIAlertController(title: "Warning", message: "Your cart is empty", preferredStyle: .alert)
      let alertAction = UIAlertAction(title: "OK", style: .default)
      alertController.addAction(alertAction)
      present(alertController, animated: true)
      return
    }
    // 2
    /*let addCardViewController = STPAddCardViewController()
        addCardViewController.delegate = self
    navigationController?.pushViewController(addCardViewController, animated: true)*/
    
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let newViewController = storyBoard.instantiateViewController(withIdentifier: "ShippingViewControllerId") //as! ShippingViewController
    self.present(newViewController, animated: true, completion: nil)
  }
}

extension CheckoutViewController: STPAddCardViewControllerDelegate {
  
  func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
    navigationController?.popViewController(animated: true)
  }
  
  func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
    print(token)
    StripeClient.shared.completeCharge(with: token, amount: CheckoutCart.shared.total) { result in
      switch result {
      // 1
      case .success:
        completion(nil)
        
        let alertController = UIAlertController(title: "Congrats", message: "Your payment was successful!", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
          self.navigationController?.popViewController(animated: true)
        })
        alertController.addAction(alertAction)
        self.present(alertController, animated: true)
      // 2
      case .failure(let error):
        completion(error)
      }
    }
  }
}

// MARK: - UITableViewDataSource
extension CheckoutViewController: UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == Section.items.rawValue {
      return CheckoutCart.shared.cart.count
    } else {
      return 0
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let section = Section(rawValue: indexPath.section) else {
      fatalError("Section not found")
    }
    let identifier = Section.cellIdentifier(for: section)
    let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
    switch cell {
    case let cell as CheckoutItemTableViewCell:
      let item = CheckoutCart.shared.cart[indexPath.row]
      cell.configure(with: item)
      
      cell.layer.cornerRadius = 10
      cell.layer.masksToBounds = true
      
      let total = CheckoutCart.shared.total
      totalLabel.text = "\(NumberFormat.format(value: total))"
    /*case let cell as CheckoutTotalTableViewCell:
      let total = CheckoutCart.shared.total
      cell.configure(with: total)*/
    default:
      fatalError("Cell does not match the correct type")
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    if indexPath.section == Section.items.rawValue {
      return true
    } else {
      return false
    }
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    guard editingStyle == .delete else {
      return
    }
    let item = CheckoutCart.shared.cart[indexPath.row]
    let isRemoved = CheckoutCart.shared.removeItem(item)
    if isRemoved {
      tableView.beginUpdates()
      tableView.deleteRows(at: [indexPath], with: .automatic)
      tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
      totalLabel.text = "0 kr"
      tableView.endUpdates()
    }
  }
}
