<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8"/>
<meta name="keywords" content="gamingwiki index homepage signin signup " />
<meta name="description" content="Gaming wiki homepage" />
<title> GamingWiki</title>
<link rel="stylesheet" type="text/css" href="articleCreator.css" />
<script src="articleCreator.js" type="text/javascript"></script>
</head>
<body>
	<?php require_once('./initHeader.php') ?>
	<div id="main">
	<table>
	<tr>
		<td>
			<textarea cols = "115" rows = "40" id="textbox"></textarea>
			<input type="button" id="previewButton" onclick="insertPreview()" value="Insert Preview">
			<input type="button" id="submitButton" value="Submit Article">
		</td>
		<td>
		<div id = "preview">
				
		</div>
		</td>
	</tr>
	</table>
	</div>
	<?php require_once('./initFooter.php') ?>
</body>
</html>