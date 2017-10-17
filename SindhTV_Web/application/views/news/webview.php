<html>
    <head>
        <title>News  - <?php echo $news[0]['title']; ?></title>
    </head>
    <body>
        <div class="news">
            <h1><?php echo $news[0]['title']; ?></h1>
            <?php if (!empty($images[0]['name'])) { ?>
                <img src="<?php echo $images[0]['path'] . $images[0]['name']; ?>"/>
            <?php } ?>
            <div>
                <?php echo $news[0]['description']; ?>
            </div>
        </div>
    </body>
    <style>
        .news{
            text-align: center;
        }
        .news img{
            max-width: 615px;
        }
    </style>
</html>