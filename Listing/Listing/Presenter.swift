//
//  Presenter.swift
//  Listing
//
//  Created by PARTHIBAN on 09/02/19.
//  Copyright © 2019 PARTHIBAN. All rights reserved.
//
protocol PresenterDelegate:class {
    func startLoading()
    func finishLoading()
    func setDetail(_ details: [userDetail])
}
import Foundation
class Presenter {
    fileprivate let webService:Webservice
    weak fileprivate var presenterDelegate : PresenterDelegate?
    
    init(webService:Webservice){
        self.webService = webService
    }
    
    func attachView(_ delegate:PresenterDelegate){
        presenterDelegate = delegate
    }
    
//    func detachView() {
//        userView = nil
//    }
    
    func getUsers(){
        self.presenterDelegate?.startLoading()
        webService.getData { (data) in
            self.presenterDelegate?.finishLoading()
            if data.count > 0
            {
                self.presenterDelegate?.setDetail(data)
            }
            else
            {
                let dataList = [userDetail]()
                self.presenterDelegate?.setDetail(dataList)
            }
        }
    }
}
