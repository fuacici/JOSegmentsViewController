//
//  JOSegmentsViewController.m
//  
//  Created by joost on 13-7-23.
//  Copyright (c) 2013年 eker. All rights reserved.
//

#import "JOSegmentsViewController.h"

@interface JOSegmentsViewController ()
{
  NSInteger _currentItemIndex;
}
@end

@implementation JOSegmentsViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
#if! __has_feature(objc_arc)
  [_segments release];
  [_viewControllers release];
  [super dealloc];
#endif
}
- (void)setSegments:(UISegmentedControl *)segments
{
#if! __has_feature(objc_arc)
  [_segments release];
#endif
  [_segments removeTarget:self action:@selector(changeViewController:) forControlEvents:UIControlEventValueChanged];
  CGRect rct = segments.frame;
  rct.origin.x=0;
  rct.origin.y=0;
  rct.size.width = self.view.bounds.size.width;
#if! __has_feature(objc_arc)
  _segments = [segments retain];
#else
  _segments= segments;
#endif
  [_segments addTarget:self action:@selector(changeViewController:) forControlEvents:UIControlEventValueChanged];
}
#pragma mark - viewcontroller hierarchy 
- (void)setViewControllers:(NSArray *)viewControllers
{
  if (_currentItemIndex>=0 && _currentItemIndex< _viewControllers.count-1)
  {
    [[_viewControllers[_currentItemIndex] view] removeFromSuperview];
  }
#if! __has_feature(objc_arc)
  [_viewControllers release];
#endif
  _currentItemIndex =-1;
  //disconnect from old ones
  [_viewControllers makeObjectsPerformSelector:@selector(removeFromParentViewController)];
#if! __has_feature(objc_arc)
  _viewControllers = [viewControllers retain];
#else
  _viewControllers = viewControllers;
#endif
  for (UIViewController * subvc in _viewControllers)
  {
    [subvc willMoveToParentViewController:self];
    [self addChildViewController: subvc];
    [subvc didMoveToParentViewController: self];
  }
  [self switchToItemAtIndex:0];
}
- (void)switchToItemAtIndex:(NSInteger) index
{
  if (index> _viewControllers.count-1 || index<0)
  {
    return;
  }
  //remove old view
  if (_currentItemIndex>=0)
  {
    [[_viewControllers[_currentItemIndex] view] removeFromSuperview];
  }
  //add new view
  _currentItemIndex = index;
  UIViewController * vc = _viewControllers[_currentItemIndex];
  vc.view.frame = [self visibleArea];
  [self.view addSubview:vc.view];
  
  //bar items
  self.navigationItem.leftBarButtonItem = vc.navigationItem.leftBarButtonItem;
  self.navigationItem.rightBarButtonItem = vc.navigationItem.rightBarButtonItem;
  self.navigationItem.titleView = vc.navigationItem.titleView;
}
- (CGRect)visibleArea
{
  CGRect t = self.view.bounds;
  t.origin.y = self.segments.frame.origin.y+self.segments.frame.size.height;
  t.size.height = t.size.height - t.origin.y;
  return t;
}
- (void)changeViewController:(id)sender
{
  [self switchToItemAtIndex: _segments.selectedSegmentIndex];
}
@end
