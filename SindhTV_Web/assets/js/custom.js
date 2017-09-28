$(document).ready(function () {

    jQuery('.video').on('change', function () {
        var sel = jQuery(this).val();
        if (sel == 'link') {
            jQuery('.link-sec').show();
            jQuery('.upload-sec').hide();
        } else if (sel == 'upload') {
            jQuery('.link-sec').hide();
            jQuery('.upload-sec').show();
        }
    });
    
    $(document).on('change', '#singleimage', function () {
        files = this.files;
        size = files[0].size;
        //max size 512kb => 50*1000
        if (size > 512 * 1000) {
            alert('Please upload less than 512KB file');
            this.value = null;
            return false;

        }
        return true;
    });


    counter = function () {
        var value = $('#notification_short_description').val();

        if (value.length == 0) {
            $('#totalChars').html(0);
            return;
        }

        var totalChars = value.length;
        $('#totalChars').html(totalChars);

    };

    $(document).ready(function () {
        $('#count').click(counter);
        $('#notification_short_description').change(counter);
        $('#notification_short_description').keydown(counter);
        $('#notification_short_description').keypress(counter);
        $('#notification_short_description').keyup(counter);
        $('#notification_short_description').blur(counter);
        $('#notification_short_description').focus(counter);
    });

    $("#search_images").click(function ()
    {
        if (jQuery("#club_members_gallery").valid() == true) {


            $("#search_images").attr("disabled", "disabled");
            $("#searched_images").empty().append('<img id="loader" src="' + BASE_URL + '/assets/img/loader_loading.gif">');
            $.ajax({
                type: "POST",
                url: BASE_URL + "index.php/admin/members_galleries/search_instagram_images/" + $("#search_tag").val(),
                dataType: "text",
                cache: false,
                success:
                        function (data) {
                            $("#searched_images").empty().append(data);  //as a debugging message.
                            $("#search_images").removeAttr("disabled");
                        }
            });// you have missed this bracket
            return false;
        }
    });




    $('#filter').on('change', function () {
        var slug = $('#filter').val();
        window.location.href = slug;
    });



    $(function () {
        var addDiv = $('#news_input_div');
        var i = $('#news_input_div div.newpacket').length + 1;

        $('#addnews').on('click', function (e) {
            if (i < 6) {
                e.preventDefault();
                $('<div class="input-group margin newpacket" id="">' +
                        '<input type="text" class="form-control" name="page[data][news][]">' +
                        '<span class="input-group-btn">' +
                        '<button class="btn removenews btn-danger btn-flat" type="button"><i class="glyphicon glyphicon-remove"></i></button>' +
                        '</span>' +
                        '</div>').appendTo(addDiv);

                $('.removenews').on('click', function () {
                    $(this).parents('div.newpacket').remove();
                });

                i++;
            }
            return false;
        });

        $('.removenews').on('click', function () {
            $(this).parents('div.newpacket').remove();
        });
    });


    $(function () {
        var addDiv = $('#professional-div');
        var i = $('#professional-div div.professional-packet').length + 1;

        $('#addnew-professional').on('click', function (e) {
            if (i < 99999) {
                e.preventDefault();
                $('<div class="row border-bottom professional-packet">' +
                        '<div class="col-lg-4">' +
                        '<div class="input-group">' +
                        '<label>Fitness Professional</label>' +
                        '<input type="text" class="form-control" name="page[data][gym][' + i + '][professional]">' +
                        '</div>' +
                        '</div>' +
                        '<div class="col-lg-4">' +
                        '<div class="input-group">' +
                        '<label>Specialized</label>' +
                        '<input type="text" class="form-control" name="page[data][gym][' + i + '][specialized]">' +
                        '</div>' +
                        '</div>' +
                        '<span class="input-group-btn col-lg-2" style="margin-top: 25px;">' +
                        '<button class="btn remove-professional btn-danger btn-flat" type="button"><i class="glyphicon glyphicon-remove"></i></button>' +
                        '</span>' +
                        '</div>').appendTo(addDiv);

                $('.remove-professional').on('click', function () {
                    $(this).parents('div.professional-packet').remove();
                });

                i++;
            }
            return false;
        });

        $('.remove-professional').on('click', function () {
            $(this).parents('div.professional-packet').remove();
        });
    });






    $(".status_confirm").on('click', function (e) {
        var r = confirm("Are you sure you want to delete?");
        if (r == true) {

        } else {
            e.preventDefault();
        }

    });




    $(".delete_anything").on('click', function (e) {
        var r = confirm("Are you sure you want to delete?");
        if (r == true) {

        } else {
            e.preventDefault();
        }

    });

    $("textarea").attr('rows', '10');

    $('textarea').not("#notification_short_description").wysihtml5({
        "image": false
    });


//
//    $('#input1').filer();
//
//    $('.file_input').filer({
//        showThumbs: true,
//        templates: {
//            box: '<ul class="jFiler-item-list"></ul>',
//            item: '<li class="jFiler-item">\
//                            <div class="jFiler-item-container">\
//                                <div class="jFiler-item-inner">\
//                                    <div class="jFiler-item-thumb">\
//                                        <div class="jFiler-item-status"></div>\
//                                        <div class="jFiler-item-info">\
//                                            <span class="jFiler-item-title"><b title="{{fi-name}}">{{fi-name | limitTo: 25}}</b></span>\
//                                        </div>\
//                                        {{fi-image}}\
//                                    </div>\
//                                    <div class="jFiler-item-assets jFiler-row">\
//                                        <ul class="list-inline pull-left">\
//                                            <li><span class="jFiler-item-others">{{fi-icon}} {{fi-size2}}</span></li>\
//                                        </ul>\
//                                        <ul class="list-inline pull-right">\
//                                            <li><a class="icon-jfi-trash jFiler-item-trash-action"></a></li>\
//                                        </ul>\
//                                    </div>\
//                                </div>\
//                            </div>\
//                        </li>',
//            itemAppend: '<li class="jFiler-item">\
//                            <div class="jFiler-item-container">\
//                                <div class="jFiler-item-inner">\
//                                    <div class="jFiler-item-thumb">\
//                                        <div class="jFiler-item-status"></div>\
//                                        <div class="jFiler-item-info">\
//                                            <span class="jFiler-item-title"><b title="{{fi-name}}">{{fi-name | limitTo: 25}}</b></span>\
//                                        </div>\
//                                        {{fi-image}}\
//                                    </div>\
//                                    <div class="jFiler-item-assets jFiler-row">\
//                                        <ul class="list-inline pull-left">\
//                                            <span class="jFiler-item-others">{{fi-icon}} {{fi-size2}}</span>\
//                                        </ul>\
//                                        <ul class="list-inline pull-right">\
//                                            <li><a class="icon-jfi-trash jFiler-item-trash-action"></a></li>\
//                                        </ul>\
//                                    </div>\
//                                </div>\
//                            </div>\
//                        </li>',
//            progressBar: '<div class="bar"></div>',
//            itemAppendToEnd: true,
//            removeConfirmation: true,
//            _selectors: {
//                list: '.jFiler-item-list',
//                item: '.jFiler-item',
//                progressBar: '.bar',
//                remove: '.jFiler-item-trash-action',
//            }
//        },
//        addMore: true,
//        files: [{
//                name: "appended_file.jpg",
//                size: 5453,
//                type: "image/jpg",
//                file: "http://dummyimage.com/158x113/f9f9f9/191a1a.jpg",
//            }, {
//                name: "appended_file_2.png",
//                size: 9503,
//                type: "image/png",
//                file: "http://dummyimage.com/158x113/f9f9f9/191a1a.png",
//            }]
//    });
//
//    $('#input2').filer({
//        limit: null,
//        maxSize: 0.5,
//        extensions: null,
//        changeInput: '<div class="jFiler-input-dragDrop"><div class="jFiler-input-inner"><div class="jFiler-input-icon"><i class="icon-jfi-cloud-up-o"></i></div><div class="jFiler-input-text"><h3>Upload Images here</h3> <span style="display:inline-block; margin: 15px 0"></span></div><a class="jFiler-input-choose-btn blue">Browse</a></div></div>',
//        showThumbs: true,
//        appendTo: null,
//        theme: "dragdropbox",
//        templates: {
//            box: '<ul class="jFiler-item-list"></ul>',
//            item: '<li class="jFiler-item">\
//                            <div class="jFiler-item-container">\
//                                <div class="jFiler-item-inner">\
//                                    <div class="jFiler-item-thumb">\
//                                        <div class="jFiler-item-status"></div>\
//                                        <div class="jFiler-item-info">\
//                                            <span class="jFiler-item-title"><b title="{{fi-name}}">{{fi-name | limitTo: 25}}</b></span>\
//                                        </div>\
//                                        {{fi-image}}\
//                                    </div>\
//                                    <div class="jFiler-item-assets jFiler-row">\
//                                        <ul class="list-inline pull-left">\
//                                            <li>{{fi-progressBar}}</li>\
//                                        </ul>\
//                                        <ul class="list-inline pull-right">\
//                                            <li><a class="icon-jfi-trash jFiler-item-trash-action"></a></li>\
//                                        </ul>\
//                                    </div>\
//                                </div>\
//                            </div>\
//                        </li>',
//            itemAppend: '<li class="jFiler-item">\
//                            <div class="jFiler-item-container">\
//                                <div class="jFiler-item-inner">\
//                                    <div class="jFiler-item-thumb">\
//                                        <div class="jFiler-item-status"></div>\
//                                        <div class="jFiler-item-info">\
//                                            <span class="jFiler-item-title"><b title="{{fi-name}}">{{fi-name | limitTo: 25}}</b></span>\
//                                        </div>\
//                                        {{fi-image}}\
//                                    </div>\
//                                    <div class="jFiler-item-assets jFiler-row">\
//                                        <ul class="list-inline pull-left">\
//                                            <span class="jFiler-item-others">{{fi-icon}} {{fi-size2}}</span>\
//                                        </ul>\
//                                        <ul class="list-inline pull-right">\
//                                            <li><a class="icon-jfi-trash jFiler-item-trash-action"></a></li>\
//                                        </ul>\
//                                    </div>\
//                                </div>\
//                            </div>\
//                        </li>',
//            progressBar: '<div class="bar"></div>',
//            itemAppendToEnd: false,
//            removeConfirmation: false,
//            _selectors: {
//                list: '.jFiler-item-list',
//                item: '.jFiler-item',
//                progressBar: '.bar',
//                remove: '.jFiler-item-trash-action',
//            }
//        },
//        uploadFile: {
//            url: BASE_URL + "assets/php/upload.php",
//            data: {},
//            type: 'POST',
//            enctype: 'multipart/form-data',
//            beforeSend: function () {
//            },
//            success: function (data, el) {
//                var parent = el.find(".jFiler-jProgressBar").parent();
//                el.find(".jFiler-jProgressBar").fadeOut("slow", function () {
//                    $("<div class=\"jFiler-item-others text-success\"><i class=\"icon-jfi-check-circle\"></i> Success</div>").hide().appendTo(parent).fadeIn("slow");
//                });
//            },
//            error: function (el) {
//                var parent = el.find(".jFiler-jProgressBar").parent();
//                el.find(".jFiler-jProgressBar").fadeOut("slow", function () {
//                    $("<div class=\"jFiler-item-others text-error\"><i class=\"icon-jfi-minus-circle\"></i> Error</div>").hide().appendTo(parent).fadeIn("slow");
//                });
//            },
//            statusCode: {},
//            onProgress: function () {
//            },
//        },
//        dragDrop: {
//            dragEnter: function () {
//            },
//            dragLeave: function () {
//            },
//            drop: function () {
//            },
//        },
//        addMore: true,
//        clipBoardPaste: true,
//        excludeName: null,
//        beforeShow: function () {
//            return true
//        },
//        onSelect: function () {
//        },
//        afterShow: function () {
//        },
//        onRemove: function () {
//        },
//        onEmpty: function () {
//        },
//        captions: {
//            button: "Choose Files",
//            feedback: "Choose files To Upload",
//            feedback2: "files were chosen",
//            drop: "Drop file here to Upload",
//            removeConfirmation: "Are you sure you want to remove this file?",
//            errors: {
//                filesLimit: "Only {{fi-limit}} files are allowed to be uploaded.",
//                filesType: "Only Images are allowed to be uploaded.",
//                filesSize: "{{fi-name}} is too large! Please upload file up to {{fi-maxSize}} MB.",
//                filesSizeAll: "Files you've choosed are too large! Please upload files up to {{fi-maxSize}} MB."
//            }
//        }
//    });
});