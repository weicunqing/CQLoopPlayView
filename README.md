# CQLoopPlayView
#   iOS 轮播图
github: https://github.com/weicunqing/CQLoopPlayView.git
email:  weicunqing_iOS@163.com

### 支持cocoapods
pod 'CQLoopPlayView'

##  如果顶部出现一条空白,请尝试设置controller的automaticallyAdjustsScrollViewInsets属性为NO

##  简单使用方法
 // 一步创建，添加到父视图即可
CQLoopPlayView *loopPlayView = [CQLoopPlayView loopPlayViewWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, 200) placeholderImage:[UIImage imageNamed:@"66.jpg"]];

[self.view addSubview:loopPlayView];

  // 本地图片数组
 loopPlayView.localImageNameArray = @[@"11.jpg",@"22.jpg",@"33.jpg",@"44.jpg",@"55.jpg"];

  // 网络图片数组
loopPlayView.URLStringArray =  @[
@"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
@"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
@"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
];

  // 自动轮播的时间间隔,默认是5.0s
loopPlayView.timeInterval = 3.0;

  // 左下方文字
loopPlayView.textArray = @[@"感谢您的使用😁",@"喜欢的话请帮忙点赞👍哦!",@"欢迎交流:weicunqing_iOS@163.com"];

  // 右下方文字
loopPlayView.detailTextArray = @[@"1/3",@"2/3",@"3/3"];


## 更多属性设置 请参考 CQLoopPlayView.h


