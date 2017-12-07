<section class="content">

    <h1>User Uploads</h1>


    <div class="row">


        <div class="col-xs-12">

            <div class="box">
                <div class="box-header">
                </div><!-- /.box-header -->


                <div class="box-body table-responsive no-padding">

                    <table class="table table-hover">
                        <tr>
                            <th>#</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Description</th>
                            <th>Phone Number</th>
                            <th>Category</th>
                            <th>Status</th>
                            <th>Action</th>

                        </tr>
                        <?php
                        if (!empty($user_uploads))
                            foreach ($user_uploads as $user_uploads) {
                                ?>
                                <tr>
                                    <td><?php echo $user_uploads['id']; ?></td>
                                    <td><?php echo $user_uploads['name']; ?></td> 
                                    <td><?php echo $user_uploads['email']; ?></td> 
                                    <td><?php echo(strlen($user_uploads['description']) > 100) ? substr($user_uploads['description'], 0, 97) . '...' : $user_uploads['description']; ?></td>
                                    <td><?php echo $user_uploads['phone_number']; ?></td>
                                    <td><?php
                                        $categories = array(
                                            1 => 'News & Issues',
                                            2 => 'Funny',
                                            3 => 'Music',
                                            4 => 'Talent',
                                            5 => 'Education',
                                            6 => 'Animals',
                                            7 => 'Sports'
                                        );
                                        echo!empty($user_uploads['category']) ? $categories[$user_uploads['category']] : '<span style="color:red">Not Assigned</span>';
                                        ?></td>
                                    <td>
                                        <a href="/index.php/admin/user_uploads/status/<?php echo $user_uploads['id'] . '/' . !$user_uploads['is_approved']; ?>"/>
                                        <?php
                                        echo ($user_uploads['is_approved'] == 1) ? "<span class='label label-success'>Approved</span>" : "<span class='label label-danger'>Rejected</span>";
                                        ?>
                                        </a>
                                    </td>

                                    <td>
                                        <a href="<?php echo base_url(); ?>index.php/admin/user_uploads/view/<?php echo $user_uploads['id']; ?>">View</a> |

                                        <a href="<?php echo base_url(); ?>index.php/admin/user_uploads/delete/<?php echo $user_uploads['id']; ?>/<?php echo ($user_uploads['is_active'] == 1) ? '0' : '1'; ?>" class="status_confirm">
                                            <?php
                                            echo ($user_uploads['is_active'] == 1) ? "Delete" : "Activate";
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
