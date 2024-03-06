#lang pollen
◊(define inner 2)
◊(define edge (* inner 2))
◊(define multiplier 1.3)
◊(define color "firebrick")

img {
  max-width: 100%;
  height: auto;
  border-radius: 8px;
}

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
        text-align: left;
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

span {
    line-height: 20px;
    background: linear-gradient(0deg, green 1px, white 1px, transparent 1px);
    background-position: 0 100%;
}
.two {
    line-height: 24px;
    padding-bottom: 4px;
}
.three {
    line-height: 28px;
    padding-bottom: 8px;
}