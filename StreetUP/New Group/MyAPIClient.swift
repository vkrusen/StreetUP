//
//  BackendAPIAdapter.swift
//  Standard Integration (Swift)
//
//  Created by Ben Guo on 4/15/16.
//  Copyright © 2016 Stripe. All rights reserved.
//

//
//  BackendAPIAdapter.swift
//  Standard Integration (Swift)
//
//  Created by Ben Guo on 4/15/16.
//  Copyright © 2016 Stripe. All rights reserved.
//

import Foundation
import Stripe
import Alamofire
import Firebase

class MyAPIClient: NSObject, STPEphemeralKeyProvider {
    
    static let sharedClient = MyAPIClient()
    var baseURLString: String? = nil
    var baseURL: URL {
        if let urlString = self.baseURLString, let url = URL(string: urlString) {
            return url
        } else {
            fatalError()
        }
    }

    
    func completeCharge(_ result: STPPaymentResult,
                        amount: Int,
                        shippingAddress: STPAddress?,
                        shippingMethod: PKShippingMethod?,
                        completion: @escaping STPErrorBlock) {
        let url = self.baseURL.appendingPathComponent("charge")
        
            var params: [String: Any] = [
                "customer": "cus_DDVQ3OSLzdnf4X",
                "amount": amount,
                "currency" : "SEK"
            ]
            params["shipping"] = STPAddress.shippingInfoForCharge(with: shippingAddress, shippingMethod: shippingMethod)
            Alamofire.request(url, method: .post, parameters: params)
                .validate(statusCode: 200..<300)
                .responseString { response in
                    switch response.result {
                    case .success:
                        completion(nil)
                    case .failure(let error):
                        completion(error)
                    }
            }
    }
    
    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        let url = self.baseURL.appendingPathComponent("ephemeral_keys")
        Alamofire.request(url, method: .post, parameters: [
            "api_version": apiVersion,
            "customer_id": "cus_DDVQ3OSLzdnf4X"
            ])
            .validate(statusCode: 200..<300)
            .responseJSON { responseJSON in
                switch responseJSON.result {
                case .success(let json):
                    completion(json as? [String: AnyObject], nil)
                case .failure(let error):
                    completion(nil, error)
                }
        }
    }
    
}

/* - Firebase
import Foundation
import Stripe
import Alamofire
import Firebase

class MyAPIClient: NSObject, STPEphemeralKeyProvider {
    
    var customerID = "cus_DDVQ3OSLzdnf4X"
    var baseURLString: String? = nil
    
    static let sharedClient = MyAPIClient()
    var baseURL: URL {
        if let urlString = self.baseURLString, let url = URL(string: urlString) {
            return url
        } else {
            fatalError()
        }
    }

    func completeCharge(_ result: STPPaymentResult,
                        amount: Int,
                        shippingAddress: STPAddress?,
                        shippingMethod: PKShippingMethod?,
                        completion: @escaping STPErrorBlock) {
        
        let UID = Auth.auth().currentUser?.uid
        let id = arc4random()
        let url = self.baseURL.appendingPathComponent("/stripe_customers/\(UID!)/charges/\(id)")
        print(url)
        var params: [String: Any] = [
            "source": result.source.stripeID,
            "currency": "SEK",
            "amount": amount
        ]
        params["shipping"] = STPAddress.shippingInfoForCharge(with: shippingAddress, shippingMethod: shippingMethod)
        print(params)
        
        Alamofire.request(url, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
            .responseString { response in
                switch response.result {
                case .success:
                    completion(nil)
                case .failure(let error):
                    completion(error)
                }
        }
    }

    enum CustomerKeyError: Error {
        case missingBaseURL
        case invalidResponse
    }
    
    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        
        let URLString = "https://us-central1-streetup-3552d.cloudfunctions.net/createEphemeralKeys" //API_ENDPOINT + CREATE_EMPHEREMAL_KEY as String;
        
        let custID = customerID;
        
        var requestData : [String : String]? = [String : String]()
            requestData?.updateValue(apiVersion, forKey: "api_version");
            requestData?.updateValue(custID, forKey: "customerId");
        
        print(requestData!)
        
        submitDataToURL(URLString, withMethod: "POST", requestData: requestData!) { (jsonResponse, err) in
            if err != nil {
                completion(nil, err)
            }
            else {
                completion(jsonResponse, nil)
            }
        }
        
    }
    
    func submitDataToURL(_ urlString : String, withMethod method : String, requestData data : [String : Any], completion : @escaping (_ jsonResponse : [String : Any], _ err: Error?) -> Void) {
        do {
            guard let url = URL(string: urlString) else {return};
            
            let defaultSession = URLSession(configuration: .default)
            
            var urlRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
            
            urlRequest.httpMethod = method;
            urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")  // the request is JSON
            urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")        // the expected response is also JSON
            
            let httpBodyData : Data?
            
            try httpBodyData = JSONSerialization.data(withJSONObject: data, options: []);
            
            urlRequest.httpBody = httpBodyData;
            
            let dataTask = defaultSession.dataTask(with: urlRequest, completionHandler: { (responseData, urlResponse, error) in
                print("responseData \(String(describing: responseData!))");
                
                print("urlResponse \(String(describing: urlResponse!))");
                
                if error == nil {
                    do {
                        let response = try JSONSerialization.jsonObject(with: responseData!, options: []) as! [String : Any];
                        print(response);
                        completion(response, nil);
                    }
                    catch {
                        print("Exception")
                        let response : [String : Any] = [String : Any]()
                        completion(response, error);
                    }
                }
                else {
                    let response : [String : Any] = [String : Any]()
                    completion(response, error);
                }
            });
            
            dataTask.resume();
        }
        catch {
            print("Excetion in submitDataToURL")
        }
        
    }
    
    /*
     func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
     let endpoint = "/ephemeral_keys"
     
     guard
     !baseURLString.isEmpty,
     let baseURL = URL(string: baseURLString),
     let url = URL(string: endpoint, relativeTo: baseURL) else {
     completion(nil, CustomerKeyError.missingBaseURL)
     return
     }
     
     let parameters: [String: Any] = ["api_version": apiVersion]
     
     Alamofire.request(url, method: .post, parameters: parameters).responseJSON { (response) in
     guard let json = response.result.value as? [AnyHashable: Any] else {
     completion(nil, CustomerKeyError.invalidResponse)
     print(url)
     return
     }
     print(json)
     completion(json, nil)
     }
     }*/

}*/
