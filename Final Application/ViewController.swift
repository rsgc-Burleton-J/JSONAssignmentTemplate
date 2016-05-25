//: Playground - noun: a place where people can play

import UIKit


class ViewController : UIViewController {
    
    var shouldInvV : String = ""
    
    var openV : String = ""
    var openVI : Double = 0
    
    var closeV : String = ""
    var closeVI : Double = 0
    
    var low52V : String = ""
    var low52VI : Double = 0
    
    var high52V : String = ""
    var high52VI : Double = 0

    var dayLowV : String = ""
    var dayLowVI : Double = 0
    
    var dayHighV : String = ""
    var dayHighVI : Double = 0
    
    var uDV : String = ""
    
    // Views that need to be accessible to all methods
    let jsonResult = UILabel()
    
    // If data is successfully retrieved from the server, we can parse it here
    func parseMyJSON(theData : NSData) {
        
        // Print the provided data
        print("")
        print("====== the data provided to parseMyJSON is as follows ======")
        print(theData)
        
        // De-serializing JSON can throw errors, so should be inside a do-catch structure
        do {
            
            // Do the initial de-serialization
            // Source JSON is here:
            // "https://www.nseindia.com/live_market/dynaContent/live_watch/get_quote/ajaxGetQuoteJSON.jsp?symbol=INFY"
            //
            let json = try NSJSONSerialization.JSONObjectWithData(theData, options: NSJSONReadingOptions.AllowFragments)
            
            // Print retrieved JSON
            print("")
            print("====== the retrieved JSON is as follows ======")
            print(json)
            
            // Now we can parse this...
            print("")
            print("Now, add your parsing code here...")
            
            
            
            guard let tradingData : [String:AnyObject] = json as? [String: AnyObject]
                else {
                    print ("Could not find Trading Data")
                    return
            }
            guard let data : [AnyObject] = tradingData["data"] as? [AnyObject] else {
                "Could not retrieve data"
                return
            }
            print (data)
            
            guard let lastUpdate: String = tradingData ["lastUpdateTime"] as? String else{
                print ("Could not find Last updated time")
                return
            }
            print(lastUpdate)
            uDV = lastUpdate
            
            for i in data {
                
                guard let dataIn = i as? [String : AnyObject] else {
                    print("Could Not find data string")
                    return
                }
                print(dataIn)
                
                guard let open = dataIn ["open"] as? String else{
                    print("Could not find open value in data string")
                    return
                }
                print(open)
                
                guard let close = dataIn ["closePrice"] as? String else {
                    print("Could not find close value in data string")
                    return
                }
                print(close)
                
                
                guard let low52 = dataIn ["low52"] as? String else {
                    print("Could not find lowest 52 week value in data string")
                    return
                }
                print(low52)
                
                guard let high52 = dataIn ["high52"] as? String else {
                    print("Could not find highest 52 week value in data string")
                    return
                }
                print(high52)
                
                guard let dayLow = dataIn ["dayLow"] as? String else {
                    print("Could not find lowest day value in data string")
                    return
                }
                print(dayLow)
                
                guard let dayHigh = dataIn ["dayHigh"] as? String else {
                    print("Could not find lowest day value in data string")
                    return
                }
                print(dayHigh)
                
                
                openV = open
                closeV = close
                low52V = low52
                high52V = high52
                dayLowV = dayLow
                dayHighV = dayHigh
                
                if let numberO : Double = Double(openV) {
                    print ("\(numberO)")
                    openVI = numberO
                }
                if let numberC : Double = Double(closeV) {
                    print ("\(numberC)")
                    closeVI = numberC
                }
                if let numberL : Double = Double(low52V) {
                    print ("\(numberL)")
                    low52VI = numberL
                }
                if let numberH : Double = Double(high52V) {
                    print ("\(numberH)")
                    high52VI = numberH
                }
                if let numberDL : Double = Double(dayLowVI) {
                    print ("\(numberDL)")
                    dayLowVI = numberDL
                }
                if let numberDH : Double = Double(dayHighVI) {
                    print ("\(numberDH)")
                    dayHighVI = numberDH
                }
                
                if (low52VI > 935.0) {
                    shouldInvV = "Yes, (if you want a new car)"
                } else {
                    shouldInvV = "No (unless you enjoy losing money)"
                }
            }
            
         
                print (openV)
                print (closeV)
                print (low52V)
                print (high52V)
                print (dayLowV)
                print (dayHighV)
            
        
            
            // Now we can update the UI
            // (must be done asynchronously)
            dispatch_async(dispatch_get_main_queue()) {
                self.jsonResult.text = "Info Found"
                self.openValue.text = self.openV
                self.closeValue.text = self.closeV
                self.LastUpdate.text = self.uDV
                self.weekLow.text = self.low52V
                self.weekHigh.text = self.high52V
                self.dayLow.text = self.dayLowV
                self.dayHigh.text = self.dayHighV
                self.shouldInv.text = self.shouldInvV
            }
            
        } catch let error as NSError {
            print ("Failed to load: \(error.localizedDescription)")
        }
        
    }
    
