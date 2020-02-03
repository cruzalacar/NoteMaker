// NoteMaker
// Group MAAR
//  Map Kit Functionality added By Arceline Cruz

import UIKit
import CoreLocation
import MapKit


///Map View
class MapViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    let locationManager = CLLocationManager()
    var mainDelegate = UIApplication.shared.delegate as! AppDelegate
    var initialLocation = CLLocation()
    var wayLocation = CLLocation()
    @IBOutlet var myMapView : MKMapView!
    //@IBOutlet var tbwayPoint : UITextField!
    @IBOutlet var tbLocEntered : UITextField!
    @IBOutlet var myTableView : UITableView!
    @IBOutlet var firstLocation : UITextField!
    
    var routeSteps = ["Enter a destination to see the steps"] as NSMutableArray
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    let regionRadius : CLLocationDistance = 3000
    

    func centerMapOnLocation(location : CLLocation){
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius*2)
        myMapView.setRegion(coordinateRegion, animated: true)
    }
    func myAlert(title:String, msg:String) {
              let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
              let okayAction = UIAlertAction(title: "Close", style: .default, handler: nil)
              alertController.addAction(okayAction)
              present(alertController, animated: true, completion: nil)
          }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //find location initially entered through main page
        
     }
    
    @IBAction func findInitialLocation(){
        if(firstLocation.text == ""){
            myAlert(title: "Enter First Location", msg: "Then Enter Second Location")
            return
        }
        else{
            firstMap(locEnteredText: firstLocation.text!)
            
        }
    }
    //search for new lcoation
    @IBAction func findNewLocation(){
        if(firstLocation.text == ""){
            myAlert(title: "Enter First Location", msg: "Then Enter Second Location")
            return
        }
        else{
        let locEnteredText = tbLocEntered.text
        
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(locEnteredText!, completionHandler: {
            (placemarks, error) -> Void in
            if(error != nil){
                print("ERROR", error)
            }
            if let placemark = placemarks?.first{
                let coordinates : CLLocationCoordinate2D = placemark.location!.coordinate
                
                let newLocation = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
                self.centerMapOnLocation(location: newLocation)
                self.wayLocation = newLocation
                //check is new location is in bounding box
                let point = MKMapPoint(newLocation.coordinate)
                let mapRect = MKMapRect(x: point.x, y: point.y, width: point.coordinate.latitude, height: point.coordinate.longitude);

                for polygon in self.myMapView.overlays as! [MKPolygon] {
                    if polygon.intersects(mapRect) {
                        let alert = UIAlertController(title: "Location is in box", message: "True", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                        NSLog("The \"OK\" alert occured.")
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                    else{
                        let alert = UIAlertController(title: "Not in Box", message: "false", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                        NSLog("The \"OK\" alert occured.")
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }

                
                
                let dropPin = MKPointAnnotation()
                dropPin.coordinate = coordinates
                dropPin.title = placemark.name
                self.myMapView.addAnnotation(dropPin)
                self.myMapView.selectAnnotation(dropPin, animated: true)
                
                let request = MKDirections.Request()
                request.source = MKMapItem(placemark: MKPlacemark(coordinate: self.initialLocation.coordinate))
                request.destination = MKMapItem(placemark: MKPlacemark(coordinate: coordinates))
                request.requestsAlternateRoutes = false
                request.transportType = .automobile
                
                let directions = MKDirections(request: request)
                directions.calculate(completionHandler: {
                    (response, error) in
                    for route in response!.routes{
                        self.myMapView.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
                        self.myMapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                        
                        self.routeSteps.removeAllObjects()
                        for step in route.steps{
                            self.routeSteps.add(step.instructions)
                        }
                        
                        self.myTableView.reloadData()
                    }
                })
                
            }
            
        })
        }
    }
    
   
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if overlay is MKPolyline {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 3.0
            return renderer
        }
        else if overlay is MKPolygon {
            let renderer = MKPolygonRenderer(polygon: overlay as! MKPolygon)
            renderer.strokeColor = UIColor.black
            renderer.fillColor = UIColor.gray.withAlphaComponent(0.3)
                renderer.lineWidth = 2.0
            return renderer
        }
        
        return MKOverlayRenderer()
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routeSteps.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "cell") ??
        UITableViewCell()
        tableCell.textLabel?.text = routeSteps[indexPath.row] as! String
        
        return tableCell
    }
    
    //Display the map for the first location here
    func firstMap(locEnteredText : String){

       let geocoder = CLGeocoder()
       
        geocoder.geocodeAddressString(locEnteredText, completionHandler: {
           (placemarks, error) -> Void in
           if(error != nil){
               print("ERROR", error)
           }
           if let placemark = placemarks?.first{
               let coordinates : CLLocationCoordinate2D = placemark.location!.coordinate
                              let newLocation = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
               self.centerMapOnLocation(location: newLocation)
            
            self.initialLocation = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
               
               let dropPin = MKPointAnnotation()
               dropPin.coordinate = coordinates
               dropPin.title = placemark.name
               self.myMapView.addAnnotation(dropPin)
            
            let region = MKCoordinateRegion(center: newLocation.coordinate, latitudinalMeters: 4000,longitudinalMeters: 4000)
            
                 //Provide bounding box to map location setting to 20km
                 let minLng = region.center.longitude - region.span.longitudeDelta/2
                 let minLat = region.center.latitude - region.span.latitudeDelta/2
                 let maxLng = region.center.longitude + region.span.longitudeDelta/2
                 let maxLat = region.center.latitude + region.span.latitudeDelta/2

                    var coord = [ CLLocationCoordinate2D(latitude: maxLat,longitude: minLng),
                    CLLocationCoordinate2D(latitude: maxLat,longitude: maxLng),
                    CLLocationCoordinate2D(latitude: minLat,longitude: maxLng),
                    CLLocationCoordinate2D(latitude: minLat,longitude: minLng)]

                    
                 let polygon = MKPolygon(coordinates: &coord, count: coord.count)
                 self.myMapView.insertOverlay(polygon, at: 3); //self.myMapView.addOverlay(polygon,level:MKOverlayLevel.aboveRoads)
            self.myMapView.selectAnnotation(dropPin, animated: true)}}
            )
        self.centerMapOnLocation(location: initialLocation)
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = initialLocation.coordinate
        dropPin.title = "Starting Nowhere"
        self.myMapView.addAnnotation(dropPin)
        self.myMapView.selectAnnotation(dropPin, animated: true)
         }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
