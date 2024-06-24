//
//  TableViewCell.swift
//  ECommerceDemo
//
//  Created by kavita chauhan on 22/06/24.
//

import UIKit
import WebKit

class TableViewCell: UITableViewCell {
    
    // MARK: Outlets
    @IBOutlet weak var itemCollectionView: UICollectionView!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblBrandName: UILabel!
    @IBOutlet weak var lblSku: UILabel!
    @IBOutlet weak var btnExpandCollapse: UIButton!
    @IBOutlet weak var clrCollectionView: UICollectionView!
    @IBOutlet weak var viewCoupon: UIView!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var lblCoupon: UILabel!
    @IBOutlet weak var imgExpandCollapse: UIImageView!
    @IBOutlet weak var btnLoadMore: UIButton!
    
    
    // MARK: Proerties
    var itemCount:Int = 1
    var imagesArr:[String] = []
    var colorArr:[Attribute] = []
    var isExpanded: Bool = false {
           didSet {
               txtDescription.isHidden = !isExpanded
               btnExpandCollapse.isSelected = isExpanded
               updateExpandCollapseImage()
           }
       }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        configuatation()
    }
    
    // MARK: Function Register xib class
    func configuatation(){
        
         itemCollectionView.delegate =  self
         itemCollectionView.dataSource = self
        
         clrCollectionView.delegate =  self
         clrCollectionView.dataSource = self
         
         let productNib = UINib(nibName: "ProductImgCell", bundle: nil)
         self.itemCollectionView.register(productNib, forCellWithReuseIdentifier: "ProductImgCell")
         
         let clrNib = UINib(nibName: "ColorCell", bundle: nil)
         self.clrCollectionView.register(clrNib, forCellWithReuseIdentifier: "ColorCell")
        initial_Corner_Border()
    }
    
    // MARK: Function Corner / Border
    func initial_Corner_Border(){
        
        lblQuantity.layer.borderWidth = 1.5
        lblQuantity.layer.borderColor = UIColor.lightGray.cgColor
        
        lblCoupon.layer.cornerRadius = 8
        lblCoupon.layer.masksToBounds = true
        
        btnShare.layer.borderWidth = 1.5
        btnShare.layer.borderColor = UIColor.black.cgColor
        
        viewCoupon.layer.cornerRadius = 8
        viewCoupon.layer.shadowColor = UIColor.black.cgColor
        viewCoupon.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        viewCoupon.layer.shadowOpacity =  0.5
    
        // Create Load More Button With Underline
        let myButton = UIButton(type: .system)
        let buttonText = "Load More"
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        let attributedTitle = NSAttributedString(string: buttonText, attributes: attributes)
        
        btnLoadMore.setAttributedTitle(attributedTitle, for: .normal)
    }
    
    // MARK: Button Expand And Collapse
    @IBAction func btnExpandCollapsetxt(_ sender: Any) {
        isExpanded = !isExpanded
        updateExpandCollapseImage()
    }
    // MARK: Function Change Img
    func updateExpandCollapseImage() {
        
    let imageName = isExpanded ? "chevron.down" : "chevron.up"
    btnExpandCollapse.setImage(UIImage(named: imageName), for: .normal)
        
       }
    
    
    // MARK: Button Increase Item Count
    @IBAction func btnIncreaseCount(_ sender: UIButton) {
        if sender.isTouchInside{
            itemCount += 1
            self.lblQuantity.text = "\(itemCount)"
        }
    }
    
    // MARK: Button Decrease Item Count
    @IBAction func btnDecreaseCount(_ sender: UIButton) {
        if itemCount > 1 {
               itemCount -= 1
               self.lblQuantity.text = "\(itemCount)"
           }
      
    }
    
}
// MARK: CollectionView Delegate and Datasource Method
extension TableViewCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == itemCollectionView{
            return imagesArr.count
        }else{
            return colorArr.count
        }
      
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == itemCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductImgCell", for: indexPath) as! ProductImgCell

            if let url = URL(string: imagesArr[indexPath.item]) {
                cell.imgProducts.loadImage(from: url)
            }
            return cell
        }else{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as! ColorCell

            if let url = URL(string: colorArr[indexPath.item].images[0]) {
                cell.imgColor.loadImage(from: url)
            }
       return cell
        }
        
    }
    
    // MARK: Scroll Items
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == itemCollectionView{
            let pageWidth = scrollView.frame.size.width
            let currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
            pageController.currentPage = currentPage
        }
        
    }
}
// MARK: Size Method
extension TableViewCell: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == itemCollectionView{
            let collectionViewWidth = collectionView.bounds.width
            return CGSize(width: collectionViewWidth/1, height: collectionViewWidth/1)
        }else{
            let collectionViewWidth = collectionView.bounds.width
            return CGSize(width: collectionViewWidth/6-5, height: collectionViewWidth/6-5)
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
}
// MARK: Function Load Img From Url
extension UIImageView {
    func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Failed to load image data: \(error?.localizedDescription ?? "No error description")")
                return
            }
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }.resume()
    }
}


