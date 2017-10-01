<?php
$data = unserialize($videos['data']);
?>
<!-- Main content -->

<section class="content">
    <div class="row  col-xs-12">
        <div class="col-xs-6">
            <div class="box box-primary">




                <div class="table-responsive">
                    <table class="table">
                        <tbody>
                            <tr>
                                <td>            <p class="lead col-xs-6">Video # <?php echo ucfirst($videos['content_id']); ?></p>
                                </td>
                                <td >            <a href="<?php echo site_url('admin/videos/delete/' . $videos['content_id'] . '/' . (($videos['is_active'] == 1) ? '0' : '1') . '/view'); ?>"><button class="btn <?php echo ($videos['is_active'] == 1) ? "btn-danger" : "btn-primary"; ?> pull-right status_confirm" style="margin:10px "><?php echo ($videos['is_active'] == 1) ? "Delete" : "Activate"; ?></button></a>
                                </td>
                            </tr>
                            <tr>
                                <th>Title:</th>
                                <td><?php echo $videos['title']; ?></td>
                            </tr>
                            <tr>
                                <th>Category:</th>
                                <td><?php echo $video_category[$data['category']]; ?></td>
                            </tr>
                            <tr>
                                <th>Description</th>
                                <td><?php echo $videos['description']; ?></td>
                            </tr>


                        </tbody></table>


                </div>

            </div>
        </div>
        <div class="col-md-6">
            <div class="box box-primary">
                <div class="box-header">
                    <h3 class="box-title">Video</h3>
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
                                                    <img src="<?php echo $image; ?>" draggable="false">
                                                </div>                                    
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
</section><!-- /.content -->
