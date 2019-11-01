//
//  ViewController.m
//  多线程
//
//  Created by zhenhua.shen on 2019/11/1.
//  Copyright © 2019 zhenhua.shen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}


@end

/**
 任务:执行操作的意思 ,换句话说就是你在线程中执行的那段代码,在GCD中 是放在block中执行.
        执行任务有两种方式:同步执行和异步执行 区别在于是否等待队列的任务执行结束以及是否具备开启新线程的能力.
        同步执行(sync):同步添加到指定队列中,等待队列前面的任务执行完后才开始执行 只能在当前线程中执行 不具备开启新线程的能力
        异步执行(async):异步添加到指定队列中,不做任何等待,继续执行任务 可以在新线程中执行 具备开启新线程的能力(不一定开启,和队列类型有关)
 队列(Dispatch Queue):用来存放任务的 队列是一种特殊的线形表 采用先进先出(FIFO)
        队列有两种:串行队列和并发队列 两者区别在于 执行顺序不同以及开启的线程数不同
        串行队列(Serial Dispatch Queue):每次只有一个任务执行 只开启一个线程 一个任务执行完毕后再执行下一个任务
        并发队列(Concurrent Dispatch Queue):多个任务同时(并发)进行 开启多线程 (只在 dispatch_async异步才有效)
 
 GCD使用步骤
        创建一个队列 (串行或者并发)
        将任务追加到队列中,系统会根据任务类型才执行(同步执行或异步执行)
 
 队列创建方法
        dispatch_queue_create(const char * _Nullable label, dispatch_queue_attr_t  _Nullable attr)
        第一个参数(label):队列的唯一标识符
        第二个参数(dispatch_queue_attr_t): DISPATCH_QUEUE_SEROIAL表示串行队列 DISPATCH_QUEUE_CONCURRENT表示并发队列
        串行队列:dispatch_queue_t queue = dispatch_queue_create("one", DISPATCH_QUEUE_SERIAL);
        并发队列:dispatch_queue_t queue = dispatch_queue_create("one", DISPATCH_QUEUE_CONCURRENT);
 
        对于串行队列 GCD默认提供了主队列 主队列实质为一个串行队列 只因默认情况下当前代码是放在主队列中执行的 所有放在主队列的任务都会放到主线程中执行
        dispatch_queue_t queue = dispatch_get_main_queue();
 
        对于并发队列 GCD默认提供了全局并发队列(GLobal Dispatch Queue)

 */
