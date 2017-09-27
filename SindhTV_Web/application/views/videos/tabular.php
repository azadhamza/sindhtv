<section class="content">

    <h1>Videos</h1>


    <div class="row">
        <div class="col-xs-12">
            <a href="<?php echo site_url('admin/videos/addnew') ?>"><button class="btn btn-info pull-right" style="margin:10px ">Add New</button></a>
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
                        foreach ($videos as $videos) {
                            $data = unserialize($videos['data']);
                            ?>
                            <tr>
                                <td><?php echo $videos['content_id']; ?></td>
                                <td><?php echo $videos['title']; ?></td>
                                <td><?php echo(strlen($videos['description']) > 100) ? substr($videos['description'], 0, 97) . '...' : $videos['description']; ?></td>
                                <td>
                                    <?php
                                    echo ($videos['is_active'] == 1) ? "<span class='label label-success'>Active</span>" : "<span class='label label-danger'>Inactive</span>";
                                    ?>
                                </td>

                                <td>
                                    <a href="<?php echo base_url(); ?>index.php/admin/videos/view/<?php echo $videos['content_id']; ?>">View</a>
                                    &nbsp;&nbsp;&nbsp;
                                    <a href="<?php echo base_url(); ?>index.php/admin/videos/edit/<?php echo $videos['content_id']; ?>">Edit</a>
                                    &nbsp;&nbsp;&nbsp;
                                    <a href="<?php echo base_url(); ?>index.php/admin/videos/delete/<?php echo $videos['content_id']; ?>/<?php echo ($videos['is_active'] == 1) ? '0' : '1'; ?>" class="status_confirm">
                                        <?php
                                        echo ($videos['is_active'] == 1) ? "Delete" : "Activate";
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
