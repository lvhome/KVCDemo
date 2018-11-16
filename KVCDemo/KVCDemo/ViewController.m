//
//  ViewController.m
//  KVCDemo
//
//  Created by  on 2018/11/15.
//  Copyright © 2018年 MAC. All rights reserved.
//

#import "ViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //一 、KVC定义 KVC(Key-value coding)键值编码，就是指iOS的开发中，可以允许开发者通过key直接访问对象的属性，或者给对象的属性赋值。而不需要调用明确的存储方法。这样就可以在运行时动态地访问和修改对象的属性。
    //KVC的定义是对NSObject的扩展实现，OC中有个显式的NSKeyValueCoding类别名，对于所有继承了NSObject的类型都能使用KVC  常用的方法：
    /*- (nullable id)valueForKey:(NSString *)key;                         //直接通过Key来取值
     - (void)setValue:(nullable id)value forKey:(NSString *)key;          //通过Key来进行设值
     - (nullable id)valueForKeyPath:(NSString *)keyPath;                  //通过KeyPath来取值
     - (void)setValue:(nullable id)value forKeyPath:(NSString *)keyPath;  //通过KeyPath来设值*/
    
     //KVC 设值
    //KVC要设值，就要对象中有对应的key，KVC的内部是按照怎样的顺序来寻找key的呢，现在我们一起看看底层的机制：
    
    //当调用setValue：forKey：时 ，程序会先通过setter（set<Key>：）方法，对属性进行设置；
    //如果没有找到setKey：方法，KVC机制会检查+ (BOOL)accessInstanceVariablesDirectly方法有没有返回YES ,默认该方法是返回YES的，如果重写返回了NO,那么这一步会执行setValue forUndefinedKey：方法。若为YES，KVC机制会搜索该类中是否有名为key的成员变量，不管变量在类接口处定义没有，只要存在以key命名的变量，KVC都可以对该成员变量赋值。
    //如果该类既没有setKey方法，也没有_key成员变量，KVC机制会搜索_isKey的成员变量；如果_isKey成员变量也没有,KVC机制再会继续搜索<key>和is<Key>的成员变量给它们赋值,如果上面列出的方法或者成员变量都不存在,系统会执行该对象的setValue：forUndefinedKey：方法 抛出异常(既 如果没有找到Set<Key>方法的话，会按照_key，_iskey，key，iskey的顺序搜索成员并进行赋值操作)
    
    //例子 1 正常的 设值和取值
    /*
    KVCModel * model = [[KVCModel alloc] init];
    //通过KVC赋值name
    [model setValue:@"标题" forKey:@"title"];
    //通过KVC取值title
    NSLog(@"KVC 获取title值 --- %@",[model valueForKey:@"title"]);
    //上面就是通过- (void)setValue:(nullable id)value forKey:(NSString *)key;和- (nullable id)valueForKey:(NSString *)key;成功设置和取出obj对象的name值。
    */
    
    //例子 2  把accessInstanceVariablesDirectly为NO
    //在 KVCModel 重写下面方法
    /* + (BOOL)accessInstanceVariablesDirectly;
    - (id)valueForUndefinedKey:(NSString *)key ;
    - (void)setValue:(id)value forUndefinedKey:(NSString *)key;*/
    /*KVCModel * model = [[KVCModel alloc] init];
    //通过KVC赋值name
    [model setValue:@"标题2" forKey:@"title"];
    //通过KVC取值title
    NSLog(@"KVC 获取title值 --- %@",[model valueForKey:@"title"]);*/
    //运行发现 accessInstanceVariablesDirectly为NO的时候KVC 只会查询setter和getter这一层，下面寻找key的相关变量执行就会停止，直接报错。
    /*2018-11-15 15:39:44.936976+0800 KVCDemo[1921:1392533] 出现异常，key不存在title
    2018-11-15 15:39:44.937178+0800 KVCDemo[1921:1392533] 出现异常，key不存在title
    2018-11-15 15:39:44.937263+0800 KVCDemo[1921:1392533] KVC 获取title值 --- (null)*/
    
    
    //例子 3   修改 + (BOOL)accessInstanceVariablesDirectly为YES 继续查看
    // 修改 _title 为 _isTitle  注意_isTitle 中的is后面的首字母要大写
    /*KVCModel * model = [[KVCModel alloc] init];
    //通过KVC赋值name
    [model setValue:@"标题3" forKey:@"title"];
    //通过KVC取值title
    NSLog(@"KVC 获取title值 --- %@",[model valueForKey:@"title"]);*/
    //运行  2018-11-15 15:44:50.815772+0800 KVCDemo[1947:1424382] KVC 获取title值 --- 标题3
    //通过运行结果看到设置accessInstanceVariablesDirectly为YES,当没有_Key属性的时候，KVC会继续按照顺序查找是否有_isKey，并成功设值和取值了。
    
    //例子 4
    // 修改 属性 为 title
    /*KVCModel * model = [[KVCModel alloc] init];
    //通过KVC赋值name
    [model setValue:@"标题4" forKey:@"title"];
    //通过KVC取值title
    NSLog(@"KVC 获取title值 --- %@",[model valueForKey:@"title"]);*/
    //运行  2018-11-15 15:46:56.361557+0800 KVCDemo[1969:1438437] KVC 获取title值 --- 标题4
    //通过运行结果看到设置accessInstanceVariablesDirectly为YES，当没有_Key和_isKey属性的时候,KVC会继续按照顺序查找是否有Key，并成功设值和取值了。
    
    //例子 5
    // 修改 属性 为 isTitle 注意isTitle 中的is后面的首字母要大写
    /*KVCModel * model = [[KVCModel alloc] init];
     //通过KVC赋值name
     [model setValue:@"标题5" forKey:@"title"];
     //通过KVC取值title
     NSLog(@"KVC 获取title值 --- %@",[model valueForKey:@"title"]);*/
    //运行  2018-11-15 15:51:42.996499+0800 KVCDemo[2019:1469259] KVC 获取title值 --- 标题5
    //通过运行结果看到设置accessInstanceVariablesDirectly为YES，当没有_Key、_isKey和key属性的时候,KVC会继续按照顺序查找是否有isKey，并成功设值和取值了。
    
    
    //例子 6
    // 修改 去掉属性
    /*KVCModel * model = [[KVCModel alloc] init];
    //通过KVC赋值name
    [model setValue:@"标题6" forKey:@"title"];
    //通过KVC取值title
    NSLog(@"KVC 获取title值 --- %@",[model valueForKey:@"title"]);*/
    //运行 2018-11-15 15:55:52.128309+0800 KVCDemo[2054:1496609] 出现异常，key不存在title
    //2018-11-15 15:55:52.128556+0800 KVCDemo[2054:1496609] 出现异常，key不存在title
    //2018-11-15 15:55:52.129384+0800 KVCDemo[2054:1496609] KVC 获取title值 --- (null)
    //通过运行结果看到设置accessInstanceVariablesDirectly为YES，当没有_Key、_isKey、key、isKey属性的时候,系统将会执行该对象的setValue：forUndefinedKey：方法，默认是抛出异常。
    //以上就是 KVC 设值和取值的原来和底层的执行机制
    
