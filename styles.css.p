◊(define inner 2)
◊(define edge (* inner 2))
◊(define multiplier 1.3)
◊(define color "firebrick")

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
