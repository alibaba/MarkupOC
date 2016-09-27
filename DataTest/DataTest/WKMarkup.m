//
//  alipayMarkup.m
//  DataTest
//
//  Created by hesanyuan on 15/1/9.
//  Copyright (c) 2015年 hesanyuan. All rights reserved.
//

#import "WKMarkup.h"
#import <Foundation/NSRegularExpression.h>


@interface wkmarkupIter : NSObject

@property(nonatomic) NSInteger idx;
@property(nonatomic) NSInteger size;
@property(nonatomic) NSInteger length;
@property(nonatomic,strong) NSString* sign;
@property(nonatomic,strong) NSString* toString;

@end

@implementation wkmarkupIter


@end

@interface wkmarkupOption : NSObject

@property(nonatomic,strong) NSString *pipes;
@property(nonatomic,strong) NSString *includes;
@property(nonatomic,strong) NSString *globals;
@property(nonatomic,strong) NSString *delimiter;
@property(nonatomic,strong) NSString *compact;
@property(nonatomic,strong) NSArray  *split;
@property(nonatomic,strong) wkmarkupIter *iter;

@end

@implementation wkmarkupOption

@end


@interface WKMarkup()
{
    NSString *delimiter;
    NSDictionary *dic ;
}

@end

@implementation WKMarkup

//// This object represents an iteration. It has an index and length.
-(id) iter:(NSUInteger)idx with:(NSUInteger)size
{
    wkmarkupIter * iter = [[wkmarkupIter alloc] init];
    iter.idx = idx;
    iter.size = size;
    iter.length = size;
    iter.sign = @"#";
    iter.toString = [NSString stringWithFormat:@"%ld",(long)iter.idx];
    
    return iter;
    
    // Print the index if "#" or the count if "##".
//    this.toString = function () {
//        return this.idx + this.sign.length - 1;
//    };
}


// Process the contents of an IF or IF/ELSE block.
-(id)testIffunction: (id)flags withChild:(id)child withContext:(id)context withOption:(id)options
{
    // Process the child string, then split it into the IF and ELSE parts.
    id str = [self markupWithTemp:child withContent:context withOption:options];
    NSArray* array = [str  componentsSeparatedByString:@"{{else}}"];
    //Mark.up(child, context, options).split(/\{\{\s*else\s*\}\}/);
    BOOL tempflags =NO;
    BOOL judgeFlags =NO;
    
    if(!flags)
    {
        tempflags = YES;
    }
    else if ([flags isKindOfClass:[NSNumber class]]) {
        tempflags = YES;
        if ([flags boolValue]) {
            judgeFlags = YES;
        }
        else
        {
            judgeFlags = NO;
        }

    }
    else if([flags isKindOfClass:[NSString class]])
    {
        tempflags = YES;
        if ([flags isEqualToString:@"false"]||[flags isEqualToString:@"0"]) {
            judgeFlags = NO;
        }
        else
        {
            judgeFlags = YES;
        }
    }
    
    if (tempflags) {
        if (judgeFlags) {
            if (array.count>0) {
                return array[0];
            }
            else
            {
                return @"";
            }

        }
        else
        {
            if (array.count>1) {
                return array[1];
            }
            else
            {
                return @"";
            }
        }
    }
    
    return @"";
    // Return the IF or ELSE part. If no ELSE, return an empty string.

};

-(id)init
{
    if (self = [super init]) {
    }
    
    return self;
}

-(id)eval:(id)context withfilters:(id)filters withchild:(id)child
{
    ////NSLog(@"eval");
    id result = [self pipefunction:context withexp:filters];//this._pipe(context, filters),//todo做类型判断

    id ctx = result;
    NSUInteger i = -1,
    j;
    id opts;
    
    if ([result isKindOfClass:[NSArray class]]) {
        result = [[NSMutableString alloc] init];
        j = [ctx count];
        
        while (++i < j) {
            opts = [[wkmarkupOption alloc] init];
            ((wkmarkupOption*)opts).iter = [self iter:i with:j];
            if (child!=nil) {
                id str = [self markupWithTemp:child withContent:ctx[i] withOption:opts]; //Mark.up(child, ctx[i], nil);
                [result appendString:str];
            }
            else
            {
                id str = ctx[i];
                if ([str isKindOfClass:[NSString class]]) {
                    [result appendString:str];
                }
                else if([str isKindOfClass:[NSNumber class]])
                {
                    [result appendString:[str stringValue]];
                }
            }
        }
    }
    else if ([result isKindOfClass:[NSDictionary class]]) {
        result = [self markupWithTemp:child withContent:ctx withOption:nil]; //Mark.up(child, ctx);
    }
    
    return result;
}


