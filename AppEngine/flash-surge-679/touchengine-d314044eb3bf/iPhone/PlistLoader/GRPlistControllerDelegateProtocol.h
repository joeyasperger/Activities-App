@class GRPlistController;

@protocol GRPlistControllerDelegate

@optional

// the list controller will automatically try to update data when the network status
// changes, but it asks for permission of the delegate first.
- (BOOL)listControllerShouldDownloadRemoteData:(GRPlistController *)listController;
- (void)listController:(GRPlistController *)listController downloadDidFailWithError:(NSError *)err;

// if the data from the server has changed...
- (void)listControllerDataWillChange:(GRPlistController *)listController;
- (void)listControllerDataDidChange:(GRPlistController *)listController;

@end