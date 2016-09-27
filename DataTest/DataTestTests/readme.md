#Markup oc版
markup是一个功能强大，让人惊喜，但又非常简易的模板系统。
其js版本在web上使用广泛，Native也可以借鉴这种思想，为此我实现了Markup的oc版本。 期望大家在Native开发的时候能用得上。

#为什么选择markup
1.markup直观，体积小
2.markup可以方便用模板和数据的结合，省去结构数据硬编码到转换到视图或者到文本格式中。

#如何使用
* 1.导入WKMarkup.h 和WKMarkup.m ，在头文件中只有几个接口，所以奔跑吧，骚年。

#使用举例
####值替换
模板：Hi, {{name.first}}!<br>
数据：{
name: {
first: "John",
last: "Doe"
}
}<br>
```输出："Hi, John!"```

####数组
模板：Favorite color: {{colors.0}}<br>
数据：{
name: "John Doe",
colors: ["Red", "Blue", "Green"]
}<br>
```输出："Favorite color: Red"```

####循环
* 模板：```<ul>{{brothers}}<li>{{.}}</li>{{/brothers}}</ul>```
* 数据：{
name: "John Doe",
brothers: ["Jack", "Joe", "Jim"]
}<br>
* ```输出：<ul><li>Jack</li><li>Joe</li><li>Jim</li></ul>```

####管导
* 模板：```Name: {{name|upcase}}```
* 数据：{
name: "John Doe",
alias: " J-Do ",
phone: null,
gender: "male",
age: 33.33,
vitals: [68, 162.5, "AB"],
brothers: ["Jack", "Joe", "Jim"],
sisters: [{name: "Jill"}, {name: "Jen"}],
jiggy: true
}
* "Name: JOHN DOE"

####链式管道
* 模板：Alias: {{alias|trim|downcase}}
* 数据：{
name: "John Doe",
alias: " J-Do ",
phone: null,
gender: "male",
age: 33.33,
vitals: [68, 162.5, "AB"],
brothers: ["Jack", "Joe", "Jim"],
sisters: [{name: "Jill"}, {name: "Jen"}],
jiggy: true
}
* 输出：Alias: j-do

####条件判断 IF and IF/ELSE statements
* 模板：{{if children|empty}} John has no kids. {{/if}}
* 数据：{
name: "John Doe",
alias: " J-Do ",
phone: null,
gender: "male",
age: 33.33,
vitals: [68, 162.5, "AB"],
brothers: ["Jack", "Joe", "Jim"],
sisters: [{name: "Jill"}, {name: "Jen"}],
jiggy: true
}
* 输出：John has no kids.

