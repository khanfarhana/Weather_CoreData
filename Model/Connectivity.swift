//
//  Connectivity.swift
//  VaccineCenters
//
//  Created by Neha Penkalkar on 15/05/21.
//

import Alamofire

class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
