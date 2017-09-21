<section class="content">
<?php echo base_url(uri_string());?>
    <h1>News</h1>


    <div class="row">
        <div class="col-xs-12">
            <a href="<?php echo site_url('admin/news/addnew') ?>"><button class="btn btn-info pull-right" style="margin:10px ">Add New</button></a>
        </div>

        <div class="col-xs-12">

            <div class="box">
                <div class="box-header">
                </div><!-- /.box-header -->


                <div class="box-body table-responsive no-padding">

                    <table class="table table-hover">
                        <tr>
                            <th>#</th>
                            <th>Title</th>
                            <th>Description</th>
                            <th>Status</th>
                            <th>Action</th>

                        </tr>
                        <?php
                        foreach ($news as $news) {
                            $data = unserialize($news['data']);
                            ?>
                            <tr>
                                <td><?php echo $news['content_id']; ?></td>
                                <td><?php echo $news['title']; ?></td>
                                <td><?php echo(strlen($news['description']) > 100) ? substr($news['description'], 0, 97) . '...' : $news['description']; ?></td>
                                <td>
                                    <?php
                                    echo ($news['is_active'] == 1) ? "<span class='label label-success'>Active</span>" : "<span class='label label-danger'>Inactive</span>";
                                    ?>
                                </td>

                                <td>
                                    <a href="<?php echo base_url(); ?>index.php/admin/news/view/<?php echo $news['content_id']; ?>">View</a>
                                    &nbsp;&nbsp;&nbsp;
                                    <a href="<?php echo base_url(); ?>index.php/admin/news/edit/<?php echo $news['content_id']; ?>">Edit</a>
                                    &nbsp;&nbsp;&nbsp;
                                    <a href="<?php echo base_url(); ?>index.php/admin/news/delete/<?php echo $news['content_id']; ?>/<?php echo ($news['is_active'] == 1) ? '0' : '1'; ?>" class="status_confirm">
                                        <?php
                                        echo ($news['is_active'] == 1) ? "Delete" : "Activate";
                                        ?>
                                    </a>
                                </td> 
                            </tr>
                            <?php
                        }
                        ?>

                    </table>
                </div><!-- /.box-body -->
            </div><!-- /.box -->
        </div>
    </div>
    <div class="row">
        <div class="col-sm-12"><div class="dataTables_paginate paging_simple_numbers" id="example2_paginate">
                <?php echo $links; ?>
            </div></div>
    </div>

</section>
