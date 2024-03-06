<html>
<head>
<meta charset="UTF-8">
<title>◊(select 'h1 doc)</title>
<link rel="stylesheet" type="text/css" href="../styles.css" />
</head>
<body>
<p>
◊when/splice[(previous here)]{The previous is
                                  <i id="prev"><a href="◊|(previous here)|">◊|(previous here)|</a></i>.}
◊when/splice[(next here)]{The next is
                              <i id="next"><a href="◊|(next here)|">◊|(next here)|</a></i>.}
</p>
◊(->html doc)
</body>
</html>