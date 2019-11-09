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
    
    [self syncAndMain];
}
#pragma mark - 同步执行 + 并发队列
/**
* 同步执行 + 并发队列
* 特点：在当前线程中执行任务，不会开启新线程，执行完一个任务，再执行下一个任务。
*/
- (void)syncAndConcurrent{
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"syncAndConcurrent---begin");
    dispatch_queue_t queue = dispatch_queue_create("one", DISPATCH_QUEUE_CONCURRENT);
    dispatch_sync(queue, ^{
        // 追加任务 1
        [NSThread sleepForTimeInterval:1];              // 模拟耗时操作
        NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
    });
    dispatch_sync(queue, ^{
        // 追加任务 2
        [NSThread sleepForTimeInterval:1];              // 模拟耗时操作
        NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
    });
    dispatch_sync(queue, ^{
        // 追加任务 3
        [NSThread sleepForTimeInterval:1];              // 模拟耗时操作
        NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
    });
    NSLog(@"syncAndConcurrent---end");

    /**
     由log可以看出
     所有任务都在当前线程(主线程)中执行,没有开启新线程(同步执行不具备开启新线程的能力)
     所有任务都在 syncAndConcurrent---begin 和 syncAndConcurrent---end 之间执行的(同步任务需要等待队列的任务执行结束)
     任务按顺序执行,原因是虽然并发队列可以开启多个线程.并且同时执行多个任务.但本身不能创建新线程,只有当前这一个线程(同步执行不具备开启线程的能力),所以不存在并发.而且只有在当前线程中的任务执行完后 才继续执行下面的任务,所以任务只能一个接一个的按顺序执行,不能同时并发
     */
}
#pragma mark - 异步执行 + 并发队列
/**
 * 异步执行 + 并发队列
 * 特点：可以开启多个线程，任务交替（同时）执行。
 */
- (void)asyncAndConcurretn{
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"asyncAndConcurretn---begin");
    dispatch_queue_t queue = dispatch_queue_create("one", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        // 追加任务 1
        [NSThread sleepForTimeInterval:1];              // 模拟耗时操作
        NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
    });
    dispatch_async(queue, ^{
        // 追加任务 2
        [NSThread sleepForTimeInterval:1];              // 模拟耗时操作
        NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
    });
    dispatch_async(queue, ^{
        // 追加任务 3
        [NSThread sleepForTimeInterval:1];              // 模拟耗时操作
        NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
    });
    NSLog(@"asyncAndConcurretn---end");

    /**
     由log可以看出
     除了当前线程(主线程)外 系统又开启了三个线程 并且任务是同时/交替执行的(异步执行具备开启新线程的能力 并发队列可以开启多个线程,同时执行多个任务)
     
     所有的任务是在打印 asyncAndConcurretn---begin 和 asyncAndConcurretn---end 之后才执行的 说明当前线程没有等待 而是直接开启了新线程 在新线程中执行任务(异步执行 不做等待 直接继续执行任务)
     */
}
#pragma mark - 同步执行 + 串行队列
/**
* 同步执行 + 串行队列
* 特点：不会开启新线程，在当前线程执行任务。任务是串行的，执行完一个任务，再执行下一个任务。
*/
- (void)syncAndSerial{
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"syncAndSerial---begin");

    dispatch_queue_t queue = dispatch_queue_create("one", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"1---%@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"2---%@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"3---%@",[NSThread currentThread]);
    });
    NSLog(@"syncAndSerial---end");

    /**
     由log可以看出
     所有任务都在当前线程(主线程)中执行 没有开启新线程(同步执行不具备开启新线程)
     所有任务都在 syncAndSerial---begin 和 syncAndSerial---end 之间执行 (同步任务需要等待队列的任务执行结束)
     任务是按顺序执行(串行队列 每次只执行一个任务,任务按顺序执行)
     */
}
#pragma mark - 异步执行 + 串行队列
/**
* 异步执行 + 串行队列
* 特点：会开启新线程，但是因为任务是串行的，执行完一个任务，再执行下一个任务
*/
- (void)asyncAndSerial{
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"asyncAndSerial---begin");
    
    dispatch_queue_t queue = dispatch_queue_create("one", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"1---%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"2---%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"3---%@",[NSThread currentThread]);
    });
    NSLog(@"asyncAndSerial---end");
    
    /**
     由log可以看出
     开启了一条新线程(异步执行具备开启线程能力 串行队列只开启一个线程)
     所有任务是在 asyncAndSerial---begin 和 asyncAndSerial---end 之后才开始执行的（异步执行 不会做任何等待 可以继续执行任务）
     任务是按顺序执行 (串行队列 每次只有一个任务执行 任务是一个接一个按顺序执行)
     */
}
#pragma mark - 同步执行 + 主队列
/**
* 造成死锁
 */
- (void)syncAndMain{
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"syncAndMain---begin");
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_sync(queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"1---%@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"2---%@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"3---%@",[NSThread currentThread]);
    });
    NSLog(@"syncAndMain---end");
    
    /**
     原因: syncAndMain方法是在主线程中执行
     */
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
        第二个参数(dispatch_queue_attr_t): DISPATCH_QUEUE_SERIAL表示串行队列 DISPATCH_QUEUE_CONCURRENT表示并发队列
        串行队列:dispatch_queue_t queue = dispatch_queue_create("one", DISPATCH_QUEUE_SERIAL);
        并发队列:dispatch_queue_t queue = dispatch_queue_create("one", DISPATCH_QUEUE_CONCURRENT);
 
        对于串行队列 GCD默认提供了主队列 主队列实质为一个串行队列 只因默认情况下当前代码是放在主队列中执行的 所有放在主队列的任务都会放到主线程中执行
        dispatch_queue_t queue = dispatch_get_main_queue();
 
        对于并发队列 GCD默认提供了全局并发队列(GLobal Dispatch Queue) 使用dispatch_get_global_queue(long identifier, unsigned long flags)来获取全局并发队列
        第一个参数(identifier):优先级
        第二个参数(unsigned long flags):系统暂时没有用到 传0即可
        dispatch_queue_t queue = dispatch_get_global_queue(0,0);
 
 任务的创建方法
        CGD提供了同步执行任务(dispatch_sync)和异步执行任务(dispatch_async)
        同步执行:dispatch_sync(queue, ^{放同步执行的代码});
        异步执行:dispatch_async(queue, ^{放异步执行的代码});
 
 队列和任务不同组合方式的区别
        1.同步执行+并发队列
        2.异步执行+并发队列
        3.同步执行+串行队列
        4.异步执行+串行队列
 

 

 */