    // Set up and begin an asynchronous request for JSON data
    func getMyJSON() {
        
        // Define a completion handler
        // The completion handler is what gets called when this **asynchronous** network request is completed.
        // This is where we'd process the JSON retrieved
        let myCompletionHandler : (NSData?, NSURLResponse?, NSError?) -> Void = {
            
            (data, response, error) in
            
            // This is the code run when the network request completes
            // When the request completes:
            //
            // data - contains the data from the request
            // response - contains the HTTP response code(s)
            // error - contains any error messages, if applicable
            
            // Cast the NSURLResponse object into an NSHTTPURLResponse objecct
            if let r = response as? NSHTTPURLResponse {
                
                if r.statusCode == 200 {
                    
                    if let d = data {
                        
                        // Parse the retrieved data
                        self.parseMyJSON(d)
                        
                    }
                    
                }
                
            }
            
        }
        
        // Define a URL to retrieve a JSON file from
        let address : String = "https://www.nseindia.com/live_market/dynaContent/live_watch/get_quote/ajaxGetQuoteJSON.jsp?symbol=INFY"
        
        // Try to make a URL request object
        if let url = NSURL(string: address) {
            
            // We have an valid URL to work with
            print(url)
            
            // Now we create a URL request object
            let urlRequest = NSURLRequest(URL: url)
            
            // Now we need to create an NSURLSession object to send the request to the server
            let config = NSURLSessionConfiguration.defaultSessionConfiguration()
            let session = NSURLSession(configuration: config)
            
            // Now we create the data task and specify the completion handler
            let task = session.dataTaskWithRequest(urlRequest, completionHandler: myCompletionHandler)
            
            // Finally, we tell the task to start (despite the fact that the method is named "resume")
            task.resume()
            
        } else {
            
            // The NSURL object could not be created
            print("Error: Cannot create the NSURL object.")
            
        }
        
    }
    
    
    
    @IBOutlet weak var openValue: UILabel!
    
    @IBOutlet weak var closeValue: UILabel!
    
    @IBOutlet weak var LastUpdate: UILabel!
    
    @IBOutlet weak var weekLow: UILabel!
    
    @IBOutlet weak var weekHigh: UILabel!
    
    @IBOutlet weak var dayLow: UILabel!
    
    @IBOutlet weak var dayHigh: UILabel!
    
    @IBOutlet weak var shouldInv: UILabel!
    
    // This is the method that will run as soon as the view controller is created
    override func viewDidLoad() {
        
        // Sub-classes of UIViewController must invoke the superclass method viewDidLoad in their
        // own version of viewDidLoad()
        //super.viewDidLoad()
        
        /*
         * Further define label that will show JSON data
         */
        
        
        // Set the label text and appearance
        jsonResult.text = "Raw Stock Data"
        jsonResult.font = UIFont.systemFontOfSize(12)
        jsonResult.numberOfLines = 0   // makes number of lines dynamic
        // e.g.: multiple lines will show up
        jsonResult.textAlignment = NSTextAlignment.Center
        
        // Required to autolayout this label
        jsonResult.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the label to the superview
        view.addSubview(jsonResult)
        
        /*
         * Add a button
         */
        
        let getData = UIButton(frame: CGRect(x: 0, y: 0, width: 150, height: 30))
        
        // Make the button, when touched, run the calculate method
        getData.addTarget(self, action: #selector(ViewController.getMyJSON), forControlEvents: UIControlEvents.TouchUpInside)
        
        // Set the button's title
        getData.setTitle("Stock Tips Applicaton", forState: UIControlState.Normal)
        
        // Required to auto layout this button
        getData.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the button into the super view
        view.addSubview(getData)
        
        /*
         * Layout all the interface elements
         */
        //Connect Text fields to values
        
        
        // This is required to lay out the interface elements
        //view.translatesAutoresizingMaskIntoConstraints = false
        
        // Create an empty list of constraints
        var allConstraints = [NSLayoutConstraint]()
        
        // Create a dictionary of views that will be used in the layout constraints defined below
        let viewsDictionary : [String : AnyObject] = [
            "title": jsonResult,
            "getData": getData]
        
        // Define the vertical constraints
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-50-[getData]-[title]",
            options: [],
            metrics: nil,
            views: viewsDictionary)
        
        // Add the vertical constraints to the list of constraints
        allConstraints += verticalConstraints
        
        // Activate all defined constraints
        NSLayoutConstraint.activateConstraints(allConstraints)
        
    }
    
}