/**
 *  匹配循环
 *
 *  @param template 模版
 *  @param tkn      token
 *
 *  @return 返回匹配的数组
 */
-(NSArray*)markUpMatch:(NSString*)template withtoken:(NSString*)tkn
{
    NSArray * arr = [self Findcycle:template start:tkn];
    return arr;
}

-(NSArray*)Findcycle:(NSString*)template start:(NSString*)tkn
{
    const char* source = [template UTF8String];
    const char *index = source;//做了指针强转。
    
    NSMutableArray *array = nil;
    const char* startflags = nil;
    
    while (*index!='\0') {
        
        switch (*index) {
            case '{':
            {
                if (*(index++)=='{') {
                    startflags = index;
                    
                    index = index+sizeof(char);
                    
                    if (*(index)=='/') {
                        index++;
                    }
                    else
                    {
                        while (*index!='\0') {
                            if (*index==' ') {
                                index++;
                                continue;
                            }
                            else
                            {
                                break;
                            }
                        }
                    }
                    const char* des = [tkn UTF8String];
                    BOOL flags = NO;
                    while (*index) {
                        if (*des!='\0') {
                            if (*index==*des) {
                                index++;
                                des++;
                                continue;
                            }
                            else
                            {
                                flags = YES;
                                break;
                            }
                        }
                        else
                        {
                            while (*index!='\0') {
                                if (*index==' ') {
                                    index++;
                                    continue;
                                }
                                else if(*index=='}')
                                {
                                    index++;
                                    if (*index=='}') {
                                        NSString *element = [[NSString alloc] initWithBytes:startflags-1 length:index-startflags+sizeof(char)+1 encoding:NSUTF8StringEncoding];
                                        if (array==nil) {
                                            array= [[NSMutableArray alloc] init];
                                        }
                                        [array addObject:element];
                                        startflags = nil;
                                        flags = YES;
                                        break;
                                        //已经找到。
                                    }
                                    else
                                    {
                                        startflags = nil;
                                        flags = YES;
                                        break;
                                        //不是合法的内容.
                                    }
                                }
                                else
                                {
                                    index++;
                                }
                            }
                        }
                        if (flags) {
                            break;
                        }
                    }

                    startflags = nil;
                }
            }
                break;
            default:
                
                break;
        }
        startflags = nil;
        index++;
    }
    
    return array;
}

-(NSArray*)markUpMatch:(NSString*)template start:(NSString*) startStr end:(NSString*)endStr
{

    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    NSRange beg = {0, template.length};
    while (YES) {
        beg = [template rangeOfString:startStr options:0 range:beg];
        if (beg.length <= 0) {
            break;
        }
        
        beg.length = template.length-beg.location;
        NSRange dst = [template rangeOfString:endStr options:0 range:beg];
        if (dst.length <= 0) {
            break;
        }
        dst.location = dst.location+dst.length;////add by铁头
        beg.length = dst.location - beg.location;
        NSString *key = [template substringWithRange:beg];
        
        [array addObject:key];
        beg = dst;
        beg.length = template.length - beg.location;
    }

    if (array) {
        return array;
    }
    else
    {
        return nil;
    }
    
}

-(NSString*)fetchfirstRun:(NSString*)prop withStr:(NSString*)option withRang:(NSRange)range
{
    NSRange beg = range;//{0, [prop length]};
    
    NSRange tempRang = {beg.location+beg.length,[prop length]-beg.location-beg.length};
        
    NSRange dst = [prop rangeOfString:option options:0 range:tempRang];
    if (dst.length > 0) {
            dst.location = dst.location;//+dst.length;////add by铁头
            beg.location = beg.location + beg.length;
            beg.length = dst.location - beg.location;
            NSString *key = [prop substringWithRange:beg];
            return key;
    }

    return nil;
}