//    二 、 KVC取值
    /*
     KVC 取值 调用valueForKey：时的执行机制
     1、首先会按照getKey，Key，isKey来进行getter方法查找，若存在就赋值；如果getter方法都没有找到，KVC机制就会查找countOfKey 、objectInKeyAtIndex 、KeyAtindex、getKey :range 这些方法,若上面的几个方法任一个被找到，那么就会返回一个NSKeyValueArray（含有所有的方法的代理集合），以上面的几个方法组合形式调用；如果上面的countOfKey 、objectInKeyAtIndex 、KeyAtindex、getKey :range 这些方法没有找到 ，会去查找 countOfKey、enumeratorOfKey、memberOfKey格式的方法，若找到这三个方法会返回一个可以相应NSSet所有方法的代理集合，会以countOfKey、enumeratorOfKey、memberOfKey组合形式调用；如果都没有找到，就去查找+ (BOOL)accessInstanceVariablesDirectly,如果返回YES，就和设值一样的执行机制。
     
     */
    
//    例子  1  含有getKey，Key，isKey 方法
    
    //注意，这里的key是指成员变量名，首字母大小写要符合KVC的命名规则 ,例如 isTitle 不然取不到值；
    
    /*KVCModel * model = [[KVCModel alloc] init];
    NSLog(@"获取KVC值 -- %@  --- %@  --- %@", [model valueForKey:@"title"], [model valueForKey:@"content"], [model valueForKey:@"name"]);*/
    //返回结果 获取KVC值 -- 返回title  --- 返回isContent  --- 返回getName
    //可以看出，和上面的执行机制是相同的

    //三、KVC使用keyPath 除了对当前对象的属性进行赋值外，还可以对其更“深层”的对象进行赋值。例如对当前对象的SubKVCModel属性的title属性进行赋值。KVC进行多级访问时，直接类似于属性调用一样用点语法进行访问即可。
