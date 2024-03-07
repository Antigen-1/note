<html>
<head>
<meta charset="UTF-8">
<title>◊(select 'h1 doc)</title>
<link rel="stylesheet" type="text/css" href="../styles.css" />
</head>
<body>
<p>
◊when/splice[(previous here)]{<i id="prev-top"><a href="◊|(previous here)|">◊|(previous here)|</a></i>}
◊when/splice[(next here)]{<i id="next-top"><a href="◊|(next here)|">◊|(next here)|</a></i>}
</p>
◊(->html doc)
<p><i id="prev-bottom"><a href="../index.html">Return to index</a></i></p>
</body>
</html>