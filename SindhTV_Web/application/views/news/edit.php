<?php
$data = unserialize($news['data']);
?>
<!-- Main content -->
<section class="content">

    <div class="row">
        <div class="col-xs-12">
            <p class="lead">News # <?php echo ucfirst($news['content_id']); ?></p>

            <div class="col-xs-6">
                <div class="table-responsive">

                    <div class="box box-primary">

                        <!-- form start -->
                        <form name="edit_news" id="club_news" action="<?php echo base_url(); ?>index.php/admin/news/update" method="POST"  enctype="multipart/form-data">
                            <input name="news[is_submit]" id="is_submit" value="1" type="hidden" />
                            <input name="news[id]" id="uniqid" value="<?php echo $news['content_id']; ?>" type="hidden" />
                            <div class="box-body">



                                <div class="form-group">
                                    <label>Title</label>
                                    <input type="text" class="form-control" name="news[title]" placeholder="Enter ..." value="<?php echo $news['title']; ?>">
                                </div>
                                <div class="form-group">
                                    <label>Category</label>
                                    <select name="news[data][category]" class="form-control">
                                        <option value="">Choose a Category:</option>
                                        <?php foreach ($news_category as $value) { ?>
                                            <option value="<?php echo $value['id']; ?>"
                                            <?php
                                            if ($data['category'] == $value['id']) {
                                                echo 'selected="selected"';
                                            }
                                            ?>
                                                    ><?php echo $value['category']; ?></option>                                  
                                                <?php } ?>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="news_description">Description</label>
                                    <textarea class="form-control" id="news_description" name="news[description]" rows="3" placeholder="Enter ..."><?php echo $news['description']; ?></textarea>
                                </div>


                                <div class="form-group">
                                    <div style="background: #f7f8fa;padding: 50px;">

                                        <input type="file" multiple="multiple" name="userfile[]" id="input2">

                                    </div>

                                </div><!-- /.box-body -->

                                <div class="box-footer">
                                    <button type="submit" class="btn btn-primary">Submit</button>
                                </div>
                        </form>
                    </div>

                </div>
            </div>
            </div>
            <div class="col-md-6">
                <div class="box box-primary">
                    <div class="box-header">
                        <h3 class="box-title">Uploaded Images</h3>
                    </div>


                    <div class="box-body">


                        <?php
                        if (!empty($news['images'])) {
                            ?>
                            <ul class="jFiler-item-list box-body ">
                                <?php
                                foreach ($news['images'] as $image) {
                                    ?>
                                    <li class="jFiler-item" data-jfiler-index="3" style="">    
                                        <div class="jFiler-item-container">               
                                            <div class="jFiler-item-inner">                                    
                                                <div class="jFiler-item-thumb">                                        
                                                    <div class="jFiler-item-status"></div>                                        
                                                    <div class="jFiler-item-info">                                            

                                                    </div>                                        
                                                    <div class="jFiler-item-thumb-image">
                                                        <img src="<?php echo $image['path']; ?>" draggable="false">
                                                    </div>    

                                                </div>   
                                                <div class="jFiler-item-assets jFiler-row">         
                                                    <ul class="list-inline pull-left">         
                                                        <li>
                                                            <div class="jFiler-jProgressBar" style="display: none;">
                                                                <div class="bar" style="width: 100%;"></div>

                                                            </div><div class="jFiler-item-others text-success">
                                                                <i class="icon-jfi-check-circle"></i> 
                                                                Uploaded</div>
                                                        </li>                             
                                                    </ul>                                        
                                                    <ul class="list-inline pull-right">   
                                                        <li><a href="<?php echo base_url(); ?>index.php/admin/news/delete_image/<?php echo $image['id'] . '/' . $news['content_id']; ?>" class="icon-jfi-trash jFiler-item-trash-action delete_anything"></a>
                                                        </li>                                       
                                                    </ul>                                
                                                </div>

                                            </div>                            
                                        </div>                        
                                    </li>
                                <?php } ?>
                            </ul>
                            <?php
                        } else {
                            ?>
                            <p>No Images so far.</p>
                            <?php
                        }
                        ?>

                        <div style="clear: both"></div>
                    </div><!-- /.box-body -->
                </div><!-- /.box -->

            </div>

        </div>
    </div>

</section><!-- /.content -->

