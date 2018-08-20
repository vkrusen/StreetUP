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

class InventoryViewController: BaseViewController {
  
    @IBOutlet var sellButton: UIButton!
    
    private enum CellIdentifiers {
    static let InventoryItemCell = "InventoryItemCell"
  }
  
  private enum StoryboardNames {
    static let Main = "Main"
  }
  
  private enum ViewControllerIdentifiers {
    static let Detail = "DetailViewController"
  }
  
    @IBOutlet var collectionView: UICollectionView!
  
  private var items: [Item] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Feed"
    
    items = DataProvider.shared.allItems
    
    setupGradient(item: sellButton, colors: [hexStringToUIColorWithAlpha(hex: "87D300", alpha: 1.0), hexStringToUIColorWithAlpha(hex: "35BA00", alpha: 1.0)], alpha: [1.0], locations: [0.0, 1.0], roundedCorners: true, cornerRadius: 7)
    setupShadow(UIItem: sellButton, offsetX: -3, offsetY: 3, spread: 0, alpha: 1.0, HEXColor: "3FBD06")
    sellButton.layer.cornerRadius = 7
  }
    
    @IBAction func sellAction(_ sender: Any) {
    }
}

// MARK: - UICollectionViewDataSource
extension InventoryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.InventoryItemCell, for: indexPath) as! InventoryItemCell
            cell.configure(with: items[indexPath.row])
        
            cell.layer.borderColor = hexStringToUIColor(hex: "E2E2E2").cgColor
            cell.layer.borderWidth = 1
            cell.layer.cornerRadius = 10
        
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate
extension InventoryViewController: UICollectionViewDelegate {
  
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: StoryboardNames.Main, bundle: nil)
        guard let detailViewController = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.Detail) as? DetailViewController else {
            return
        }
        detailViewController.item = items[indexPath.row]
        navigationController?.pushViewController(detailViewController, animated: true)
    }
  
}
