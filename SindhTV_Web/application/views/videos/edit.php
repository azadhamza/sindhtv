<?php
$data = unserialize($videos['data']);
?>
<!-- Main content -->
<section class="content">

    <div class="row">
        <div class="col-xs-12">
            <p class="lead">Video # <?php echo ucfirst($videos['content_id']); ?></p>

            <div class="col-xs-6">
                <div class="table-responsive">

                    <div class="box box-primary">

                        <!-- form start -->
                        <form name="edit_videos" id="club_videos" action="<?php echo base_url(); ?>index.php/admin/videos/update" method="POST"  enctype="multipart/form-data">
                            <input name="videos[is_submit]" id="is_submit" value="1" type="hidden" />
                            <input name="videos[id]" id="uniqid" value="<?php echo $videos['content_id']; ?>" type="hidden" />
                            <div class="box-body">
                                <div class="form-group">
                                    <label>Title</label>
                                    <input type="text" class="form-control" name="videos[title]" placeholder="Enter ..." value="<?php echo $videos['title']; ?>">
                                </div>
                                <div class="form-group">
                                    <label for="videos_description">Description</label>
                                    <textarea class="form-control" id="videos_description" name="videos[description]" rows="3" placeholder="Enter ..."><?php echo $videos['description']; ?></textarea>
                                </div>
                                <div class="form-group ">
                                    <label>Video</label><br>
                                    <input type="radio" id="link" class="video" name="videos[data][type]" value="link" <?php echo ($data['type']=='link')?'checked="checked"':''; ?>> <label for="link">Link</label>
                                    <b style="margin: 0px 10px;">OR</b>
                                    <input type="radio" id="video" class="video" name="videos[data][type]" value="upload" <?php echo ($data['type']=='upload')?'checked="checked"':''; ?>> <label for="video">Upload</label>
                                </div>
 

                                <div class="form-group link-sec" <?php echo ($data['type']=='upload')?'style="display:none;"':''; ?>>
                                    <label>Link</label>
                                    <input type="text" class="form-control" name="videos[data][link]" placeholder="Enter ..." value="<?php echo $data['link']; ?>">
                                </div>
                                <div class="form-group upload-sec" <?php echo ($data['type']=='link')?'style="display:none;"':''; ?>>
                                    <div style="background: #f7f8fa;padding: 50px;">
                                        <input type="file"  name="userfile[]" id="input2">
                                    </div>
                                </div><!-- /.box-body -->
                            </div>
                            <div class="box-footer">
                                <button type="submit" class="btn btn-primary">Submit</button>
                            </div>
                        </form>
                    </div>

                </div>
            </div>

            <div class="col-md-6" <?php echo ($data['type']=='link')?'style="display:none;"':''; ?>>
                <div class="box box-primary">
                    <div class="box-header">
                        <h3 class="box-title">Uploaded Video</h3>
                    </div>


                    <div class="box-body">


                        <?php
                        if (!empty($videos['images'])) {
                            ?>
                            <ul class="jFiler-item-list box-body ">
                                <?php
                                foreach ($videos['images'] as $image) {
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
                                                        <li><a href="<?php echo base_url(); ?>index.php/admin/videos/delete_image/<?php echo $image['id'] . '/' . $videos['content_id']; ?>" class="icon-jfi-trash jFiler-item-trash-action delete_anything"></a>
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
                            <p>No Video so far.</p>
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

