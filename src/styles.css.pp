#lang pollen
◊(define inner 2)
◊(define edge (* inner 2))
◊(define multiplier 1.5)

/*-------------*/

body{
  font-family: "Montserrat", sans-serif;
  color: white;
  background-color: #333;
  text-align:left;
  margin: ◊|edge|em;
  padding: ◊|inner|em;
  border: 5px solid #321414;
  font-size: ◊|multiplier|em;
  line-height: ◊|multiplier|;
}

/*-------------*/

div {
  border-radius: 5px;
  padding: 20px;
}

/*-------------*/

a:link {
  color: #fffaf0;
  background-color: transparent;
  text-decoration: none;
}

a:visited {
  color: #77dd77;
  background-color: transparent;
  text-decoration: none;
}

a:hover {
  color: #b22222;
  background-color: transparent;
  text-decoration: underline;
}

a:active {
  color: #e6e8fa;
  background-color: transparent;
  text-decoration: underline;
}

/*-------------*/

img {
  max-width: 100%;
  height: auto;
  border-radius: 8px;
}

/*-------------*/

thead,
tfoot {
  background-color: #2c5e77;
  color: #fff;
}

tbody {
  background-color: #e4f0f5;
  color: #100c08;
}

table {
  border-collapse: collapse;
  border: 2px solid rgb(140 140 140);
  font-size: 0.9em;
  letter-spacing: 1px;
}

caption {
  caption-side: top;
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

/*-------------*/

ul {
   font-size: 0.9em;
   list-style-type: disc;
   text-align: left;
}

ol {
   font-size: 0.9em;
   list-style-type: decimal;
   text-align: left;
}

li {
   margin-bottom: 0.8em;
}

dt {
  font-weight: bold;
}

dl {
  text-align: left;
  font-size: 0.9em;
}

dd {
  margin-bottom: 0.8em;
}

/*-------------*/

code {
    background-color: #eee;
    border-radius: 3px;
    font-family: courier, monospace;
    padding: 0 3px;
}

/*-------------*/

#prev-top, #next-top, #prev-bottom, #next-bottom {
    position: fixed;
}

#prev-top, #next-top {
    top: ◊|inner|em;
}

#prev-bottom, #next-bottom {
    bottom: ◊|inner|em;
}

#prev-top, #prev-bottom {
    left: ◊|edge|em;
}

#next-top, #next-bottom {
    right: ◊|edge|em;
}

/*-------------*/

span {
    line-height: 20px;
    background: linear-gradient(0deg, white 1px, black 1px, transparent 1px);
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

/*-------------*/