//  常用方法
    /*
     - (nullable id)valueForKeyPath:(NSString *)keyPath;                  //通过KeyPath来取值
     - (void)setValue:(nullable id)value forKeyPath:(NSString *)keyPath;  //通过KeyPath来设值

     */
    //例子
   /* SubKVCModel * subModel = [[SubKVCModel alloc] init];
    KVCModel * model = [[KVCModel alloc] init];
    [model setValue:subModel forKey:@"subModel"];
    [model setValue:@"得到title" forKeyPath:@"subModel.title"];
    NSLog(@"keyPath获取到的值:%@",[model valueForKeyPath:@"subModel.title"]);*/
    //运行结果 ：2018-11-15 16:55:42.495799+0800 KVCDemo[2214:1756892] keyPath获取到的值:得到title
    
//    四、多值操作    KVC还有更强大的功能，可以根据给定的一组key，获取到一组value，并且以字典的形式返回，获取到字典后可以通过key从字典中获取到value。也可以通过KVC进行批量赋值。在对象调用setValuesForKeysWithDictionary:方法时，可以传入一个包含key、value的字典进去，KVC可以将所有数据按照属性名和字典的key进行匹配，并将value给User对象的属性赋值。 常用方法
    /*
     - (NSDictionary<nsstring *, id> *)dictionaryWithValuesForKeys:(NSArray<nsstring *> *)keys;</nsstring *></nsstring *, id>
     - (void)setValuesForKeysWithDictionary:(NSDictionary<nsstring *, id> *)keyedValues;</nsstring *, id>
     */
    
    // 例子  在项目中经常会遇到字典转模型的情况。通过KVC为我们提供的赋值API，可以对数据进行批量赋值。通过setValuesForKeysWithDictionary:方法对User进行赋值。
    /*NSDictionary * dict = @{@"name":@"name",@"content":@"content",@"subTitle":@"subTitle"};
    KVCModel * model = [[KVCModel alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    NSLog(@"model--> name: %@ content: %@  subTitle: %@",model.name,model.content,model.subTitle);*/
    //运行结果  2018-11-15 17:19:16.623203+0800 KVCDemo[2326:1879874] model--> name: name content: content  subTitle: subTitle
    //注意 转换时需要服务器数据和类定义匹配，字段数量和字段名都应该匹配。如果User比服务器数据多，则服务器没传的字段为空。如果服务端传递的数据User中没有定义，则会导致崩溃。 在KVC进行属性赋值时，内部会对基础数据类型做处理，不需要手动做NSNumber的转换。需要注意的是，NSArray和NSDictionary等集合对象，value都不能是nil，否则会导致Crash。
//    五、KVC处理异常  KVC处理nil异常
    //当通过KVC给某个非对象的属性赋值为nil时，此时KVC会调用属性所属对象的setNilValueForKey:方法，并抛出NSInvalidArgumentException的异常，并使应用程序Crash。 我们可以通过重写setNilValueForKey:方法
    /*
     - (void)setNilValueForKey:(NSString *)key {
         NSLog(@"不能将%@设成nil", key);
     }   */
    /*NilKVCModel * model = [[NilKVCModel alloc] init];
    //通过KVC设值test的age
    [model setValue:nil forKey:@"name"];
    //通过KVC取值age打印
    NSLog(@"名字是%@", [model valueForKey:@"name"]);*/
    //运行结果 2018-11-15 17:28:12.956062+0800 KVCDemo[2406:1952070] 名字是(null)

    //KVC处理UndefinedKey异常
    //当根据KVC搜索规则，没有搜索到对应的key或者keyPath，则会调用对应的异常方法。异常方法的默认实现，在异常发生时会抛出一个NSUndefinedKeyException的异常，并且应用程序Crash。  可以重写 下面两个方法
    /*
     - (nullable id)valueForUndefinedKey:(NSString *)key;
     - (void)setValue:(nullable id)value forUndefinedKey:(NSString *)key;
     */
   
    // 六、集合运算符
