//
//  ViewController.swift
//  ECommerceDemo
//
//  Created by kavita chauhan on 21/06/24.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    
    // MARK: Proerties
    var apiModel = ApiViewModel()
    var expandedIndex: Set<Int> = [0]
    var dataList:[DataClass] = []
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configuration()
    }
    // MARK: Get APi
    func configuration(){
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TableViewCell")
        
        apiModel.callgetApi()
        
        apiModel.apiSuccess = { response in
            self.dataList.append(response.data)
            self.tableView.reloadData()
        }
        apiModel.apiError = {error in
            print(error.localizedDescription)
        }
    }
    
}
// MARK: Table view delegate and datasource Method
extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.imagesArr = dataList[indexPath.row].images
        cell.colorArr = dataList[indexPath.row].configurableOption[indexPath.row].attributes
        cell.pageController.numberOfPages = dataList[indexPath.row].images.count
        cell.pageController.currentPage = 0
        
        let htmlString = dataList[indexPath.row].description
        cell.txtDescription.text = htmlString.htmlToString
        cell.lblItemName.text? = dataList[indexPath.row].brandName.uppercased()
        cell.lblBrandName.text = dataList[indexPath.row].name
        lblTitle.text = dataList[indexPath.row].name
        let float = Float(dataList[indexPath.row].finalPrice) ?? 0.0
        let aString: String = String(format: "%.2f", float)
        
        cell.lblPrice.text = aString + " KWD"
        cell.selectionStyle = .none
        cell.lblSku.text = "SKU " + dataList[indexPath.row].sku
        cell.isExpanded = expandedIndex.contains(indexPath.row)
        cell.btnExpandCollapse.tag = indexPath.row
        cell.btnExpandCollapse.addTarget(self, action: #selector(didTapExpandCollapse(_:)), for: .touchUpInside)
        cell.btnShare.addTarget(self, action: #selector(shareSelectedItem(_:)), for: .touchUpInside)
      
        return cell
    }
    
    // MARK: Function Share Itmes
    @objc func shareSelectedItem(_ sender:UIButton){
            let activityVC = UIActivityViewController(activityItems: [""], applicationActivities: nil)
                activityVC.popoverPresentationController?.sourceView = sender
                present(activityVC, animated: true, completion: nil)
                activityVC.completionWithItemsHandler = { (activityType, completed:Bool, returnedItems:[Any]?, error: Error?) in
        
                    if completed  {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            
    }
    

    // MARK: Button Expand and Collapse TextView
    @objc func didTapExpandCollapse(_ sender: UIButton) {
           let indexPath = IndexPath(row: sender.tag, section: 0)
           
           if expandedIndex.contains(indexPath.row) {
               expandedIndex.remove(indexPath.row)
           } else {
               expandedIndex.insert(indexPath.row)
           }
           
           DispatchQueue.main.async {
               self.tableView.layoutIfNeeded()
           }
       }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
 
}

// MARK: Function Convert Html data into String

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("Error converting HTML to AttributedString: \(error)")
            return nil
        }
    }

    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
