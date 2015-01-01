//
//  ViewController.m
//  testwetherapp
//
//  Created by Sujith Chandran on 12/22/14.
//  Copyright (c) 2014 Sujith Chandran. All rights reserved.
//

#import "ViewController.h"
#import "TableViewCell.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,CLLocationManagerDelegate>
{
    NSMutableArray *cityname,*wetherdetails,*listarray;
    
    NSMutableDictionary *citydetail,*alldetail;
 CLLocationManager *locationManager;
    CLLocation *loc;
    CLLocationCoordinate2D *userloc;
}

@end

@implementation ViewController
@synthesize swipeview;
@synthesize cityTableView,textfield,citynamelabel,cityview,viewcityname,viewcountry,viewgeo,activity;

- (void)viewDidLoad {
    [super viewDidLoad];
    [activity stopAnimating];
    swipeview.hidden=YES;
    
    cityview.hidden=YES;
    swipeview.delegate=self;
    swipeview.dataSource=self;
    swipeview.alignment = SwipeViewAlignmentCenter;
    swipeview.pagingEnabled = YES;
    swipeview.itemsPerPage = 1;
    swipeview.truncateFinalPage = YES;
    
    cityname =[[NSMutableArray alloc]initWithCapacity:0];
    wetherdetails =[[NSMutableArray alloc]initWithCapacity:0];
     listarray =[[NSMutableArray alloc]initWithCapacity:0];
    citydetail =[[NSMutableDictionary alloc]initWithCapacity:0];
    alldetail =[[NSMutableDictionary alloc]initWithCapacity:0];
    cityTableView.delegate=self;
    cityTableView.dataSource=self;
    textfield.delegate=self;
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    
    
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    
    [locationManager startUpdatingLocation];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
   if([cityname count]>0)
    {
        return [cityname count];
        
    }
    else
    {
        return 0;
    }
    
  
    
  
    
    
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
   
        view = [[NSBundle mainBundle] loadNibNamed:@"itemview" owner:self options:nil][0];
        
  
    citynamelabel.text=[cityname objectAtIndex:index];
    
      // [cityTableView reloadData];
    return view;
}
- (void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index
{
    [swipeview scrollToItemAtIndex:index duration:.5];
    
    NSLog(@"%ld",(long)index);
}
- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView
{
    [cityTableView reloadData];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.textfield resignFirstResponder];
}
- (IBAction)add:(id)sender {
    
    
    if(![textfield.text isEqualToString:@""])
    {
        int flag=0;
        for (NSString *a in cityname) {
            
        if([a isEqualToString:textfield.text])
        {
            flag =1;
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"ALERT" message:@"City name already added" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
            return;
        }
            else
            {
                flag=0;
            }
        
            
        }
        
        
        if(flag==0)
        {
           // self.aboutapp.hidden=YES;
            
          //  [swipeview reloadData];
            [textfield resignFirstResponder];
            
            [self.activity startAnimating];
           // [self wetherDetails:textfield.text];
            [self performSelectorInBackground:@selector(wetherDetails:) withObject:textfield.text];
           // [swipeview scrollToItemAtIndex:[cityname count] duration:.5];
            
            
            
            swipeview.hidden=NO;
            

        }
        
    }
    
    
    
    
    
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    if([swipeview numberOfItems] > 0)
    {
    NSInteger current=[swipeview currentItemIndex];
    if([wetherdetails count]>= current)
    {
    NSDictionary *details=[wetherdetails objectAtIndex:current];
    
    NSString *str=[details objectForKey:@"cod"] ;
    
    
    
    if([str isEqualToString:@"404"])
    {
        NSLog(@"city not found");
        cityview.hidden=NO;
        viewcityname.text=@"";
        viewgeo.text=@"";
        
        viewcountry.text=@"City not found";
        return 1;
        
    }
    else
    {
        NSDictionary *citydic=[details objectForKey:@"city"];
        NSDictionary *coord=[citydic objectForKey:@"coord"];
        NSString *lat=[coord objectForKey:@"lat"];
        NSString *lon=[coord objectForKey:@"lon"];
        NSString *con=[citydic objectForKey:@"country"];
        NSString *name=[citydic objectForKey:@"name"];
        
        viewcityname.text=name;
        viewcountry.text=con;
        viewgeo.text=[NSString stringWithFormat:@"Latitude = %@ , Longitude = %@",lat,lon ];
        
        cityview.hidden=NO;
        
        return 14;
        
    }

    }
    }
    return 0;
    
   }
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"cell";
    
    TableViewCell *c=(TableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(c==nil)
    {
        NSArray *ar=[[NSBundle mainBundle]loadNibNamed:@"TableViewCell" owner:self options:nil];
        c=[ar objectAtIndex:0];
    }
    
  
   
   
    NSInteger current=[swipeview currentItemIndex];
    
    NSDictionary *details=[wetherdetails objectAtIndex:current];
    
    NSString *str=[details objectForKey:@"cod"] ;
    
    
    
    if([str isEqualToString:@"404"])
    {
        cityTableView.hidden=YES;
        c.notfoundview.hidden=NO;
        
        
    }
    else
    {
        cityTableView.hidden=NO;
        c.notfoundview.hidden=YES;
        
        listarray=[details objectForKey:@"list"];
        NSDictionary *listdetail=[listarray objectAtIndex:indexPath.row];
        NSArray *weatherarray=[listdetail objectForKey:@"weather"];
        NSDictionary *tempdic=[listdetail objectForKey:@"temp"];
        
        NSString *desc=[[weatherarray objectAtIndex:0] objectForKey:@"description"];
        NSString *icon=[[weatherarray objectAtIndex:0] objectForKey:@"icon"];
        
        NSString *min=[tempdic objectForKey:@"min"];
        int mintemp= [min intValue]-273.15;
        
        
        NSString *max=[tempdic objectForKey:@"max"];
        int maxtemp=[max intValue]-273.15;
        
        
        
        NSString *cloud=[listdetail objectForKey:@"clouds"];
        NSString *pressure=[listdetail objectForKey:@"pressure"];
        NSString *humidity=[listdetail objectForKey:@"humidity"];
        NSString *wind=[listdetail objectForKey:@"speed"];
        
        UIImage *img=[UIImage imageNamed:[icon stringByAppendingString:@".png"]];
        if(img)
        {
        c.imageview.image=img;
        }
        else
        {
            c.imageview.hidden=YES;
        }
        c.descLabel.text=[desc uppercaseString];
        c.tempLabel.text=[NSString stringWithFormat:@"Temprature from %d to %d°С",mintemp,maxtemp];
        c.windLabel.text=[NSString stringWithFormat:@"Wind %@m/s",wind];
        c.humidityLabel.text=[NSString stringWithFormat:@"Humidity %@%%",humidity];
        c.cloudLabel.text=[NSString stringWithFormat:@"Clouds %@%%",cloud];
        c.pressurLabel.text=[NSString stringWithFormat:@"Pressure %@hpa",pressure];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yy-MM-dd"];
        
        
        
        NSDate *today = [NSDate date];
        //int day=indexPath.row;
        NSDate *newdate=[today dateByAddingTimeInterval:60*60*24*indexPath.row];
        
        NSString *theDate = [dateFormat stringFromDate:newdate];
        c.dateLabel.text=theDate;
        
        
        
        
        
        
        
        
        
    }

    
    
    
    
    
    
    
    return c;

}








    