//    集合运算符主要分为三类：
//    集合操作符：处理集合包含的对象，并根据操作符的不同返回不同的类型，返回值以NSNumber为主。  简单集合运算符共有@avg， @count ， @max ， @min ，@sum5种
//    数组操作符：根据操作符的条件，将符合条件的对象包含在数组中返回。 @distinctUnionOfObjects @unionOfObjects
//    嵌套操作符：处理集合对象中嵌套其他集合对象的情况，返回结果也是一个集合对象。 @unionOfArrays     @distinctUnionOfArrays
    
    
    //简单集合运算符
    /*SubKVCModel * model = [[SubKVCModel alloc] init];
    model.age = 12;
    SubKVCModel * model1 = [[SubKVCModel alloc] init];
    model1.age = 13;
    SubKVCModel * model2 = [[SubKVCModel alloc] init];
    model2.age = 14;
    SubKVCModel * model3 = [[SubKVCModel alloc] init];
    model3.age = 15;
    SubKVCModel * model4 = [[SubKVCModel alloc] init];
    model4.age = 16;
    NSArray * arr = @[model,model1,model2,model3,model4];
    NSNumber* sum = [arr valueForKeyPath:@"@sum.age"];
    NSLog(@"sum:%f",sum.floatValue);
    NSNumber* avg = [arr valueForKeyPath:@"@avg.age"];
    NSLog(@"avg:%f",avg.floatValue);
    NSNumber* count = [arr valueForKeyPath:@"@count"];
    NSLog(@"count:%f",count.floatValue);
    NSNumber* min = [arr valueForKeyPath:@"@min.age"];
    NSLog(@"min:%f",min.floatValue);
    NSNumber* max = [arr valueForKeyPath:@"@max.age"];
    NSLog(@"max:%f",max.floatValue);*/
    //运行结果：
    /*2018-11-16 10:02:51.964400+0800 KVCDemo[3222:2547677] sum:70.000000
    2018-11-16 10:02:51.964704+0800 KVCDemo[3222:2547677] avg:14.000000
    2018-11-16 10:02:51.964848+0800 KVCDemo[3222:2547677] count:5.000000
    2018-11-16 10:02:51.965055+0800 KVCDemo[3222:2547677] min:12.000000
    2018-11-16 10:02:51.965163+0800 KVCDemo[3222:2547677] max:16.000000*/
    
    





    //注意：@count操作符比较特殊，它不需要写right keyPath，即使写了也会被忽略。
    //注意：@max和@min在进行判断时，都是通过调用compare:方法进行判断，所以可以通过重写该方法对判断过程进行控制。
    //尽管valueForKey：会自动将值类型封装成对象，但是setValue：forKey：却不行。你必须手动将值类型转换成NSNumber或者NSValue类型，才能传递过去。 因为传递进去和取出来的都是id类型，所以需要开发者自己担保类型的正确性，运行时Objective-C在发送消息的会检查类型，如果错误会直接抛出异常。
    
    //数组操作符
    /*
     @max用来查找集合中right keyPath指定的属性的最大值。
     @sum用来计算集合中right keyPath指定的属性的总和。
     @min用来查找集合中right keyPath指定的属性的最小值。
     @count用来计算集合的总数。
     @avg用来计算集合中right keyPath指定的属性的平均值。
     SubKVCModel * model = [[SubKVCModel alloc] init];
    model.age = 12;
    model.name = @"小明";
    SubKVCModel * model1 = [[SubKVCModel alloc] init];
    model1.age = 13;
    model1.name = @"小方";
    SubKVCModel * model2 = [[SubKVCModel alloc] init];
    model2.age = 14;
    model2.name = @"小涛";
    
    SubKVCModel * model3 = [[SubKVCModel alloc] init];
    model3.age = 15;
    model3.name = @"小童";

    SubKVCModel * model4 = [[SubKVCModel alloc] init];
    model4.age = 16;
    model4.name = @"小超";
    NSArray * arr = @[model,model1,model2,model3,model4];

    NSArray* arrDistinct = [arr valueForKeyPath:@"@distinctUnionOfObjects.age"];
    for (NSNumber *age in arrDistinct) {
        NSLog(@"distinctUnionOfObjects -%f",age.floatValue);
    }
    //@distinctUnionOfObjects将集合对象中，所有payee对象放在一个数组中，并将数组进行去重后返回。
    NSArray* arrUnion = [arr valueForKeyPath:@"@unionOfObjects.age"];
    for (NSNumber * age in arrUnion) {
        NSLog(@"unionOfObjects - %f",age.floatValue);
    }
     @unionOfObjects将集合对象中，所有payee对象放在一个数组中并返回。
     

     */
