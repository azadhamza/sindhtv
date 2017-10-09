<!--Main content--> 
<section class="content">

    <div class="row">
        <div class="col-xs-6">
            <p class="lead">Live Stream</p>

            <div class="table-responsive">

                <div class="box box-primary">

                    <!--form start--> 
                    <form name="add_news" action="<?php echo base_url(); ?>index.php/admin/live_stream/submit" method="POST"  enctype="multipart/form-data">
                        <input name="news[is_submit]" id="is_submit" value="1" type="hidden" />

                        <div class="box-body">



                            <div class="form-group">
                                <label>Live Stream URL</label>
                                <input type="text" class="form-control" name="settings[live_stream_link]" placeholder="Enter ..." value="<?php echo!empty($live_stream_link['value']) ? $live_stream_link['value'] : '' ?>">
                            </div>

                            <div class="form-group" >
                                <label>Live Stream Thumbnail</label><br>
                                <div style="background: #f7f8fa;padding: 50px;">
                                    <input type="file"  name="thumb[]" id="input2">
                                    <img src="<?php echo!empty($live_stream_thumb['value']) ? $live_stream_thumb['value'] : '' ?>" class="lv_thumbnail col-xs-6">
                                </div>

                            </div> 

                        </div> 
                        <!--/.box-body--> 

                        <div class="box-footer">
                            <button type="submit" class="btn btn-primary">Submit</button>
                        </div>
                    </form>
                </div>

            </div>
        </div>
    </div>
</section> 
<!--/.content--> 
<style>
    img.lv_thumbnail {
        float: right;
        top: -60px;
        right: -52px;
    }
</style>