- (void)wetherDetails:(NSString *)city {
    
          NSString *place=city;
            
            NSString *url=[NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?q=%@&cnt=14&APPID=3eb55c18170d82cdfc638191dba4ed70",place];
    
   
            
            
   NSString *escurl= [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url1 = [NSURL URLWithString:escurl];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url1
                                                                   cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                               timeoutInterval:10];
            
            [request setHTTPMethod: @"GET"];
            
            NSError *requestError;
            NSURLResponse *urlResponse = nil;
            
            
            NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
            
            
            if(response)
            {
                
                
                NSDictionary *resdic=[NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
                [wetherdetails addObject:resdic];
                
                NSString *str=[resdic objectForKey:@"cod"] ;
                
                
                
                if([str isEqualToString:@"404"])
                {
                    cityview.hidden=NO;
                    viewcityname.text=@"";
                    viewgeo.text=@"";
                    
                    viewcountry.text=@"City not found";
                }
                else
                {
                    NSDictionary *citydic=[resdic objectForKey:@"city"];
                    NSDictionary *coord=[citydic objectForKey:@"coord"];
                    NSString *lat=[coord objectForKey:@"lat"];
                    NSString *lon=[coord objectForKey:@"lon"];
                    NSString *con=[citydic objectForKey:@"country"];
                    NSString *name=[citydic objectForKey:@"name"];
                    
                    viewcityname.text=name;
                    viewcountry.text=con;
                    viewgeo.text=[NSString stringWithFormat:@"Latitude = %@ , Longitude = %@",lat,lon ];
                    
                    cityview.hidden=NO;
                }
                //[cityTableView reloadData];
               // cityTableView.hidden=NO;
                [cityname addObject:textfield.text];
                [swipeview reloadData];
                [swipeview scrollToItemAtIndex:[cityname count] duration:.5];
                [cityTableView reloadData];
                textfield.text=@"";
                
                
                
                
            }
            else
            {
                NSLog(@"no network connectivity");
               // cityTableView.hidden=YES;
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Sorry" message:@"Seems Network is down" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                
            }

            
            
    [self.activity stopAnimating];

}


- (IBAction)removecity:(id)sender {
    [cityname removeObjectAtIndex:[swipeview currentItemIndex]];
    [wetherdetails removeObjectAtIndex:[swipeview currentItemIndex]];
   
    
    [swipeview reloadData];
    if(![swipeview currentItemIndex]==0)
    {
    swipeview.currentItemIndex=[swipeview currentItemIndex]-1;
    }
    else
    {
        NSLog(@"only one city");
        cityview.hidden=YES;
        swipeview.hidden=YES;
    }
    
    
    
    [swipeview reloadData];
   
    
    [cityTableView reloadData];
    
    
    
    
}
- (IBAction)currentlocation:(id)sender {
   
    loc=  locationManager.location;
    if(loc)
    {
        if([cityname containsObject:@"Current Location"])
        {
            
            [wetherdetails removeObjectAtIndex:[cityname indexOfObject:@"Current Location"]];
            [cityname removeObjectAtIndex:[cityname indexOfObject:@"Current Location"]];
            
                        
        }
        
        
        
        
    NSString *usrlat= [NSString stringWithFormat:@"%f",[loc coordinate].latitude ];
    NSString *usrlon= [NSString stringWithFormat:@"%f",[loc coordinate].longitude ];
        
        
        
        
        
        
        NSString *url=[NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?lat=%@&lon=%@&cnt=14&APPID=3eb55c18170d82cdfc638191dba4ed70",usrlat,usrlon];
        
        
        
        
        [url stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                               cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                           timeoutInterval:10];
        
        [request setHTTPMethod: @"GET"];
        
        NSError *requestError;
        NSURLResponse *urlResponse = nil;
        
        
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
        
        
        if(response)
        {
            
            
            NSDictionary *resdic=[NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
            [wetherdetails addObject:resdic];
            
            NSString *str=[resdic objectForKey:@"cod"] ;
            
            
            
            if([str isEqualToString:@"404"])
            {
                cityview.hidden=NO;
                viewcityname.text=@"";
                viewgeo.text=@"";
                
                viewcountry.text=@"City not found";
            }
            else
            {
                NSDictionary *citydic=[resdic objectForKey:@"city"];
                NSDictionary *coord=[citydic objectForKey:@"coord"];
                NSString *lat=[coord objectForKey:@"lat"];
                NSString *lon=[coord objectForKey:@"lon"];
                NSString *con=[citydic objectForKey:@"country"];
                NSString *name=[citydic objectForKey:@"name"];
                
                viewcityname.text=name;
                viewcountry.text=con;
                viewgeo.text=[NSString stringWithFormat:@"Latitude = %@ , Longitude = %@",lat,lon ];
                
                cityview.hidden=NO;
            }
            //[cityTableView reloadData];
            // cityTableView.hidden=NO;
            //[cityname addObject:textfield.text];
            [cityname addObject:@"Current Location"];
            [swipeview reloadData];
            [swipeview scrollToItemAtIndex:[cityname count] duration:.5];
            [cityTableView reloadData];
            textfield.text=@"";
            
            
            
            
        }
        else
        {
            NSLog(@"no network connectivity");
            // cityTableView.hidden=YES;
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Sorry" message:@"Seems Network is down" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
        }

    
    swipeview.hidden=NO;
    
    }
    }
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    
    if(![CLLocationManager locationServicesEnabled])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"GPS Not available"
                                                        message:@"Please check if loaction service is enabled otherwise please try again later"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}

@end
