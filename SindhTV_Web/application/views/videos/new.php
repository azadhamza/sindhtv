<!-- Main content -->
<section class="content">

    <div class="row">
        <div class="col-xs-6">
            <p class="lead">Add Video</p>

            <div class="table-responsive">

                <div class="box box-primary">

                    <!-- form start -->
                    <form name="add_videos" id="club_videos" action="<?php echo base_url(); ?>index.php/admin/videos/submit" method="POST"  enctype="multipart/form-data">
                        <input name="videos[is_submit]" id="is_submit" value="1" type="hidden" />

                        <div class="box-body">



                            <div class="form-group">
                                <label>Title</label>
                                <input type="text" class="form-control" name="videos[title]" placeholder="Enter ..." value="">
                            </div>


                            <div class="form-group">
                                <label for="videos_description">Description</label>
                                <textarea class="form-control" id="videos_description" name="videos[description]" rows="3" placeholder="Enter ..."></textarea>
                            </div>
                            <div class="form-group ">
                                <label>Video</label><br>
                                <input type="radio" id="link" class="video" name="videos[data][type]" value="link" checked="checked"> <label for="link">Link</label>
                                <b style="margin: 0px 10px;">OR</b>
                                <input type="radio" id="video" class="video" name="videos[data][type]" value="upload"> <label for="video">Upload</label>
                            </div>
                            <div class="form-group link-sec">
                                <label>Link</label>
                                <input type="text" class="form-control" name="videos[data][link]" placeholder="Enter ..." value="">
                            </div>


                            <div class="form-group upload-sec" style="display: none">
                                <label>Upload</label><br>
                                <div style="background: #f7f8fa;padding: 50px;">
                                    <input type="file"  name="userfile[]" id="input2">

                                </div>
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
</section><!-- /.content -->
