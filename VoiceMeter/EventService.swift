//
//  EventService.swift
//  VoiceMeter
//
//  Created by Arkadiusz Jachnik on 28.12.2016.
//  Copyright © 2016 Arkadiusz Jachnik. All rights reserved.
//

import Foundation
import Alamofire

class EventService : IEventService {
    let serviceAddress = "http://192.168.1.124:8080/event/"
    typealias T = Event
    
    func post(obj:Event) -> Bool {
        var res : Bool = false
        var request = initRequest(httpMethod: .POST)
        request.httpBody = obj.toData()
        Alamofire.request(request).responseJSON { (closureResponse) in
            switch(closureResponse.result){
            case .success(_):
                res = true
                break
            case .failure(_):
                res = false
            }
        }
        return res
    }
    
    private func initRequest(httpMethod: HttpMethod) -> URLRequest{
        var req: URLRequest = URLRequest(url: URL(string: serviceAddress)!)
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("application/json", forHTTPHeaderField: "Accept")
        req.httpMethod = httpMethod.rawValue
        return req
    }
}
