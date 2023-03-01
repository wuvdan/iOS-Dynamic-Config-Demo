
现在客户端的功能越开发越大，功能点越多，功能点入口也很多，通过动态配置可以每个功能或页面进行解耦，方便控制开启与关闭，通过动态配置也可以减少App版本升级带来的很多兼容性问题。在项目上线前把项目基础功能点通过路由注册好，方便在App中和网页中操作。针对新版本新功能，旧版本没办法使用的情况，可以更加友好的提示用户升级版本或者设置网页入口给用户提供简易入口。<br />通过路由可以在原生页面中、H5中、扫码、URL Scheme打开对应页面，入口统一方便维护。
<a name="LZXhY"></a>
# 一、组件化
使用路由配置页面，通过路由中注册路径与参数打开对应的页面。<br />注册页面建议使用`protocol://path/path?params=URL编码内容`<br />例如：`appscheme://demo/page1?dataJSON=%7B%22showType%22%3A%201%7D`
<a name="SUMT8"></a>
## 常用三方工具类

- [JLRoutes](https://links.jianshu.com/go?to=https%3A%2F%2Fgithub.com%2Fjoeldev%2FJLRoutes)
- [routable-ios](https://links.jianshu.com/go?to=https%3A%2F%2Fgithub.com%2Fclayallsopp%2Froutable-ios)
- [HHRouter](https://links.jianshu.com/go?to=https%3A%2F%2Fgithub.com%2Flightory%2FHHRouter)
- [MGJRouter](https://links.jianshu.com/go?to=https%3A%2F%2Fgithub.com%2Fmeili%2FMGJRouter)
- [CTMediator](https://links.jianshu.com/go?to=https%3A%2F%2Fgithub.com%2Fcasatwy%2FCTMediator)
<a name="qa8Ud"></a>
## 组件化页面

- 普通功能页面
- WebView
- 跨平台页面（uni-app）
- 支付页面
- 404页面
- 其他自定义页面
<a name="Nc10h"></a>
## 组件化功能

- 关闭当前页（pop/dismiss）
- 分享弹窗
- 支付弹窗
- 不支持路径提示下载最新版本
- 打开微信，支付宝小程序
- 打开导航弹窗（苹果地图，高德地图，百度地图，腾讯地图）
   - xcode配置qqmap://
   - xcode配置iosamap://
   - xcode配置baidumap://
- token等基本信息失效（例如：让App退到登录页）
- openURL
   - 发短信
   - 打电话
   - 地图
   - 邮件
- alter
- actionSheet
<a name="kQI5s"></a>
# 二、URL Scheme
自定义配置项目`URL Scheme`, 需要再`项目配置`->`TARGETS`->`info`->`URL Types`中添加一项并填入

| 键名 | 说明 | 示例 |
| --- | --- | --- |
| Identifier | 项目bundleId  | com.xxx.xxx |
| URL Scheme | App专属标识 | AliPay |

可以通过在浏览器中测试，例如`AppScheme://`如果可以打开App，即说明配置成功。
<a name="NVKAu"></a>
## 使用SceneDelegate获取路径与参数
App未启动时
```objectivec
- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [connectionOptions.URLContexts enumerateObjectsUsingBlock:^(UIOpenURLContext * _Nonnull obj, BOOL * _Nonnull stop) {
            // TODO: 获取到链接`obj.URL`打开对应Router
        }];
    });
}
```
App已启动
```objectivec
- (void)scene:(UIScene *)scene openURLContexts:(NSSet<UIOpenURLContext *> *)URLContexts {
    [URLContexts enumerateObjectsUsingBlock:^(UIOpenURLContext * _Nonnull obj, BOOL * _Nonnull stop) {
        // TODO: 获取到链接`obj.URL`打开对应Router
    }];
}
```
<a name="pKMhw"></a>
## 使用AppDelegate获取路径与参数
App未启动时
```objectivec
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // TODO: 获取到链接`launchOptions[UIApplicationLaunchOptionsURLKey]`打开对应Router
    });
    return YES;
}
```
App已启动
```objectivec
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    // TODO: 获取到链接`url`打开对应Router
    return YES;
}
```
注意：路径打开会转成小写字母，所以请设定路径时就全部为小写字母
<a name="y8Wql"></a>
# 三、扫码
通过之前注册的路径生成二维码，扫描二维码解析路径后进行页面操作。
<a name="gTkS0"></a>
# 四、JS交互
<a name="UNmNm"></a>
## 原生页面获取网页中信息
原生页面显示样式由网页来控制，例如导航栏的样式，字体颜色，状态栏颜色，右侧按钮，导航栏是否随页面滚动，可以直接通过js触发消息通知原生页面变更样式。<br />通过`WKUserContentController`控制页面操作，实例注册两个事件`style`和`action`,<br />js在网页中触发为示例：

- 打开页面
```javascript
window.webkit.messageHandlers.action.postMessage({ "url": "appscheme://demo/page1" });
```

- 弹窗效果
```javascript
window.webkit.messageHandlers.action.postMessage({ "url": "appscheme://xxx/xxx?dataJSON=%7B%22type%22%3A%202%7D" });
```
<a name="GNmu7"></a>
#### 

- 设置样式
```javascript
window.webkit.messageHandlers.style.postMessage({
    "showNavigationBar": true,
    "scrollNavigationBar": false,
    "backgroundColor": "#FF333333",
    "barTinColor": "#ffffffff",
    "statusBarBlack": true,
    "rightButtons": [
       {
          "text": "分享",
          "icon": "https://abc.xxx.com/img/icon.png",
          "action": "appSchema/path/path"
       },
       {
          "text": "举报",
          "icon": "https://abc.xxx.com/img/icon.png",
          "action": "appSchema/path/path"
       }
    ],
    "notSupportGesture": true,
    "notSupportBounces": true
});
```
<a name="mRAj5"></a>
#### Action

- 关闭网页
- 控制原生样式
- 打开原生页面
- 打开弹窗
- 打开支付
- 打开分享
<a name="IeqcL"></a>
#### Style

- 是否显示导航栏
- 导航栏是否随页面滚动
- 导航栏颜色
- 状态栏颜色
- 文字和按钮颜色
- 右侧按钮内容与点击操作
- 是否支持手势返回，默认支持
- 是否支持上下回弹效果，默认iOS支持
```json
{
  "showNavigationBar": true, // 是否显示导航栏
  "scrollNavigationBar": true, // 导航栏是否随页面滚动，默认透明然后滚动显示颜色
  "backgroundColor": "#fffffff", // 背景颜色
  "barTinColor": "#ff333333", // 标题颜色，按钮颜色
  "statusBarBlack": true, // 状态是否为黑色
  "rightButtons": [ // 右边区域按钮
    {
      "text": "分享", // 按钮文本呢
      "icon": "https://abc.xxx.com/img/icon.png", // 按钮图标
      "action": "appSchema/path/path" // 按钮点击操作
    },
    {
      "text": "举报", // 按钮文本呢
      "icon": "https://abc.xxx.com/img/icon.png", // 按钮图标
      "action": "appSchema/path/path" // 按钮点击操作
    }
  ],
  "notSupportGesture": false, // 是否不支持手势返回
  "notSupportBounces": false // 是否不支持回弹效果
}
```
<a name="Wx7ul"></a>
## 网页获取原生信息
网页中可能需要原生App提供一个基本信息，例如

- App版本
- App渠道（iOS、Android）
- 用户token等基本信息

<a name="NsOgW"></a>
# <br />
