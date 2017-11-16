//
//  TimeTableViewController.swift
//  How Much Longer
//
//  Created by stvding on 2017/3/3.
//  Copyright © 2017年 shellCom. All rights reserved.
//

import UIKit

class ShowtimeSelectionPopoverVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var info: showtimeInfo? = nil
    var movieData: movieData? = nil
    let dformatter = DateFormatter()

    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        table.layer.cornerRadius = 20
        table.separatorStyle = UITableViewCellSeparatorStyle.none
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (info?.showtime.count)!
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "showtime", for: indexPath)
        cell.textLabel?.text = info?.showtime[indexPath.row].components(separatedBy: "T")[1]
        return cell
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        dformatter.timeZone = TimeZone(abbreviation: "EST")
        dformatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        let startTime = dformatter.date(from: (info?.showtime[(table.indexPathForSelectedRow?.row)!])!)
        
        movieData?.startTime = startTime
        movieData?.endTime = startTime?.addingTimeInterval(TimeInterval(15*60)).addingTimeInterval(TimeInterval((movieData?.runtime)!))
        
        
        let vc = segue.destination as! MovieDetailVC
        vc.data = movieData!
    }
    
    @IBAction func topPop(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func popBottom(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
