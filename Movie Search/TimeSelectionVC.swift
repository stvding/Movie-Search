////
////  TimeSelectionVC.swift
////  How Much Longer
////
////  Created by stvding on 2017/3/1.
////  Copyright © 2017年 shellCom. All rights reserved.
////
//
//import UIKit
//
//class TimeSelectionVC: UIViewController {
//    var data: movieData?
//    
//    @IBOutlet weak var moviePoster: UIImageView!
//    @IBOutlet weak var movieStartTimePicker: UIDatePicker!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
////        if let data = self.data{
////            print("got data!")
////        }else{
////            print("no fucking data!")
////        }
//        
//        
//        if let poster = data?.posterURL{
//            if let posterURL = URL(string: poster){
//                DispatchQueue.global(qos: .userInitiated).async {
//                    if let posterData = NSData(contentsOf: posterURL){
//                        DispatchQueue.main.async {
//                            self.moviePoster.image = UIImage(data: posterData as Data)!
//                        }
//                    }
//                }
//            }
//        }
//    }
//    
//    let preShow = TimeInterval(15*60)
//    
////    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
////        let vc = segue.destination as! DetailVC
////        data?.endTime = movieStartTimePicker.date.addingTimeInterval(preShow).addingTimeInterval(TimeInterval((data?.runtime)!))
////        vc.data = data!
////    }
//}