//    运行结果:
    /*
     2018-11-16 10:08:54.253126+0800 KVCDemo[3266:2595522] distinctUnionOfObjects -14.000000
     2018-11-16 10:08:54.253241+0800 KVCDemo[3266:2595522] distinctUnionOfObjects -13.000000
     2018-11-16 10:08:54.253331+0800 KVCDemo[3266:2595522] distinctUnionOfObjects -16.000000
     2018-11-16 10:08:54.253401+0800 KVCDemo[3266:2595522] distinctUnionOfObjects -12.000000
     2018-11-16 10:08:54.253596+0800 KVCDemo[3266:2595522] distinctUnionOfObjects -15.000000
     2018-11-16 10:08:54.253734+0800 KVCDemo[3266:2595522] unionOfObjects - 12.000000
     2018-11-16 10:08:54.253820+0800 KVCDemo[3266:2595522] unionOfObjects - 13.000000
     2018-11-16 10:08:54.253954+0800 KVCDemo[3266:2595522] unionOfObjects - 14.000000
     2018-11-16 10:08:54.254022+0800 KVCDemo[3266:2595522] unionOfObjects - 15.000000
     2018-11-16 10:08:54.254127+0800 KVCDemo[3266:2595522] unionOfObjects - 16.000000
     */
   //嵌套操作符   @unionOfArrays     @distinctUnionOfArrays   @distinctUnionOfSets
    /*SubKVCModel * model = [[SubKVCModel alloc] init];
    model.age = 12;
    model.name = @"小明";
    SubKVCModel * model1 = [[SubKVCModel alloc] init];
    model1.age = 13;
    model1.name = @"小方";
    SubKVCModel * model2 = [[SubKVCModel alloc] init];
    model2.age = 14;
    model2.name = @"小涛";
    SubKVCModel * model3 = [[SubKVCModel alloc] init];
    model3.age = 15;
    model3.name = @"小童";
    SubKVCModel * model4 = [[SubKVCModel alloc] init];
    model4.age = 16;
    model4.name = @"小超";
    NSArray * arr = @[model,model1,model2,model3,model4];
    NSArray * arr1 = @[model,model1,model2,model3,model4];
    NSArray * array = @[arr,arr1];
    NSArray * unionOfArray = [array valueForKeyPath:@"@unionOfArrays.age"];
    NSLog(@"%@",unionOfArray);
    NSArray * distinctUnionOfArray = [array valueForKeyPath:@"@distinctUnionOfArrays.age"];
    NSLog(@"%@",distinctUnionOfArray);*/
    //运行结果：
/*
 2018-11-16 10:38:10.458312+0800 KVCDemo[3483:2785420] (
 12,
 13,
 14,
 15,
 16,
 12,
 13,
 14,
 15,
 16
 )
 2018-11-16 10:38:10.458601+0800 KVCDemo[3483:2785420] (
 13,
 14,
 15,
 16,
 12
 )
 */

