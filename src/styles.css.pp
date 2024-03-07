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

thead,
tfoot {
  background-color: #2c5e77;
  color: #fff;
}

tbody {
  background-color: #e4f0f5;
}

table {
  border-collapse: collapse;
  border: 2px solid rgb(140 140 140);
  font-family: sans-serif;
  font-size: 1em;
  letter-spacing: 1px;
}

caption {
  caption-side: bottom;
  padding: 10px;
}

th,
td {
  border: 1px solid rgb(160 160 160);
  padding: 8px 10px;
}

td {
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

#prev-top, #next-top, #prev-bottom, #next-bottom {
    position: fixed;
}

#prev-top, #next-top {
    top: ◊|(/ edge 2)|em;
}

#prev-bottom, #next-bottom {
    bottom: ◊|(/ edge 2)|em;
}
 
#prev-top, #prev-bottom {
    left: ◊|edge|em;
}
 
#next-top, #next-bottom {
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