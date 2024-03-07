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
  background-color: #333;
  padding: 20px;
}

div > label {
    color: white;
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

/*-------------*/

li {align-items: left;}

ul {list-style-type: circle;}

ol {list-style-type: upper-roman;}

/*-------------*/

code {
    background-color: #a9a9a9;
}

/*-------------*/

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

/*-------------*/

span {
    line-height: 20px;
    background: linear-gradient(0deg, black 1px, white 1px, transparent 1px);
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