//    @unionOfArrays是用来操作集合内部的集合对象，将所有right keyPath对应的对象放在一个数组中返回。
//    @distinctUnionOfArrays是用来操作集合内部的集合对象，将所有right keyPath对应的对象放在一个数组中，并进行排重。
    
     /*
     七、属性验证
     
     在调用KVC时可以先进行验证，验证通过下面两个方法进行，支持key和keyPath两种方式。验证方法默认实现返回YES，可以通过重写对应的方法修改验证逻辑。
     验证方法需要我们手动调用，并不会在进行KVC的过程中自动调用。
     - (BOOL)validateValue:(inout id _Nullable * _Nonnull)ioValue forKey:(NSString *)inKey error:(out NSError **)outError;
     - (BOOL)validateValue:(inout id _Nullable * _Nonnull)ioValue forKeyPath:(NSString *)inKeyPath error:(out NSError **)outError;
      */
    
    /*
    八、总结： KVC使用
    
     动态地取值和设值
     利用KVC动态的取值和设值。
     用KVC来访问和修改私有变量
     对于类里的私有属性，Objective-C是无法直接访问的，但是KVC是可以的。  KVC本质上是操作方法列表以及在内存中查找实例变量。我们可以利用这个特性访问类的私有变量，例如下面在.m中定义的私有成员变量和属性，都可以通过KVC的方式访问。
     
     这个操作对readonly的属性，@protected的成员变量，都可以正常访问。如果不想让外界访问类的成员变量，则可以将accessInstanceVariablesDirectly属性赋值为NO。
     Model和字典转换
     这是KVC强大作用的又一次体现，KVC和Objc的runtime组合可以很容易的实现Model和字典的转换。
     
     修改一些控件的内部属性
     这也是iOS开发中必不可少的小技巧。众所周知很多UI控件都由很多内部UI控件组合而成的，但是Apple度没有提供这访问这些控件的API，这样我们就无法正常地访问和修改这些控件的样式。
     而KVC在大多数情况可下可以解决这个问题。最常用的就是个性化UITextField中的placeHolderText了。
     
     操作集合
     Apple对KVC的valueForKey:方法作了一些特殊的实现，比如说NSArray和NSSet这样的容器类就实现了这些方法。所以可以用KVC很方便地操作集合。
     
     用KVC实现高阶消息传递
     当对容器类使用KVC时，valueForKey:将会被传递给容器中的每一个对象，而不是容器本身进行操作。结果会被添加进返回的容器中，这样，开发者可以很方便的操作集合来返回另一个集合。
     
   
     注意：KVC是支持基础数据类型和结构体的，可以在setter和getter的时候，通过NSValue和NSNumber来转换为OC对象。Swift中不存在这样的需求，因为Swift中所有变量都是对象。
     需要注意的是，无论什么时候都不应该给setter中传入nil，会导致Crash并引起NSInvalidArgumentException异常。
    
     安全性检查
     KVC存在一个问题在于，因为传入的key或keyPath是一个字符串，这样很容易写错或者属性自身修改后字符串忘记修改，这样会导致Crash。
     可以利用iOS的反射机制来规避这个问题，通过@selector()获取到方法的SEL，然后通过NSStringFromSelector()将SEL反射为字符串。这样在@selector()中传入方法名的过程中，编译器会有合法性检查，如果方法不存在或未实现会报黄色警告。
     [self valueForKey:NSStringFromSelector(@selector(object))];
     */
    //键值赋值，使用最多的即使字典转模型。利用runtime获取对象的所有成员变量， 在根据kvc键值赋值，进行字典转模型
    //setValue: forKey: 只查找本类里面的属性
    //setValue: forKeyPath：会查找本类里面属性，没有会继续查找父类里面属性。
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end


#import <Foundation/Foundation.h>


@implementation KVCModel

- (NSString *)title {
    return @"返回title";
}

- (NSString *)isContent {
    return @"返回isContent";
}

- (NSString *)getName {
    return @"返回getName";
}

//+ (BOOL)accessInstanceVariablesDirectly {
//    return NO;
//}

+ (BOOL)accessInstanceVariablesDirectly {
    return YES;
}


- (id)valueForUndefinedKey:(NSString *)key {
    NSLog(@"出现异常，key不存在%@",key);
    return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"出现异常，key不存在%@", key);
}


@end

#import <Foundation/Foundation.h>
@implementation SubKVCModel

@end

#import <Foundation/Foundation.h>
@implementation NilKVCModel
- (void)setNilValueForKey:(NSString *)key {
    NSLog(@"不能将%@设成nil", key);
}
@end


