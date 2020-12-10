//
//  DataModelServices.swift
//  ContactTracing
//
//  Created by Wameedh Mohammed Ali on 12/3/20.
//
import Foundation

extension String {
	subscript(i: Int) -> String {
		return String(self[index(startIndex, offsetBy: i)])
	}
}

struct DataModelServices {
    
    // request params: username, pass, device_token
    // response: login_token
	
	struct SignupResponse: Codable {
		let success: Bool
	}
    
    // "https://localhost:4000/login"
    
    func login(username: String, password: String, device_token: String, callback: @escaping (String) -> Void) {
        
        let url = URL(string: "http://18.188.195.49:4000/login")
        guard let requestUrl = url else { fatalError() }
        
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        
        // HTTP Request Parameters which will be sent in HTTP Request Body
        let jsonBody = "{\"username\":\"" + username + "\",\"password\":\"" + password + "\",\"device_token\":\"" + device_token + "\"}"
        print(jsonBody)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        // Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check for Error
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            // check HTTP Response
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                    print ("server error")
                    return
            }
            
            // Convert HTTP Response Data to a String
            guard let data = data else {
                // TODO: Deal with the error if this is an error
                return
            }
            let decoder = JSONDecoder()
            do {
                let decoded = try decoder.decode(User.self, from: data)
                print(decoded.login_token)
                callback(decoded.login_token) // return LocationObject
            } catch {
                print(error)
            }
        }
        task.resume()
        
    }
    
    
    //app signup req(username: string, password: string) res(success: bool)
    
    func signup(username: String, password: String, callback: @escaping (Bool) -> Void) {
        
        let url = URL(string: "http://18.188.195.49:4000/signup")
        guard let requestUrl = url else { fatalError() }
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        
        // HTTP Request Parameters which will be sent in HTTP Request Body
        let jsonBody = "{\"username\":\"" + username + "\",\"password\":\"" + password + "\"}"
        print(jsonBody)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        // Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            
            // Check for Error
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            // check HTTP Response
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                    print ("server error")
                    return
            }
			
			guard let data = data else {
				// TODO: Deal with the error if this is an error
				return
			}
			let decoder = JSONDecoder()
			do {
				let decoded = try decoder.decode(SignupResponse.self, from: data)
				print(decoded.success)
				callback(decoded.success)
			} catch {
				print(error)
			}
            
            callback()
            
        }
        task.resume()
        
    }
    
    
    //get locations of the user req(username: string, login_token: int) res(locations: [Location])
    // "https://localhost:4000/getLocation"
    
    func getLocation(username: String, login_token: String, callback: @escaping (LocationObject) -> Void) {
        let url = URL(string: "http://18.188.195.49:4000/getLocation")
        guard let requestUrl = url else { fatalError() }
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        
        // HTTP Request Parameters which will be sent in HTTP Request Body
        let jsonBody = "{\"username\":\"" + username + "\",\"login_token\":\"" + login_token + "\"}"
        print(jsonBody)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        // Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check for Error
            if let error = error {
                print("Error took place \(error)")
                return
            }
            // check HTTP Response
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                    print ("server error")
                    return
            }
            
            // Convert HTTP Response Data to a String
            guard let data = data else {
                // TODO: Deal with the error if this is an error
                return
            }
            let decoder = JSONDecoder()
            do {
                let decoded = try decoder.decode(LocationObject.self, from: data)
                
                callback(decoded) // return LocationObject
            } catch {
                print(error)
            }
            
        }
        task.resume()
        
    }
    
    
    // log location
    //req(username: string, login_token: string, latitude: double, longtitude: double) res()
    
    func logLocation(username: String, login_token: String, latitude: Double, longtitude: Double, callback: @escaping () -> Void) {
        
        let url = URL(string: "http://18.188.195.49:4000/logLocation")
        guard let requestUrl = url else { fatalError() }
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        
        // HTTP Request Parameters which will be sent in HTTP Request Body
		/*
		let jsonBody = "{\"username\":\"" + username + "\",\"login_token\":\"" + login_token + "\",\"latitude\":\"" + latitude + "\",\"longtitude\":\"" + longtitude + "\"}"
*/
		
		let param : [String: Any] = [
			"username": username,
			"login_token": login_token,
			"latitude": latitude,
			"longtitude": longtitude
		]
        //print(jsonBody)
		
		guard let body = try? JSONSerialization.data(withJSONObject: param, options: []) else {return}
		
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        
        // Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check for Error
            if let error = error {
                print("Error took place \(error)")
                return
            }
            // check HTTP Response
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                    print ("server error")
                    return
            }
            
        }
        task.resume()
    }
    
    func reportInfection(username: String, login_token: String) -> Void {
		
		print("\(username) reporting infection")
		guard let endpoint = URL(string: "http://18.188.195.49:4000/report") else { return }
		
		let headers = [
			"content-type": "application/json",
			"accept": "application/json"
		]
		
		let param : [String:Any] = [
			"username": username,
			"login_token": login_token
		]
		
		guard let body = try? JSONSerialization.data(withJSONObject: param, options: []) else {return}
		
		var request = URLRequest(url: endpoint)
		
		request.httpMethod = "POST"
		request.allHTTPHeaderFields = headers
		request.httpBody = body
		
		let task = URLSession.shared.dataTask(with: request) {(data,response,error) in
			if let error = error {
				print("there's and error: \(error)")
				return
			}
			
			guard let response = response as? HTTPURLResponse,(200...299).contains(response.statusCode) else {
				print("server error")
				return
			}
			
			print(response)
		}
		
		task.resume()
	}
}
