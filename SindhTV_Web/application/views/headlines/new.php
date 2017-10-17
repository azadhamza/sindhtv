<!-- Main content -->
<section class="content">

    <div class="row">
        <div class="col-xs-6">
            <p class="lead">Add Headline</p>

            <div class="table-responsive">

                <div class="box box-primary">

                    <!-- form start -->
                    <form name="add_headlines" id="club_headlines" action="<?php echo base_url(); ?>index.php/admin/headlines/submit" method="POST"  enctype="multipart/form-data">
                        <input name="headlines[is_submit]" id="is_submit" value="1" type="hidden" />

                        <div class="box-body">



                            <div class="form-group">
                                <label>Title</label>
                                <input type="text" class="form-control" name="headlines[title]"  autocomplete="off" list="headlinetitle" placeholder="Enter ..." value="">
                                <datalist id="headlinetitle">
                                    <?php foreach ($titles as $value) { ?>
                                        <option value="<?php echo $value['title']; ?>">                                        
                                        <?php } ?>
                                </datalist>
                            </div>

                            

                            

                            <div class="form-group">
                                <label for="headlines_description">Description</label>
                                <textarea class="form-control" id="headlines_description" name="headlines[description]" rows="3" placeholder="Enter ..."></textarea>
                            </div>
                            <div class="form-group" >
                                <label>Thumbnail</label><br>
                                <div style="background: #f7f8fa;padding: 50px;">
                                    <input type="file"  name="thumb[]" id="input2">

                                </div>
                            </div> 
                            <div class="form-group ">
                                <label>Headline</label><br>
                                <input type="radio" id="link" class="video" name="headlines[data][type]" value="link" checked="checked"> <label for="link">Link</label>
                                <b style="margin: 0px 10px;">OR</b>
                                <input type="radio" id="video" class="video" name="headlines[data][type]" value="upload"> <label for="headline">Upload</label>
                            </div>
                            <div class="form-group link-sec">
                                <label>Link</label>
                                <input type="text" class="form-control" name="headlines[data][link]" placeholder="Enter ..." value="">
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
