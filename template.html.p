<html>
<head>
<meta charset="UTF-8">
<title>◊(select 'h1 doc)</title>
<link rel="stylesheet" type="text/css" href="styles.css" />
</head>
<body>◊(->html doc)
◊when/splice[(previous here)]{The previous is
                                  <a href="◊|(previous here)|">◊|(previous here)|</a>.}
◊when/splice[(next here)]{The next is
                              <a href="◊|(next here)|">◊|(next here)|</a>.}
</body>
</html>