-(NSString*) markupWithTemp:(id)tpContent withContent:(id)context withOption:(id)options
{
    if (!context) {
        return tpContent;
    }
    // Match all tags like "{{...}}".
    //    instancetype * re = /\{\{(.+?)\}\}/g,
    // All tags in the template.
    
    NSArray * tags =  [self markUpMatch:tpContent start:@"{{" end:@"}}"];//template.match(re) || [],
    if (tags.count<1) {
        return tpContent;
    }
    delimiter = @">";
    // The tag being evaluated, e.g. "{{hamster|dance}}".
    NSString* tag =nil;
    // The expression to evaluate inside the tag, e.g. "hamster|dance".
    id prop,
    // The token itself, e.g. "hamster".
    token,
    // An array of pipe expressions, e.g. ["more>1", "less>2"].
    filters ,
    // Does the tag close itself? e.g. "{{stuff/}}".
    // Is the tag an "if" statement?
    // The contents of a block tag, e.g. "{{aa}}bb{{/aa}}" -> "bb".
    child,
    // The resulting string.
    result,
    // A placeholder variable.
    ctx;
    BOOL testy=NO;
    // Iterators.
    NSInteger i = 0,
    j = 0;
    BOOL  selfy=NO;
    
    while ((tag = tags[i++])) {
        result = nil;
        child = nil;
//        selfy = [tag rangeOfString:@"/}}"].length > 0;
        NSRange selfyLength = NSMakeRange(2, tag.length-4);//没有考虑闭合标签。
        prop = [tag substringWithRange:selfyLength];//(2, tag.length - (selfy ? 5 : 4));
        
        NSRange beg = {0, [prop length]};
        beg = [prop rangeOfString:@"`"];//[tag rangeOfString:@".businessHour"].length>0
        if (beg.length>0) {
            NSString* mulString = [self fetchfirstRun:prop withStr:@"`" withRang:beg];
            if (mulString) {
                NSString* reString = [NSString stringWithFormat:@"{{%@}}",mulString];
                reString = (NSString*)[self markupWithTemp:reString withContent:context withOption:options];
                prop = [prop stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"`%@`",mulString] withString:reString];
            }
        }
        
        NSCharacterSet *whitespace =[NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSRange rangeIf = [[prop stringByTrimmingCharactersInSet:whitespace] rangeOfString:@"if "];
        testy = rangeIf.location==0;
        

        if (testy) {
            prop = [prop substringFromIndex:rangeIf.length];
        }
        NSArray *array =  [prop componentsSeparatedByString:@"|"];//[[NSMutableArray alloc] initWithArray:[prop componentsSeparatedByString:@"|"]] ;
        prop = [array objectAtIndex:0];
        if ([array count]>1) {
            filters = [array subarrayWithRange:NSMakeRange(1, [array count]-1)];//[array objectAtIndex:1];
        }
        else
        {
            filters = nil;
        }
        
        token = testy?@"if":prop;//testy ? @"if" : [(NSString*)prop componentsSeparatedByString:@"|"][0];  //.split("|")[0];
        if ([context isKindOfClass:[NSDictionary class]]) {
            ctx = context[prop];
            if ([ctx isKindOfClass:[NSNumber class]]) {
                ctx = [ctx stringValue];
            }
            else if ([ctx isKindOfClass:[NSNull class]]) {
                ctx = nil;
            }
        }
        
        // Does the tag have a corresponding closing tag? If so, find it and move the cursor.
        if (!selfy && ([tpContent rangeOfString:[NSString stringWithFormat:@"{{/%@",token]].length>0))
        {
            result = [self bridge:tpContent withtkn:token];
            if (result&&[result isKindOfClass:[NSArray class]]) {
                tag = result[0];
                child = result[1];
                i += [self markUpMatch:tag start:@"{{" end:@"}}"].count-1;
            }
        }
        BOOL temptagValue = [tag isEqualToString:@"{{else}}"];
        if (temptagValue) {
            if (i<[tags count]) {
                continue;
            }
            else
            {
                break;
            }
        }
        
        // Evaluating a loop counter ("#" or "##").
        if ([prop rangeOfString:@"#"].length > 0) {
        //# will be support in the future.
        }
        
        // Evaluating the current context.
        else if ([prop isEqualToString:@"."]) {
            result = [self pipefunction:context withexp:filters];
        }
        
        // Evaluating a variable with dot notation, e.g. "a.b.c"
        else if ([prop rangeOfString:@"."].length > 0) {
            prop = [prop componentsSeparatedByString:@"."];
            if (ctx) {
                j = 1;
            }
            else {
                j = 0;
                ctx = context;
            }
            
            // Get the actual context
            while (ctx && j < [prop count]) {//todo~~
                if ([ctx isKindOfClass:[NSDictionary class]]) {
                    ctx = ctx[prop[j++]];
                }
                else if([ctx isKindOfClass:[NSArray class]])
                {
                    NSString *keyProp = prop[j++];
                    NSInteger inValue = [keyProp integerValue];
                    if ((inValue< [ctx count])&&(inValue>=0)) {
                        ctx = ctx[inValue];
                    }
                    else
                    {
                        ctx = @"";
                    }
                }
                else
                {
                    j++;
                }
            }
            //需要考虑ctx不存在的情况。
            result = [self eval:ctx withfilters:filters withchild:child]; //this._eval(ctx, filters, child);
        }
        else if (testy)
        {
            result = [self pipefunction:ctx withexp:filters];
        }
        // Evaluating an array, which might be a block expression.
        else if ([ctx isKindOfClass:[NSArray class]]) {
            result = [self eval:ctx withfilters:filters withchild:child];
        }
        
        // Evaluating a block expression.
        else if ([child length]>0) {
            result = ctx ? [self markupWithTemp:child withContent:ctx withOption:nil]:nil; //Mark.up(child, ctx) : nil;
        }
        
        // Evaluating anything else.
        else if ([context isKindOfClass:[NSDictionary class]]) {
            if(context[prop])
            {
                result = [self pipefunction:ctx withexp:filters]; //this._pipe(ctx, filters);
            }
            else
            {
                result = [self pipefunction:nil withexp:filters];
            }
        }
        
        // Evaluating special case: if the resulting context is actually an Array
        if ([result isKindOfClass:[NSArray class]] ) {
            result = [self eval:result withfilters:filters withchild:child];//this._eval(result, filters, child);
        }
        
        if (testy) {
            result = [self testIffunction:result withChild:child withContext:context withOption:options];
        }
        
        // Replace the tag, e.g. "{{name}}", with the result, e.g. "Adam".
        if([tpContent isKindOfClass:[NSString class]])
        {
            if (!result) {
                result = @"";
            }
            else if([result isKindOfClass:[NSNumber class]])
            {
                result = [result stringValue];
            }
            else if([result isKindOfClass:[NSNull class]])
            {
                result = @"";
            }
            else
            {
                //u can do something in this place.
            }

            if([result isKindOfClass:[NSString class]])
            {
                tpContent = [tpContent stringByReplacingOccurrencesOfString:tag withString:result];
            }
            else if([result isKindOfClass:[NSDictionary class]]||[result isKindOfClass:[NSArray class]])
            {
                NSError *error = nil;
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:result options:NSJSONWritingPrettyPrinted error:&error];
                result =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                
                if (!result) {
                    result = @"";
                }
                tpContent = [tpContent stringByReplacingOccurrencesOfString:tag withString:result];
            }
            else
            {
                NSAssert(YES, @"内容出错");
            }
            
        }
        else
        {
            NSAssert(TRUE, @"类型不准确");
        }
        
        if (i>=tags.count) {
            break;
        }
    }
    return tpContent;
