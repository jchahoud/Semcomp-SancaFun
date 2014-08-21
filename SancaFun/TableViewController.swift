//
//  TableViewController.swift
//  SancaFun
//
//  Created by Juliana Chahoud on 8/19/14.
//  Copyright (c) 2014 jchahoud. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    var parties = NSMutableArray()

    let APITOKEN = "cfi0vtturic/pv85hiwuM9EfYecr5sg4087z5kK7GNl3az6ELQQn6bEazFrV52m/w6LtUmaZct2pq7/fKc9voA=="
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.getParties()
    }
    
    func getParties()
    {
        let apiUrl = NSURL (string: "http://sanca.goldarkapi.com/event?order_by=date:asc")
        
        //cria request, conexao
        var request = NSMutableURLRequest (URL: apiUrl)
        request.HTTPMethod = "GET"
        request.addValue(APITOKEN, forHTTPHeaderField: "X-Api-Token")
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{
            (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            var err: NSError
            
            //transforma o JSON de resposta em dicionario
            var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
            
            if let data:NSArray = jsonResult["data"] as? NSArray
            {
                self.parties = NSMutableArray(array: data)
            }
            
            //recarrega tabela para exibir novos dados
            self.tableView.reloadData()
            
        })
        
        return;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {

        return 1
    }

    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.parties.count
    }

    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
        //cria ou reutiliza uma celula ja existente
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        //le o objeto do array correspondente ao indice da celula
        let object = self.parties[indexPath.row] as NSDictionary
        cell.textLabel.text = object["name"] as NSString
        
        //exibe a data formatada
        let partyDate = object["date"] as NSString
        cell.detailTextLabel.text = self.formattedDate(partyDate)

        //pega a URL da imagem e obtem os dados
        let urlString: NSString = object["smallimageurl"] as NSString
        let imgURL: NSURL = NSURL(string: urlString)
        let imgData: NSData = NSData(contentsOfURL: imgURL)
        
        cell.imageView.image = UIImage(data: imgData)

        return cell
    }
    

    func formattedDate(date:NSString) ->String{
        let month = date.substringWithRange(NSMakeRange(5, 2))
        let day = date.substringWithRange(NSMakeRange(8, 2))
        let hour = date.substringWithRange(NSMakeRange(11, 2))
        let min = date.substringWithRange(NSMakeRange(14, 2))
        return day + "/" + month + " " + hour + ":" + min
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
}
