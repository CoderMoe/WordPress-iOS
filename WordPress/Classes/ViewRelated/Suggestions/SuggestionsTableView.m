#import "SuggestionsTableView.h"
#import "SuggestionsTableViewCell.h"
#import "Suggestion.h"
#import "UIImageView+AFNetworking.h"
#import "SuggestionService.h"

NSString * const CellIdentifier = @"SuggestionsTableViewCell";

@interface SuggestionsTableView ()

@property (nonatomic, strong) NSNumber *siteID;
@property (nonatomic, strong) NSArray *suggestions;
@property (nonatomic, strong) NSString *searchText;
@property (nonatomic, strong) NSArray *searchResults;

@end

@implementation SuggestionsTableView


- (id)initWithWidth:(CGFloat)width andSiteID:(NSNumber *)siteID
{    
    // TODO: Start with height of 0, let VC pin our top
    self = [super initWithFrame:CGRectMake(0.f, 0.f, width, 240.f)];
    if (self) {
        UINib *nib = [UINib nibWithNibName:@"SuggestionsTableViewCell" bundle:nil];
        [self registerNib:nib forCellReuseIdentifier:CellIdentifier];

        _siteID = siteID;
        _suggestions = [[SuggestionService shared] suggestionsForSiteID:_siteID];
        _searchText = @"";
        
        [self setDataSource:self];
        
        [self showSuggestions:NO]; // initially hidden please
    }
    
    return self;
}

- (void)dealloc
{
    self.delegate = nil;
}

- (void)viewWillAppear:(BOOL)animated
{   
    self.rowHeight = 50.0;
    
    // suppress display of blank rows
    self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(suggestionListUpdated:)
                                                 name:SuggestionListUpdatedNotification
                                               object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)filterSuggestionsForKeyPress:(NSString *)keypress inWord:(NSString *)word
{    
    if ([keypress isEqualToString:@"@"]) {
        if ([keypress isEqualToString:word]) {
            [self updateSearchResultsForText:@""];
            [self reloadData];
            [self showSuggestions:YES];
        }
    } else {
        if ([word hasPrefix:@"@"]) {
            [self updateSearchResultsForText:[word substringFromIndex:1]];
            [self reloadData];
            [self showSuggestions:YES];
        } else {
            [self updateSearchResultsForText:@""];
            [self reloadData];
            [self showSuggestions:NO];
        }
    }
}

- (void)updateSearchResultsForText:(NSString *)text
{
    // Save how we got here
    _searchText = text;
    
    if (_searchText.length > 0) {
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"(displayName contains[c] %@) OR (userLogin contains[c] %@)",
                                        _searchText, _searchText];
        self.searchResults = [self.suggestions filteredArrayUsingPredicate:resultPredicate];
    }
    else {
        self.searchResults = self.suggestions;
    }
}

- (void)showSuggestions:(BOOL)show
{
    if (show) {
        self.hidden = NO;
        [self.superview bringSubviewToFront:self];
    } else {
        [self updateSearchResultsForText:@""];
        self.hidden = YES;
        [self.superview sendSubviewToBack:self];
    }
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.suggestions) {
        return 1;
    }
    
    return self.searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SuggestionsTableViewCell *cell = [self dequeueReusableCellWithIdentifier:CellIdentifier
                                                                forIndexPath:indexPath];
    
    if (!self.suggestions) {
        cell.usernameLabel.text = NSLocalizedString(@"Loading...", @"Suggestions loading message");
        cell.displayNameLabel.text = nil;
        [cell.avatarImageView setImage:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    Suggestion *suggestion = [self.searchResults objectAtIndex:indexPath.row];
    
    cell.usernameLabel.text = [NSString stringWithFormat:@"@%@", suggestion.userLogin];
    cell.displayNameLabel.text = suggestion.displayName;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    [self setAvatarForSuggestion:suggestion forCell:cell indexPath:indexPath];
    
    return cell;
}

#pragma mark - Suggestion list management

- (void)suggestionListUpdated:(NSNotification *)notification
{
    // only reload if the suggestion list is updated for the current site
    if ([notification.object isEqualToNumber:_siteID]) {
        self.suggestions = [[SuggestionService shared] suggestionsForSiteID:_siteID];
        
        [self updateSearchResultsForText:_searchText];
        
        [self reloadData];
    }
}

- (NSArray *)suggestions
{
    if (!_suggestions) {
        _suggestions = [[SuggestionService shared] suggestionsForSiteID:_siteID];
    }
    return _suggestions;
}

#pragma mark - Avatar helper

- (void)setAvatarForSuggestion:(Suggestion *)post forCell:(SuggestionsTableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    CGSize imageSize = CGSizeMake(SuggestionsTableViewCellAvatarSize, SuggestionsTableViewCellAvatarSize);
    UIImage *image = [post cachedAvatarWithSize:imageSize];
    if (image) {
        [cell.avatarImageView setImage:image];
    } else {
        [cell.avatarImageView setImage:[UIImage imageNamed:@"gravatar"]];
        [post fetchAvatarWithSize:imageSize success:^(UIImage *image) {
            if (!image) {
                return;
            }
            if (cell == [self cellForRowAtIndexPath:indexPath]) {
                [cell.avatarImageView setImage:image];
            }
        }];
    }
}

@end
