# Markup for Objective C

Markup is simple and useful Markup Language。it was wirtten by Js and widely used in web. We alse can use it in Native code, So I rewrite it by Objective C . When you write iOS App , you can think about it . 


# Why use markup
1.markup is powerful,simple, and lightly

2.markup can  combine temple and data,which help you merge data to view. you need not write hard code in your project.

3.lots of project use markup ,such as vue.js.

# How to use
1. import WKMarkup.h 和WKMarkup.m  
2. use the interface.

# example
#### value
template:
Hi, {{name.first}}!<br>

data:
{
    name: {
        first: "John",
        last: "Doe"
    }
}

```output："Hi, John!"```
#### Array
template：Favorite color: {{colors.0}}<br>
data：{
    name: "John Doe",
    colors: ["Red", "Blue", "Green"]
}<br>
```output："Favorite color: Red"```

#### Loops
* template：```<ul>{{brothers}}<li>{{.}}</li>{{/brothers}}</ul>```
* data：{
    name: "John Doe",
    brothers: ["Jack", "Joe", "Jim"]
}<br>
* ```输出：<ul><li>Jack</li><li>Joe</li><li>Jim</li></ul>```

#### Pipes
* template：```Name: {{name|upcase}}```
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

#### Chaining pipes
* template：Alias: {{alias|trim|downcase}}
* data：{
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
* output：Alias: j-do

#### IF and IF/ELSE statements
* template：{{if children|empty}} John has no kids. {{/if}}
* data：{
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
* output：John has no kids. 

