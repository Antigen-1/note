#lang pollen
◊(define inner 2)
◊(define edge (* inner 2))
◊(define multiplier 1.3)
◊(define color "firebrick")

table, th, td {
        border: 1px solid black;
        border-collapse: collapse;
                       }

tr:nth-child(even) {background-color: #f2f2f2;}

th {
  background-color: #04AA6D;
  color: white;
}

th, td {
        padding: 5px;
        text-align: center;
                 }

li {align-items: left;}

ul {list-style-type: circle;}
                     
ol {list-style-type: upper-roman;}
                     
body {
    margin: ◊|edge|em;
    padding: ◊|inner|em;
    border: 5px solid ◊|color|;
    font-size: ◊|multiplier|em;
    line-height: ◊|multiplier|;
}

code {
    background-color: #a9a9a9;
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