//    return this.compact ? template.replace(/>\s+</g, "><") : template;
    
}

/**
 *  外部调用的pipefunction
 *
 *  @param val         这是第一个参数
 *  @param expressions 这个是参数列表，
 */
-(id) pipefunction:(id)val withexp:(id)expressions
{
    
    id expression, parts, fn, result;
    
    // If we have expressions, pull out the first one, e.g. "add>10".
    if ((expression = [self shift:&expressions])) {
        
        // Split the expression into its component parts, e.g. ["add", "10"].
        //第一个个元素就是函数名，后面的才是参数。
        parts = [expression componentsSeparatedByString:delimiter]; //expression.split(this.delimiter);
        
        // Pull out the function name, e.g. "add".
        fn = [self shift:&parts];
        //parts.shift().trim();
        
        @try {
            // Run the function, e.g. add(123, 10) ...
            result = [self pipeExc:fn withfiltersRuler:parts withfirstParam:val];
            // ... then pipe again with remaining expressions.
            val = [self pipefunction:result withexp:expressions]; //this._pipe(result, expressions);
        }
        @catch (NSException* e) {
            
        }
        
    }
    // Return the piped value.
    if ([val isKindOfClass:[wkmarkupIter class]]) {
        val = [val toString];
    }
    return val;
}


-(id)shift:(id*)array
{
    //NSLog(@"shift");
    if (*array) {
        if ([*array count]>0) {
            
            id reValue = (*array)[0];
            if ([*array count]>1) {
                *array = [*array subarrayWithRange:NSMakeRange(1, [*array count]-1)];
            }
            else
            {
                *array = nil;
            }
            return reValue;
        }
        else
        {
            return nil;
        }
    }
    else
    {
        return nil;
    }
}
/**
 *  pip真实执行的函数
 *
 *  @param val         函数名
 *  @param expressions 表达式
 *
 *  @return 返回值。
 */
