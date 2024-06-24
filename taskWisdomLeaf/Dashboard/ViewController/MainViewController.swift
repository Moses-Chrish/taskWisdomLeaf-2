//
//  ViewController.swift
//  taskWisdomLeaf
//
//  Created by ilamparithi mayan on 23/06/24.
//

import UIKit
import Foundation

class MainViewController: UIViewController {

    @IBOutlet weak var picsTable: UITableView!
    
    
    // Activity indicator to show loading progress.
    var activityIndicator: UIActivityIndicatorView?
    // Lazy initialization of the view model.
    lazy var viewModel = {
       return MainViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        viewModel.fetchphotos(page: 0) {
            DispatchQueue.main.async {
                self.picsTable.reloadData()
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("receive memory warning")
    }
    // Set up the table view, including its delegate, data source, and refresh control.
    func tablesetup() {
        picsTable.delegate = self
        picsTable.dataSource = self
        picsTable.refreshControl = UIRefreshControl()
//        picsTable.refreshControl?.addTarget(self, action: #selector(refreshPhotos), for: .valueChanged)
        setupActivityIndicator()
    }
    // Initialize and configure the activity indicator.
    func setupActivityIndicator() {
            activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator?.color = .red
            guard let activityIndicator = activityIndicator else { return }
            
            activityIndicator.center = view.center
            activityIndicator.hidesWhenStopped = true
            picsTable.addSubview(activityIndicator)
        }
    // Show the activity indicator and hide it after 10 seconds.
        func showActivityIndicator() {
            activityIndicator?.startAnimating()
            DispatchQueue.main.asyncAfter(deadline: .now()+10, execute: {
                self.hideActivityIndicator()
            })
        }

        // Hide the activity indicator.
        func hideActivityIndicator() {
            self.activityIndicator?.stopAnimating()
        }


    
    // Update the data in the table view after a delay.
    func updateData() {
        DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
            
            self.picsTable.refreshControl?.endRefreshing()
            self.picsTable.reloadData()
//            self.loadImages()
        })
        
    }
    
    
}
// Return the number of rows in the section.

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getphotodatails.count
    }
    // Configure and return the cell for the given index path.
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = picsTable.dequeueReusableCell(withIdentifier: "tablecell", for: indexPath) as! loadingTableViewCell
        if self.viewModel.getphotodatails.indices.contains(indexPath.row) {
            let photoindex = self.viewModel.getphotodatails[indexPath.row]
            cell.config(photo: photoindex) {
                self.showAlert()
            }
        }
        
        // Fetch more data and reload tableview
        if indexPath.row == viewModel.getphotodatails.count - 1 {
            viewModel.currentPage += 1
            viewModel.fetchphotos(page: viewModel.currentPage) {
                self.reloadTableview()
            }
        }
        return cell
    }
    
    // Handle the checkbox tap action and display the photo URL in an alert.
    
    @objc func reloadTableview() {
        DispatchQueue.main.async {
            self.picsTable.reloadData()
        }
    }
    
    @objc func showAlert() {
        let alert = UIAlertController(title: "Alert", message: "This is sample testing message", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func checkboxTapped(_ sender: UISwitch) {
        let photo = viewModel.getphotodatails[sender.tag]
           let message = photo.url
           let alert = UIAlertController(title: "Photo URL", message: message, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default))
           present(alert, animated: true)
    }
    
    // Show an alert indicating the selection status of the photo.
    
    func showAlert(status: Bool, title: String) {
        let alertVC = UIAlertController(title: title, message: status ? "\(title) is Selected" : "\(title) is UnSelected", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertVC, animated: true)
    }
    
}
// Return the automatic dimension for the row height.

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // Handle the event when a cell is about to be displayed.
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.getphotodatails.count - 15 { // Last cell
            if viewModel.currentPage < viewModel.totalPages {
                viewModel.currentPage += 1
                viewModel.fetchphotos(page: viewModel.currentPage, completion: {
                    self.updateData()
                })
            }
        }
    }
        


}

