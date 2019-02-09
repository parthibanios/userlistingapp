//
//  Webservice.swift
//  AddressList
//
//  Created by PARTHIBAN on 21/01/19.
//  Copyright © 2019 PARTHIBAN. All rights reserved.
//

import UIKit

class Webservice: NSObject {
    func getData(completion:@escaping(_ dataList:[userDetail])->Void){
        let url = "https://api-india.getsprouter.com/api/v2/testapi"
        
        URLSession.shared.dataTask(with: URL.init(string: url)!){(data,response,err) in
            DispatchQueue.main.async {
                    do {
                        let result = try JSONDecoder().decode(userList.self, from: data!)
                        completion(result.data!)
                    } catch let err {
                        print("Err", err)
                    }
            }
            }.resume()
    }
    
}

