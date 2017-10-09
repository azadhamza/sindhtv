<section class="content">

    <h1>Headlines</h1>


    <div class="row">
        <div class="col-xs-12">
            <a href="<?php echo site_url('admin/headlines/addnew') ?>"><button class="btn btn-info pull-right" style="margin:10px ">Add New</button></a>
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
                            <th>Headline Link</th>
                            <th>Status</th>
                            <th>Action</th>

                        </tr>
                        <?php
                        if (!empty($headlines))
                            foreach ($headlines as $headlines) {
                                $data = unserialize($headlines['data']);
                                $link = '';
                                if ($data['type'] == 'link') {
                                    $link = $data['link'];
                                } elseif ($data['type'] == 'upload') {
                                    $link = $headlines['image'][0]['path'] . $headlines['image'][0]['name'];
                                }
                                ?>
                                <tr>
                                    <td><?php echo $headlines['content_id']; ?></td>
                                    <td><?php echo $headlines['title']; ?></td>                                
                                    <td><?php echo(strlen($headlines['description']) > 100) ? substr($headlines['description'], 0, 97) . '...' : $headlines['description']; ?></td>
                                    <td><a href="<?php echo$link; ?>" target="_blank"><i class="fa fa-television"></i></a></td>
                                    <td>
                                        <a href="/index.php/admin/headlines/status/<?php echo $headlines['content_id'] . '/' . !$headlines['is_approved']; ?>"/>
                                        <?php
                                        echo ($headlines['is_approved'] == 1) ? "<span class='label label-success'>Approved</span>" : "<span class='label label-danger'>Rejected</span>";
                                        ?>
                                        </a>
                                    </td>

                                    <td>
                                        <a href="<?php echo base_url(); ?>index.php/admin/headlines/view/<?php echo $headlines['content_id']; ?>">View</a>
                                        &nbsp;&nbsp;&nbsp;
                                        <a href="<?php echo base_url(); ?>index.php/admin/headlines/edit/<?php echo $headlines['content_id']; ?>">Edit</a>
                                        &nbsp;&nbsp;&nbsp;
                                        <a href="<?php echo base_url(); ?>index.php/admin/headlines/delete/<?php echo $headlines['content_id']; ?>/<?php echo ($headlines['is_active'] == 1) ? '0' : '1'; ?>" class="status_confirm">
                                            <?php
                                            echo ($headlines['is_active'] == 1) ? "Delete" : "Activate";
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
