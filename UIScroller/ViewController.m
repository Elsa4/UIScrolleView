//
//  ViewController.m
//  UIScroller
//
//  Created by 尤翠翠 on 16/4/14.
//  Copyright © 2016年 YiZhi. All rights reserved.
//

#import "ViewController.h"

#define KSCREEN_WIDTH     [UIScreen mainScreen].bounds.size.width
#define KSCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height


@interface ViewController ()<UIScrollViewDelegate>

@property (nonatomic, retain)UIScrollView *scrollView;
@property (nonatomic, retain)UIImageView *imageView;
@property (nonatomic, retain)UIPageControl *pageControl;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT)];
    self.scrollView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.scrollView];
    
    //将一组图片加载到
    for (int i = 0; i <= 3; i++) {
        self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png", i + 1]]];
        [self.imageView setFrame:CGRectMake(self.scrollView.frame.size.width * i, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
        [self.scrollView addSubview:self.imageView];
    }
    
    //设定幕布的大小
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 4, self.scrollView.frame.size.height);
    //设置水平滚动条是否显示,默认YES
    self.scrollView.showsHorizontalScrollIndicator = YES;
    self.scrollView.showsVerticalScrollIndicator   = NO;
    //设置滚动条的样式,三种  默认/ 黑色/ 白色
    self.scrollView.indicatorStyle = UIScrollViewIndicatorStyleDefault;
    //是否支持滚动, 默认为yes
    self.scrollView.scrollEnabled = YES;
    //设置内容区域的偏移量,默认无偏移(0, 0),改变的是幕布的bounds,图片加载到幕布上,幕布坐标点由(0,0)改为(10,30)则坐标点(0,0)就要左上移动,图片也会跟着移动,以至于右边的幕布显露出来
    self.scrollView.contentOffset = CGPointMake(0, 0);
    //设置当滑动到屏幕边缘时是否有反弹效果,默认YES
    self.scrollView.bounces = NO;
    //当点击状态条时,scrollView是否偏移到最顶部(y轴偏移归0),默认yes
    self.scrollView.scrollsToTop = YES;
    
    //指定代理,监测scrollView的动作
    self.scrollView.delegate = self;
    
    //设定最大最小缩放比例
    self.scrollView.minimumZoomScale = 1;
    self.scrollView.maximumZoomScale = 5;
    
    //是否整屏滚动,一次滑动整个scrollView的大小
    self.scrollView.pagingEnabled = YES;

    
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 20, self.view.frame.size.width, 20)];
    [self.view addSubview:self.pageControl];
    self.pageControl.backgroundColor = [UIColor grayColor];
    

    //设定页标的数量(0~4页数 - 1),小圆点的个数
    self.pageControl.numberOfPages  = 4;
    //当只有一个页标时,是否隐藏,默认NO
    self.pageControl.hidesForSinglePage = YES;
    //设定当前页标
//    self.pageControl.currentPage = 2;
    NSLog(@"%ld", self.pageControl.currentPage);
    //设定非选中页标的颜色
    self.pageControl.pageIndicatorTintColor = [UIColor blueColor];
    //设定选中页标的颜色
    self.pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
    //将pageControl和UIScrollView 相结合
    [self.pageControl addTarget:self action:@selector(handlePageControl:) forControlEvents:UIControlEventValueChanged];
    
    
    


}


-(void)handlePageControl:(UIPageControl *)sender
{
    NSLog(@"%ld", sender.currentPage );
    //通过currentPage属性得到当前页标下标
    //通过观察得出,用当前页标值 * 滚动视图的宽度正好得到需要偏移的量
    //根据X偏移,Y不变得到新的contentOffset
    CGPoint point = CGPointMake(sender.currentPage * self.scrollView.frame.size.width, 0);
    NSLog(@"%@", [self class]);
    //通过新得到的偏移量,让滚动视图发生偏移,并伴随动画
    [self.scrollView  setContentOffset:point animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //翻动半页, 小圆点才移动到下一个
    int index = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.pageControl.currentPage = index;
    
    int half_x = scrollView.frame.size.width / 2;
    int page = (scrollView.contentOffset.x - half_x) / self.view.frame.size.width + 1;
    self.pageControl.currentPage = page;
    
    NSLog(@"%s, scrollView已经滚动", __FUNCTION__);
}
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    NSArray * ary = [self.scrollView subviews];
    NSUInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    NSLog(@"%s, scrollView确定缩放对象,并返回", __FUNCTION__);
    return [ary objectAtIndex:index];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
