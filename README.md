# iOSJailbreakTools

## 何为 iOSJailbreakTools

iOS逆向分析时，常常需要一台越狱设备，同时安装 RevealLoader、OpenSSH、Cycript 等逆向分析工具。如果你没有一台拥有 root 权限的 iOS 设备，你就无法使用这些工具来逆向分析 App。

iOSJailbreakTools 是一个越狱平台上的工具集合，将 RevealLoader、Cycript 整合成一个独立的 dylib。你只需要将该 dylib 注入到要分析的 App 中，然后签名，安装到 iOS 设备上，即可在非越狱的设备上使用 Reveal 和 Cycript 分析工具。

## 安装

#### 拷贝 libDebugger.dylib 至 XXX.app 目录中
#### 注入 libDebugger.dylib

```sh
$ optool install -p @executable_path/libDebugger.dylib -t /path/to/binary
```

## 使用 Reveal

> iOS: libReveal.dylib 1.6.3
> 
> Mac: Reveal for macOS 1.6.3 [Download](https://revealapp.com/download/#direct)

使用同一个局域网，运行 App 即可使用 Reveal。

## 使用 Cycript

> iOS: libCycript.dylib
> 
> Mac: Terminal

在同一个局域网下，使用 TCP 链接到设备中：

```sh
cycript -r 192.168.xxx.xxx:8888
```

192.168.xxx.xxx 是设备内网 IP，8888 是默认端口号。

如果出现以下情况：

```sh
*** _syscall(connect(socket_, info->ai_addr, info->ai_addrlen)):../Console.cpp(306):CYSocketRemote [errno=61]
```

说明 8888 端口无法正常使用，可以通过 cycript.port 文件修改端口：

工具会自动识别 Documents、mainBundle 下的 cycript.port 文件，你只需要将新的端口号写入 cycript.port，然后重启 App 即可。

端口号使用的优先级如下:

Documents/cycript.port > XXX.app/cycript.port > 8888

## 使用内置 API

工具提供内置 API 用于分析：

### UIControl+DebugLib

```objc
@interface UIControl (DebugLib)

/**
 *	输出所有 Target-Action 映射表
 */
- (NSDictionary *)dlib_eventActions;

@end
```

对于某个 button，想知道单击之后触发的 target-action，即可在 cycript 中如下调用：

```sh
cy> var btn = #fffffff
cy> [btn dlib_eventActions]
```


