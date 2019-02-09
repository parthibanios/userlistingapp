//
//  ListingViewController.swift
//  Listing
//
//  Created by PARTHIBAN on 09/02/19.
//  Copyright © 2019 PARTHIBAN. All rights reserved.
//

import UIKit
class ListingViewController: UIViewController {
    
    @IBOutlet weak var lblRecordNotFound: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    fileprivate let presenter = Presenter(webService: Webservice())
    fileprivate var userdetailList = [userDetail]()
    fileprivate var currentUserList = [userDetail]()
    override func viewDidLoad() {
        super.viewDidLoad()
        lblRecordNotFound.isHidden = true
        activityIndicator?.hidesWhenStopped = true
        tableView.isHidden = true
        presenter.attachView(self)
        presenter.getUsers()
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        
        tableView.tableFooterView = spinner
        tableView.tableFooterView?.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func loadMoreData(_ index:Int)
    {
        tableView.tableFooterView?.isHidden = false

        if userdetailList.count > (index + 9)
        {
          currentUserList.append(contentsOf: userdetailList[index...(index + 9)])
        }
        else
        {
         currentUserList.append(contentsOf: userdetailList[index...(currentUserList.count - 1)])
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.tableView.tableFooterView?.isHidden = true
            self.tableView.reloadData()
        })
        
    }
}

extension ListingViewController: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentUserList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell") as! CustomTableViewCell
        let userDetail = currentUserList[indexPath.row]
        cell.lblName.text = userDetail.first_name! + " " + userDetail.last_name!
        cell.imgView.downloadImageFrom(link: userDetail.avatar!, contentMode: UIViewContentMode.scaleAspectFit)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if currentUserList.count < userdetailList.count
        {
            if offsetY > contentHeight - scrollView.frame.size.height {
               
                loadMoreData(currentUserList.count)
            }
        }
    }
}

extension UIImageView {
    func downloadImageFrom(link:String, contentMode: UIViewContentMode) {
        URLSession.shared.dataTask( with: NSURL(string:link)! as URL, completionHandler: {
            (data, response, error) -> Void in
            DispatchQueue.main.async {
                self.contentMode =  contentMode
                if let data = data { self.image = UIImage(data: data) }
            }
        }).resume()
    }
}

extension ListingViewController:PresenterDelegate
{
    func startLoading() {
        activityIndicator?.startAnimating()
    }
    
    func finishLoading() {
        activityIndicator?.stopAnimating()
    }
    
    func setDetail(_ details: [userDetail]) {
        userdetailList = details
        if userdetailList.count > 0
        {
            tableView?.isHidden = false
            self.loadMoreData(0)
        }
        else
        {
            lblRecordNotFound.isHidden = false
        }
    }
    
    
}
