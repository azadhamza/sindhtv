<?php

if (!defined('BASEPATH'))
    exit('No direct script access allowed');

class Videos extends MY_Controller {

    /**
     * Index Page for this controller.
     *
     * Maps to the following URL
     * 		http://example.com/index.php/welcome
     * 	- or -
     * 		http://example.com/index.php/welcome/index
     * 	- or -
     * Since this controller is set as the default controller in
     * config/routes.php, it's displayed at http://example.com/
     *
     * So any other public methods not prefixed with an underscore will
     * map to /index.php/welcome/<method_name>
     * @see http://codeigniter.com/user_guide/general/urls.html
     */
    public $type = 'videos';

    function __construct() {
        parent::__construct();
        $this->load->model('content', '', TRUE);
        $this->load->model('image', '', TRUE);
        $this->load->model('video_category', '', TRUE);
        
        if (!$this->session->userdata('logged_in')) {
            redirect(base_url());
        }
        if (!$this->session->userdata('current_channel')) {
            redirect(base_url('index.php/admin/dashboard'));
        }
    }

    public function index() {
        $data = array();
        $current_channel = ($this->session->userdata('current_channel')) ? $this->session->userdata('current_channel') : '';

        $this->load->library("pagination");
        $total_rows = $this->content->get_total_content_by_type($this->type, $current_channel['id']);

        $pagination_config = get_pagination_config($this->type . '/index', $total_rows, $this->config->item('pagination_limit'), 4);

        $this->pagination->initialize($pagination_config);

        $page = ($this->uri->segment(4)) ? $this->uri->segment(4) : 0;

        $data["links"] = $this->pagination->create_links();

        $videos = $this->content->get_content_by_type($this->type, $page, $current_channel['id']);
        $data['videos'] = $videos;
        $video_categories = $this->video_category->get_all();
        foreach ($video_categories as $category) {
            $data['video_category'][$category['id']] = $category['category'];
        }
        $content = $this->load->view($this->type . '/tabular.php', $data, true);
        $this->load->view('layout', array('content' => $content));
    }

    public function view($id) {
        $videos = $this->content->get_content_by_id($this->type, $id);
        $data['videos'] = $videos[0];
        $images = $this->image->get_images_by_content_id($id);
        $video_categories = $this->video_category->get_all();
        foreach ($video_categories as $category) {
            $data['video_category'][$category['id']] = $category['category'];
        }
        foreach ($images as $image) {
            $data['videos']['images'][] = $image['path'] . $image['name'];
        }

        $content = $this->load->view($this->type . '/view.php', $data, true);

        $this->load->view('layout', array('content' => $content));
    }

    public function edit($id) {
        $videos = $this->content->get_content_by_id($this->type, $id);
        $data['videos'] = $videos[0];
        $images = $this->image->get_images_by_content_id($id);
        $data['video_category'] = $this->video_category->get_all();
        foreach ($images as $image) {
            $data['videos']['images'][] = array(
                'path' => $image['path'] . $image['name'],
                'id' => $image['image_id']
            );
        }
        $content = $this->load->view($this->type . '/edit.php', $data, true);
        $this->load->view('layout', array('content' => $content));
    }

    public function update() {

        $serialize_data = array();
        $serialize_data = !empty($_POST['videos']['data']) ? $_POST['videos']['data'] : '';

        $data = array(
            'title' => !empty($_POST['videos']['title']) ? $_POST['videos']['title'] : '',
            'start_date' => !empty($_POST['videos']['start_date']) ? $_POST['videos']['start_date'] : '',
            'end_date' => !empty($_POST['videos']['end_date']) ? $_POST['videos']['end_date'] : '',
            'description' => !empty($_POST['videos']['description']) ? $_POST['videos']['description'] : '',
            'data' => serialize($serialize_data),
        );

        $videos_id = $this->content->update_content_by_id($_POST['videos']['id'], $data);
        $image_data = $this->uploadImageFile($videos_id, $this->type);

        if ($this->uploadSuccess) {
            $this->image->add_images($image_data);
        }

        redirect(site_url('admin/' . $this->type . '/edit/' . $videos_id));
    }

    public function addnew() {
        $data['video_category'] = $this->video_category->get_all();
        $content = $this->load->view($this->type . '/new.php', $data, true);
        $this->load->view('layout', array('content' => $content));
    }

    public function submit() {
        $serialize_data = array();
        $serialize_data = !empty($_POST['videos']['data']) ? $_POST['videos']['data'] : '';
        $current_channel = ($this->session->userdata('current_channel')) ? $this->session->userdata('current_channel') : '';
        $data = array(
            'title' => !empty($_POST['videos']['title']) ? $_POST['videos']['title'] : '',
            'start_date' => !empty($_POST['videos']['start_date']) ? $_POST['videos']['start_date'] : '',
            'end_date' => !empty($_POST['videos']['end_date']) ? $_POST['videos']['end_date'] : '',
            'description' => !empty($_POST['videos']['description']) ? $_POST['videos']['description'] : '',
            'channel_id' => !empty($current_channel['id']) ? $current_channel['id'] : '',
            'data' => serialize($serialize_data),
        );

        $videos_id = $this->content->add_content($data, $this->type);
        $image_data = $this->uploadImageFile($videos_id, $this->type);

        if ($this->uploadSuccess) {
            $this->image->add_images($image_data);
        }

        redirect(site_url('admin/' . $this->type . '/view/' . $videos_id));
    }

    public function delete($id, $status, $view = NULL) {
        $flag = $this->content->delete_content($id, $status);
//        $this->image->delete_content_images($id);
//        if (empty($view)) {
        redirect(site_url('admin/' . $this->type . '/index'));
//        } else {
//            redirect(site_url('admin/' . $this->type . '/view/' . $id));
//        }
    }

    public function delete_image($id, $content_id) {
        $this->image->deactivate_image($id);

        redirect(site_url('admin/' . $this->type . '/edit/' . $content_id));
    }

    public function status($id, $status = 0) {
        $this->content->change_status($id, $status);
        redirect(site_url('admin/' . $this->type));
    }

}