-(id) pipeExc:(id)fnName withfiltersRuler:(id)expressions withfirstParam:(id)param
{
    SEL sel = NSSelectorFromString([NSString stringWithFormat:@"%@:withSecond:", fnName]);
    if ([self respondsToSelector:sel]) {
        return [self performSelector:sel withObject:param withObject:expressions];
    }
    return @"";
}


-(id) bridge:(id)tpl withtkn:(id)tkn
{
    NSArray* tags= [self markUpMatch:tpl withtoken:tkn];
    
    if ([tags count]<1) {
        return nil;
    }
    
    NSInteger t=0,
    i=0,
    a = 0,
    b = 0,
    c = -1,
    d = 0;
    
    for (i = 0; i < [tags count]; i++) {
        t = i;
        ////NSLog(@"%lu",(unsigned long)[tpl length]);
        NSRange rangeValue = NSMakeRange(c+1, [tpl length]-(c+1)) ;
        c = [tpl rangeOfString:tags[t] options:0 range:rangeValue].location;
        
        if ([tags[t] rangeOfString:@"{{/"].length>0){
            b++;
        }
        else {
            a++;
        }
        
        if (a == b) {
            break;
        }
    }
    
    a = [tpl rangeOfString:tags[0]].location;
    b = a + [tags[0] length];
    d = c + [tags[t] length];
    
    //NSLog(@"bridge_end");
    // Return the block, e.g. "{{foo}}bar{{/foo}}" and its child, e.g. "bar".
    return [[NSArray alloc] initWithObjects:[tpl substringWithRange:NSMakeRange(a, d-a)],[tpl substringWithRange:NSMakeRange(b, c-b)], nil];
}

/////////////////
/////////////////
//下面的代码是管道函数
/////////////////



