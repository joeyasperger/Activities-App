//
//  FriendsViewController.m
//  Spring
//
//  Created by Joseph Asperger on 9/9/14.
//
//

#import "FriendsViewController.h"
#import "Friend.h"
#import "ServerInfo.h"

@interface FriendsViewController ()

@property NSMutableArray *friends;
@property (strong, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation FriendsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.friends = [NSMutableArray new];
    /*TableDownloader *downloader = [[TableDownloader alloc] initWithURL:[ServerInfo friendsURL:[UserProfile userID]] type:FRIEND_DOWNLOADER saveFile:@"myfriends.plist"];
    downloader.delegate = self;*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"didReceiveResponse");
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
    NSLog(@"Connection failed: %@", [error description]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %ld bytes of data",(long)[self.responseData length]);
    
    NSString* pliststr = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", pliststr);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pathString = [documentsDirectory stringByAppendingPathComponent:@"friends.plist"];
    
    [pliststr writeToFile:pathString atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    NSArray *plistFriends = [NSArray arrayWithContentsOfFile:pathString];
    for (int i = 0; i < [plistFriends count]; i++){
        NSDictionary *friendDict = [plistFriends objectAtIndex:i];
        Friend *newFriend = [Friend new];
        newFriend.userID = [[friendDict valueForKey:@"userID"] integerValue];
        newFriend.name = [friendDict valueForKey:@"username"];
        
        [self.friends addObject:newFriend];
    }
    [self.tableView reloadData];
    
}*/

-(void) downloadCompleted:(NSMutableArray *)array{
    self.friends = array;
    [self.tableView reloadData];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.friends count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"FriendTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = ((Friend*)self.friends[indexPath.row]).name;
    cell.imageView.image = [UIImage imageNamed:@"greybox.jpg"];
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
