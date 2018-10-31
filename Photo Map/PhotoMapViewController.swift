//
//  PhotoMapViewController.swift
//  Photo Map
//
//  Created by Nicholas Aiwazian on 10/15/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit



class PhotoMapViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, LocationsViewControllerDelegate, MKMapViewDelegate {

    func locationsPickedLocation(controller: LocationsViewController, latitude: NSNumber, longitude: NSNumber) {
        let locationCoordinate = CLLocationCoordinate2D(latitude: latitude as! CLLocationDegrees, longitude: longitude as! CLLocationDegrees)
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationCoordinate
        annotation.title = "\(locationCoordinate.latitude)"
        mapView.addAnnotation(annotation)
        self.navigationController?.popToViewController(self, animated: true)
        
        
    }
    @IBOutlet weak var mapView: MKMapView!
    var image: UIImage!
    var imageToFull: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        //one degree of latitude is approximately 111 kilometers (69 miles) at all times.
        let sfRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.783333, -122.416667),
                                              MKCoordinateSpanMake(0.1, 0.1))
        mapView.setRegion(sfRegion, animated: false)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapTakePhoto(_ sender: Any) {
        let vc = UIImagePickerController()
        
        vc.delegate = self
        vc.allowsEditing = false
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available 📸")
            vc.sourceType = .camera
        } else {
            print("Camera 🚫 available so we will use photo library instead")
            vc.sourceType = .photoLibrary
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "myAnnotationView"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
        if (annotationView == nil) {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            annotationView!.canShowCallout = true
            annotationView!.leftCalloutAccessoryView = UIImageView(frame: CGRect(x:0, y:0, width: 50, height:50))
            
        }
        
        
        let imageView = annotationView?.leftCalloutAccessoryView as! UIImageView
        annotationView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
        imageView.image = image ?? UIImage(named: "camera")
        
        return annotationView
    }
    func mapView(_ mapView: MKMapView,
                 annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let imageView = view.leftCalloutAccessoryView as! UIImageView
        imageToFull = imageView.image
        
        self.performSegue(withIdentifier: "fullImageSegue", sender: nil)
        
    }
    
    
    @objc func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        image = chosenImage
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: showLocationViewController)
    
    }
    
    func showLocationViewController() -> Void {
        
        self.performSegue(withIdentifier: "tagSegue", sender: Any?.self)
    }

    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "tagSegue" {
            let destination = segue.destination as! LocationsViewController
            destination.delegate = self
        }
        if segue.identifier == "fullImageSegue" {
            let destination = segue.destination as! FullImageViewController
            destination.image = imageToFull
        }
    }

}