-(id)empty:(id)firstobj withSecond:(id)secondObj
{
    if (firstobj) {
        if ([firstobj isKindOfClass:[NSString class]]) {
            NSString *cleanString = [firstobj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if(cleanString.length>0)
            {
                return @"false";
            }
            else
            {
                return @"true";
            }
        }
        else if([firstobj isKindOfClass:[NSArray class]])
        {
            if ([firstobj count]>0) {
                return @"false";
            }
        }
        else if([firstobj isKindOfClass:[NSNull class]])
        {
            return  @"true";
        }
        else
        {
            return @"false";
        }
    }
    
    return @"true";
}

-(id)notempty:(id)firstobj withSecond:(id)secondObj
{
    if (firstobj) {
        if ([firstobj isKindOfClass:[NSString class]]) {
            const char* source = [firstobj UTF8String];
            BOOL flags = NO;
            while (*source!='\0') {
                if (*source!=' ') {
                    flags = YES;
                    break;
                }
                source++;
            }
            
            if(flags)
            {
                return @"true";
            }
            else
            {
                return @"false";
            }
        }
        else if([firstobj isKindOfClass:[NSArray class]])
        {
            if ([firstobj count]>0) {
                return @"false";
            }
            else
            {
                return @"true";
            }
        }
        else
        {
            return @"ture";
        }
    }
    return @"false";
}

-(id)blank:(id)firstobj withSecond:(id)secondObj
{
    if ([firstobj isKindOfClass:[NSString class]]) {
        if ([firstobj length]>0) {
            return firstobj;
        }
        else
        {
            if ([secondObj isKindOfClass:[NSArray class]]) {
                if ([secondObj count]>0) {
                    return secondObj[0];
                }
            }
        }
    }
    else if((!firstobj)||[firstobj isKindOfClass:[NSNull class]])
    {
        return @"true";
    }
    
    return @"false";
}

-(id)size:(id)sizeObj
{
    if (sizeObj) {
        if ([sizeObj isKindOfClass:[NSArray class]]) {
            return [NSString stringWithFormat:@"%ld",(unsigned long)[sizeObj length]];//[[NSNumber alloc] initWithInteger:[sizeObj length]];
        }
        else
        {
            return sizeObj;
        }
    }
    else
    {
        return @"0";
    }
    
}

-(id)equals:(id)firstobj withSecond:(id)secondObj
{
    if ([secondObj count]>0) {
        if ([firstobj isKindOfClass:[NSString class]]) {
            if ([firstobj isEqualToString:secondObj[0]]) {
                return @"true";
            }
        }
        else if([firstobj isKindOfClass:[NSNumber class]])
        {
            NSString *str = [firstobj stringValue];
            if ([str isEqualToString:secondObj[0]]) {
                return @"true";
            }
        }
        
    }
    return @"false";

}

-(id)notequals:(id)firstobj withSecond:(id)secondObj
{
    if((!secondObj)&&(!firstobj))
    {
       return @"true";
    }
    else
    {
        if ([secondObj count]>0) {
            if ([firstobj isKindOfClass:[NSString class]]) {
                if ([firstobj isEqualToString:secondObj[0]]) {
                    return @"false";
                }
            }
            else if([firstobj isKindOfClass:[NSNumber class]])
            {
                NSString *str = [firstobj stringValue];
                if ([str isEqualToString:secondObj[0]]) {
                    return @"false";
                }
            }
        }
        
    }
    return @"true";
}


-(id)upcase:(id)firstobj withSecond:(id)secondObj
{
    if ([firstobj isKindOfClass:[NSString class]]) {
        return [firstobj uppercaseString];
    }
    else
    {
        return firstobj;
    }

}

-(id)downcase:(id)firstobj withSecond:(id)secondObj
{
    if ([firstobj isKindOfClass:[NSString class]]) {
        return [firstobj lowercaseString];
    }
    else
    {
        return firstobj;
    }
}

-(id)capcase:(id)firstobj withSecond:(id)secondObj
{
    if ([firstobj isKindOfClass:[NSString class]]) {
        return [firstobj capitalizedString];
    }
    else
    {
        return firstobj;
    }
}

-(id)chop:(id)firstobj withSecond:(id)secondObj
{
    if ([secondObj isKindOfClass:[NSArray class]]) {
        if([secondObj count]>0)
        {
            NSString* element = secondObj[0];
            NSInteger length = [element integerValue];
            if ([firstobj isKindOfClass:[NSString class]]) {
                if ([firstobj length]>length) {
                    return [NSString stringWithFormat:@"%@...",[firstobj substringToIndex:length]];
                }
                else
                {
                    return firstobj;
                }
            }
            else
            {
                return firstobj;
            }
        }
        else
        {
            return @"";
        }
    }
    else
    {
        return firstobj;
    }
    
}


-(id)trim:(id)firstobj withSecond:(id)secondObj
{
    if([firstobj isKindOfClass:[NSString class]])
    {
        NSString *cleanString = [firstobj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        return cleanString;
    }
    else
    {
        return firstobj;
    }

}


-(id)round:(id)firstobj withSecond:(id)secondObj
{
    if ([firstobj isKindOfClass:[NSString class]]||[firstobj isKindOfClass:[NSNumber class]]) {
        float value = [firstobj floatValue];
        NSInteger result= value+0.5;
        
        return [NSString stringWithFormat:@"%ld",(long)result];
    }
    else
    {
        return firstobj;
    }
}


-(id)size:(id)firstobj withSecond:(id)secondObj
{
    NSInteger length = 0;
    if ([firstobj isKindOfClass:[NSString class]]) {
       length = [firstobj length];
    }
    else if([firstobj isKindOfClass:[NSArray class]]||[firstobj isKindOfClass:[NSDictionary class]])
    {
        length = [firstobj count];
    }
    return [NSString stringWithFormat:@"%ld",(long)length];
}

-(id)length:(id)firstobj withSecond:(id)secondObj
{
    NSInteger length = 0;
    if ([firstobj isKindOfClass:[NSString class]]) {
        length = [firstobj length];
    }
    return [NSString stringWithFormat:@"%ld",(long)length];

}

-(id)reverse:(id)firstobj withSecond:(id)secondObj
{
    if ([firstobj isKindOfClass:[NSArray class]]) {
        NSArray *arr = (NSArray*)firstobj;
        return [[arr reverseObjectEnumerator]allObjects];
    }
    else
    {
        return firstobj;
    }
}

-(id)join:(id)firstobj withSecond:(id)secondObj
{
    if ([firstobj isKindOfClass:[NSArray class]]&&[secondObj isKindOfClass:[NSArray class]]) {
        return [firstobj arrayByAddingObjectsFromArray:secondObj];
    }
    else
    {
        return firstobj;
    }
}

-(id)more:(id)firstobj withSecond:(id)secondObj
{
    NSString *tempValue = @"more param error";
    if (([firstobj isKindOfClass:[NSString class]]||([firstobj isKindOfClass:[NSNumber class]]))&&secondObj) {
        if ([secondObj count]>0) {
            NSString* element = secondObj[0];
            if ([firstobj floatValue]-[element floatValue]>0.00001) {
                return @"true";
            }
            else
            {
                return @"false";
            }
        }
    }
    
    return tempValue;
}

-(id)and:(id)firstobj withSecond:(id)secondObj
{
    if (firstobj) {
        BOOL first = NO;
        
        if ([firstobj isKindOfClass:[NSString class]]) {
            if ([firstobj isEqualToString:@"true"]||[firstobj isEqualToString:@"1"]) {
                first = YES;
            }
        }
        else if([firstobj isKindOfClass:[NSNumber class]])
        {
            first = [firstobj boolValue];
        }

        if (secondObj) {
            for (int i=0; i<[secondObj count]; i++) {
                if ([secondObj[i] isKindOfClass:[NSString class]]) {
                    if ([secondObj[i] isEqualToString:@"true"]||[secondObj[i] isEqualToString:@"1"]) {
                        first = YES|first;
                    }
                    else
                    {
                        first = first|NO;
                    }
                }
                else if (!secondObj[i]) {
                    first = first|NO;
                }
                else if([secondObj[i] isKindOfClass:[NSNumber class]])
                {
                    first = first| [secondObj[i] boolValue];
                }
            }
        }
        
        return first?@"true":@"false";
    }
    return @"false";
}

-(id)add:(id)firstobj withSecond:(id)secondObj
{
    if (firstobj) {
        float first = 0;
        if ([firstobj isKindOfClass:[NSString class]]||[firstobj isKindOfClass:[NSNumber class]]) {
            first = [firstobj floatValue];
        }
        if (secondObj) {
            for (int i=0; i<[secondObj count]; i++) {
               first =[secondObj[i] floatValue]+first;
            }
        }
        return [NSString stringWithFormat:@"%f",first];
    }
    return @"add param error";
}

-(id)sub:(id)firstobj withSecond:(id)secondObj
{
    NSString *tempValue = @"sub param error";
    
    if (firstobj) {
        float first = 0;
        if ([firstobj isKindOfClass:[NSString class]]||[firstobj isKindOfClass:[NSNumber class]]) {
            first = [firstobj floatValue];
        }
        if (secondObj) {
            for (int i=0; i<[secondObj count]; i++) {
                first =first-[secondObj[i] floatValue];
            }
        }
        tempValue = [NSString stringWithFormat:@"%f",first];
    }
    return tempValue;
}

-(id)division:(id)firstobj withSecond:(id)secondObj
{
    NSString *tempValue = @"division param error";
    
    if (firstobj) {
        float first = 0;
        if ([firstobj isKindOfClass:[NSString class]]||[firstobj isKindOfClass:[NSNumber class]]) {
            first = [firstobj floatValue];
        }
        if (secondObj) {
            for (int i=0; i<[secondObj count]; i++) {
                float second = [secondObj[i] floatValue];
                if (second>0.00001) {
                    first =first/second;
                }
                else
                {
                    return  @"division param is 0";
                }
            }
        }
        tempValue = [NSString stringWithFormat:@"%f",first];
    }
    return tempValue;
}
-(id)multiply:(id)firstobj withSecond:(id)secondObj
{
    NSString *tempValue = @"multiply param error";
    
    if (firstobj) {
        float first = 0.0;
        if ([firstobj isKindOfClass:[NSString class]]||[firstobj isKindOfClass:[NSNumber class]]) {
            first = [firstobj floatValue];
        }
        if (secondObj) {
            for (int i=0; i<[secondObj count]; i++) {
                first =first*[secondObj[i] floatValue];
            }
        }
        tempValue = [NSString stringWithFormat:@"%f",first];
    }
    return tempValue;
}

-(id)intadd:(id)firstobj withSecond:(id)secondObj
{
    NSString *tempValue = @"addz param error";
    
    if (firstobj) {
        NSInteger first = 0;
        if ([firstobj isKindOfClass:[NSString class]]||[firstobj isKindOfClass:[NSNumber class]]) {
            first = [firstobj integerValue];
        }
        if (secondObj) {
            for (int i=0; i<[secondObj count]; i++) {
                first =[secondObj[i] integerValue]+first;
            }
        }
        tempValue = [NSString stringWithFormat:@"%ld",(long)first];
    }
    return tempValue;
}

-(id)intsub:(id)firstobj withSecond:(id)secondObj
{
    NSString *tempValue = @"subz param error";
    
    if (firstobj) {
        NSInteger first = 0;
        if ([firstobj isKindOfClass:[NSString class]]||[firstobj isKindOfClass:[NSNumber class]]) {
            first = [firstobj integerValue];
        }
        if (secondObj) {
            for (int i=0; i<[secondObj count]; i++) {
                first =first-[secondObj[i] integerValue];
            }
        }
        tempValue = [NSString stringWithFormat:@"%ld",(long)first];
    }
    return tempValue;
}

-(id)intdivision:(id)firstobj withSecond:(id)secondObj
{
    NSString *tempValue = @"divisionz param error";
    
    if (firstobj) {
        NSInteger first = 0;
        if ([firstobj isKindOfClass:[NSString class]]||[firstobj isKindOfClass:[NSNumber class]]) {
            first = [firstobj integerValue];
        }
        if (secondObj) {
            for (int i=0; i<[secondObj count]; i++) {
                float second = [secondObj[i] integerValue];
                if (second>0.00001) {
                    first =first/second;
                }
                else
                {
                    
                    return  @"divisionz param is 0";
                }
            }
        }
        tempValue = [NSString stringWithFormat:@"%ld",(long)first];
    }
    return tempValue;
}

-(id)intmultiply:(id)firstobj withSecond:(id)secondObj
{
    NSString *tempValue = @"multiply param error";
    
    if (firstobj) {
        NSInteger first = 0;
        if ([firstobj isKindOfClass:[NSString class]]||[firstobj isKindOfClass:[NSNumber class]]) {
            first = [firstobj integerValue];
        }
        if (secondObj) {
            for (int i=0; i<[secondObj count]; i++) {
                first =first*[secondObj[i] integerValue];
            }
        }
        tempValue = [NSString stringWithFormat:@"%ld",first];
    }
    return tempValue;
}

-(id)gt:(id)firstobj withSecond:(id)secondObj
{
    NSString *tempValue = @"gt param error";
    if (([firstobj isKindOfClass:[NSString class]]||([firstobj isKindOfClass:[NSNumber class]]))&&secondObj) {
        if ([secondObj count]>0) {
            NSString* element = secondObj[0];
            if ([firstobj floatValue]-[element floatValue]>0.00001) {
                return @"true";
            }
            else
            {
                return @"false";
            }
        }
    }
    
    return tempValue;
}

-(id)lt:(id)firstobj withSecond:(id)secondObj
{
    NSString *tempValue = @"lt param error";
    if (([firstobj isKindOfClass:[NSString class]]||([firstobj isKindOfClass:[NSNumber class]]))&&secondObj) {
        if ([secondObj count]>0) {
            NSString* element = secondObj[0];
            if ([element floatValue]-[firstobj floatValue]>0.00001) {
                return @"true";
            }
            else
            {
                return @"false";
            }
        }
    }
    
    return tempValue;
}

-(id)contains:(id)firstobj withSecond:(id)secondObj
{
    if ([firstobj isKindOfClass:[NSString class]]) {
        if (secondObj) {
            if ([secondObj isKindOfClass:[NSArray class]]) {
                if([firstobj rangeOfString:secondObj[0]].length>0)
                {
                    return @"true";
                }
                else
                {
                    return @"false";
                }
            }
        }
    }
    else if([firstobj isKindOfClass:[NSArray class]])
    {
        if(secondObj)
        {
            if ([secondObj isKindOfClass:[NSArray class]]) {
                if([firstobj containsObject:(secondObj[0])])
                {
                    return @"true";
                }
                else
                {
                    return @"false";
                }
            }
        }
        
    }
    else if([firstobj isKindOfClass:[NSDictionary class]])
    {
        if(secondObj)
        {
            if ([secondObj isKindOfClass:[NSArray class]]) {
                if([firstobj objectForKey:(secondObj[0])])
                {
                    return @"true";
                }
                else
                {
                    return @"false";
                }
            }
        }
    }
    
    return @"contains param error";
}


-(id)choose:(id)firstobj withSecond:(id)secondObj
{
    if ([firstobj isKindOfClass:[NSString class]]&&[secondObj isKindOfClass:[NSArray class]]) {
        if ([firstobj isEqual:@"false"]) {
            if ([secondObj count]>1) {
                return secondObj[1];
            }
            else
            {
                return @"undefine";
            }
        }
        else
        {
            if ([secondObj count]>1) {
                return secondObj[0];
            }
            else
            {
                return @"undefine";
            }
        }

    }
    else
    {
        return firstobj;
    }
}



@end
