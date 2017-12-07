<?php
$data = unserialize($headlines['data']);
?>
<!-- Main content -->
<section class="content">

    <div class="row">
        <div class="col-xs-12">
            <p class="lead">Headline # <?php echo ucfirst($headlines['content_id']); ?></p>

            <div class="col-xs-6">
                <div class="table-responsive">

                    <div class="box box-primary">

                        <!-- form start -->
                        <form name="edit_headlines" id="club_headlines" action="<?php echo base_url(); ?>index.php/admin/headlines/update" method="POST"  enctype="multipart/form-data">
                            <input name="headlines[is_submit]" id="is_submit" value="1" type="hidden" />
                            <input name="headlines[id]" id="uniqid" value="<?php echo $headlines['content_id']; ?>" type="hidden" />
                            <div class="box-body">
                                <div class="form-group">
                                    <label>Title(Date)</label>
                                    <input type="text" class="form-control predatepicker" autocomplete="off" name="headlines[title]" list="headlinetitle" placeholder="Enter ..." value="<?php echo $headlines['title']; ?>">
                                    <!--<datalist id="headlinetitle">-->
                                        <?php // foreach ($titles as $value) { ?>
                                            <!--<option value="<?php // echo $value['title']; ?>">-->                                        
                                            <?php // } ?>
                                    <!--</datalist>-->
                                </div>
                                
                            <div class="form-group">
                                <label>Time</label>
                                <input type="text" class="form-control timepicker" list="time" name="headlines[detail_description]"  autocomplete="off"  placeholder="Enter ..." value="<?php echo $headlines['detail_description']; ?>">
                                <datalist id="time">
                                    <option value="12:00am">
                                    <option value="12:30am">
                                    <option value="1:00am">
                                    <option value="1:30am">
                                    <option value="2:00am">
                                    <option value="2:30am">
                                    <option value="3:00am">
                                    <option value="3:30am">
                                    <option value="4:00am">
                                    <option value="4:30am">
                                    <option value="5:00am">
                                    <option value="5:30am">
                                    <option value="6:00am">
                                    <option value="6:30am">
                                    <option value="7:00am">
                                    <option value="7:30am">
                                    <option value="8:00am">
                                    <option value="8:30am">
                                    <option value="9:00am">
                                    <option value="9:30am">
                                    <option value="10:00am">
                                    <option value="10:30am">
                                    <option value="11:00am">
                                    <option value="11:30am">
                                    <option value="12:00pm">
                                    <option value="12:30pm">
                                    <option value="1:00pm">
                                    <option value="1:30pm">
                                    <option value="2:00pm">
                                    <option value="2:30pm">
                                    <option value="3:00pm">
                                    <option value="3:30pm">
                                    <option value="4:00pm">
                                    <option value="4:30pm">
                                    <option value="5:00pm">
                                    <option value="5:30pm">
                                    <option value="6:00pm">
                                    <option value="6:30pm">
                                    <option value="7:00pm">
                                    <option value="7:30pm">
                                    <option value="8:00pm">
                                    <option value="8:30pm">
                                    <option value="9:00pm">
                                    <option value="9:30pm">
                                    <option value="10:00pm">
                                    <option value="10:30pm">
                                    <option value="11:00pm">
                                    <option value="11:30pm">
                                </datalist>
                            </div>

                               
                                <div class="form-group">
                                    <label for="headlines_description">Description</label>
                                    <textarea class="form-control" id="headlines_description" name="headlines[description]" rows="3" placeholder="Enter ..."><?php echo $headlines['description']; ?></textarea>
                                </div>
                                <div class="form-group" >
                                    <label>Thumbnail</label><br>
                                    <div style="background: #f7f8fa;padding: 50px;">
                                        <input type="file"  name="thumb[]" id="input2">

                                    </div>
                                </div> 
                                <div class="form-group ">
                                    <label>Headline</label><br>
                                    <input type="radio" id="link" class="video" name="headlines[data][type]" value="link" <?php echo ($data['type'] == 'link') ? 'checked="checked"' : ''; ?>> <label for="link">Link</label>
                                    <b style="margin: 0px 10px;">OR</b>
                                    <input type="radio" id="video" class="video" name="headlines[data][type]" value="upload" <?php echo ($data['type'] == 'upload') ? 'checked="checked"' : ''; ?>> <label for="headline">Upload</label>
                                </div>


                                <div class="form-group link-sec" <?php echo ($data['type'] == 'upload') ? 'style="display:none;"' : ''; ?>>
                                    <label>Link</label>
                                    <input type="text" class="form-control" name="headlines[data][link]" placeholder="Enter ..." value="<?php echo $data['link']; ?>">
                                </div>
                                <div class="form-group upload-sec" <?php echo ($data['type'] == 'link') ? 'style="display:none;"' : ''; ?>>
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

            <div class="col-md-6" <?php echo ($data['type'] == 'link') ? 'style="display:none;"' : ''; ?>>
                <div class="box box-primary">
                    <div class="box-header">
                        <h3 class="box-title">Uploaded Headline Video</h3>
                    </div>


                    <div class="box-body">


                        <?php
                        if (!empty($headlines['images'])) {
                            ?>
                            <ul class="jFiler-item-list box-body ">
                                <?php
                                foreach ($headlines['images'] as $image) {
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
                                                        <li><a href="<?php echo base_url(); ?>index.php/admin/headlines/delete_image/<?php echo $image['id'] . '/' . $headlines['content_id']; ?>" class="icon-jfi-trash jFiler-item-trash-action delete_anything"></a>
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
                            <p>No Headline so far.</p>
                            <?php
                        }
                        ?>

                        <div style="clear: both"></div>
                    </div><!-- /.box-body -->

                    <div class="box-header">
                        <h3 class="box-title">Thumbnail</h3>
                    </div>


                    <div class="box-body">


                        <?php
                        if (!empty($headlines['thumb'])) {
                            ?>
                            <ul class="jFiler-item-list box-body ">
                                <?php
                                foreach ($headlines['thumb'] as $thumb_image) {
                                    ?>
                                    <li class="jFiler-item" data-jfiler-index="3" style="">    
                                        <div class="jFiler-item-container">               
                                            <div class="jFiler-item-inner">                                    
                                                <div class="jFiler-item-thumb">                                        
                                                    <div class="jFiler-item-status"></div>                                        
                                                    <div class="jFiler-item-info">                                            

                                                    </div>                                        
                                                    <div class="jFiler-item-thumb-thumb_image">
                                                        <img src="<?php echo $thumb_image['path']; ?>" draggable="false">
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
                                                        <li><a href="<?php echo base_url(); ?>index.php/admin/headlines/delete_thumb_image/<?php echo $thumb_image['id'] . '/' . $headlines['content_id']; ?>" class="icon-jfi-trash jFiler-item-trash-action delete_anything"></a>
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
                            <p>No Headline so far.</p>
                            <?php
                        }
                        ?>

                        <div style="clear: both"></div>
                    </div>
                </div><!-- /.box -->

            </div>

        </div>
    </div>

</section><!-- /.content -->

