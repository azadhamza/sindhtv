
<!-- Main content -->

<section class="content">
    <div class="row  col-xs-12">
        <div class="col-xs-6">
            <div class="box box-primary">



                <form action="" method="post" >
                    <div class="table-responsive">
                        <table class="table">
                            <tbody>
                                <tr>
                                    <td colspan="2">            <p class="lead col-xs-6">User Upload # <?php echo ucfirst($user_upload['id']); ?></p>
                                    </td>

                                </tr>
                                <tr>
                                    <th>Title:</th>
                                    <td><?php echo $user_upload['name']; ?></td>
                                </tr>
                                <tr>
                                    <th>Phone Number:</th>
                                    <td><?php echo $user_upload['phone_number']; ?></td>
                                </tr>
                                <tr>
                                    <th>Email</th>
                                    <td><?php echo $user_upload['email']; ?></td>
                                </tr>

                                <tr>
                                    <th>File</th>
                                    <td><a target="_blank" href="<?php echo!empty($user_upload['file']) ? base_url() . $user_upload['file'] : '#'; ?>">Click Here</a></td>
                                </tr>
                                <tr>
                                    <th>Category</th>
                                    <td>
                                        <div class="form-group">
                                            <?php
                                            $categories = array(
                                                1 => 'News & Issues',
                                                2 => 'Funny',
                                                3 => 'Music',
                                                4 => 'Talent',
                                                5 => 'Education',
                                                6 => 'Animals',
                                                7 => 'Sports'
                                            );
                                            ?>
                                            <input type="hidden" value="<?php echo $user_upload['id']; ?>" name="id"/>
                                            <select name="category" class="form-control">
                                                <option value="">Choose a Category:</option>
                                                <?php foreach ($categories as $key => $value) { ?>
                                                    <option value="<?php echo $key; ?>" <?php echo ($user_upload['category'] == $key) ? 'selected' : ''; ?>><?php echo $value; ?></option>
                                                <?php } ?>

                                            </select>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th>Description</th>
                                    <td><?php echo $user_upload['description']; ?></td>
                                </tr>
                            </tbody></table>

                        <div class="box-footer">
                            <button type="submit" class="btn btn-primary">Submit</button>
                        </div>
                    </div>
                </form>

            </div>
        </div>

    </div>
</section><!-- /.content -->
