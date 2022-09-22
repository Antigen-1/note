◊(define inner 2)
◊(define edge (* inner 2))
◊(define multiplier 1.3)
◊(define color "firebrick")

◊(define index "../index.ptree")

<html>
<head>
<meta charset="UTF-8">
<title>◊(select 'h1 doc)</title>
<style type="text/css">
table, th, td {
        border: 1px solid black;
        border-collapse: collapse;
                       }
th, td {
        padding: 5px;
        text-align: center;
                 }
ul {list-style-type: circle;}
ol {list-style-type: upper-roman;}
body {
    margin: ◊|edge|em;
    padding: ◊|inner|em;
    border: ◊|color|;
    font-size: ◊|multiplier|em;
    line-height: ◊|multiplier|;
}
 
h1 {
    font-size: ◊|multiplier|em;
}
 
#prev, #next {
    position: fixed;
    top: ◊|(/ edge 2)|em;
}
 
#prev {
    left: ◊|edge|em;
}
 
#next {
    right: ◊|edge|em;
}

</style>
</head>
<body>◊(->html doc)
The previous is ◊|(previous here index)|.
The next is ◊|(next here index)|.
</body>
</html>