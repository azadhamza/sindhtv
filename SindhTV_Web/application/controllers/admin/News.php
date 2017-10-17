<?php

if (!defined('BASEPATH'))
    exit('No direct script access allowed');

class News extends MY_Controller {

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
    public $type = 'news';

    function __construct() {
        parent::__construct();
        $this->load->model('content', '', TRUE);
        $this->load->model('image', '', TRUE);
        $this->load->model('news_category', '', TRUE);

        if (!$this->session->userdata('logged_in')) {
            redirect(base_url());
        }
        if (!$this->session->userdata('current_channel')) {
            redirect(base_url('index.php/admin/dashboard'));
        }
    }

    public function index() {
        $data = array();
        $this->load->library("pagination");
        $current_channel = ($this->session->userdata('current_channel')) ? $this->session->userdata('current_channel') : '';

        $total_rows = $this->content->get_total_content_by_type($this->type, $current_channel['id']);
        $pagination_config = get_pagination_config($this->type . '/index', $total_rows, $this->config->item('pagination_limit'), 4);
        $this->pagination->initialize($pagination_config);
        $page = ($this->uri->segment(4)) ? $this->uri->segment(4) : 0;
        $data["links"] = $this->pagination->create_links();
        $news = $this->content->get_content_by_type($this->type, $page, $current_channel['id']);
        $data['news'] = $news;
        $news_categories = $this->news_category->get_all();
        foreach ($news_categories as $category) {
            $data['news_category'][$category['id']] = $category['category'];
        }

        $content = $this->load->view($this->type . '/tabular.php', $data, true);
        $this->load->view('layout', array('content' => $content));
    }

    public function view($id) {
        $news = $this->content->get_content_by_id($this->type, $id);
        $data['news'] = $news[0];
        $images = $this->image->get_images_by_content_id($id);
        $news_categories = $this->news_category->get_all();
        foreach ($news_categories as $category) {
            $data['news_category'][$category['id']] = $category['category'];
        }

        foreach ($images as $image) {
            $data['news']['images'][] = $image['path'] . $image['name'];
        }

        $content = $this->load->view($this->type . '/view.php', $data, true);

        $this->load->view('layout', array('content' => $content));
    }

    public function edit($id) {
        $news = $this->content->get_content_by_id($this->type, $id);
        $data['news'] = $news[0];
        $images = $this->image->get_images_by_content_id($id);
        $data['news_category'] = $this->news_category->get_all();
        foreach ($images as $image) {
            $data['news']['images'][] = array(
                'path' => $image['path'] . $image['name'],
                'id' => $image['image_id']
            );
        }
        $content = $this->load->view($this->type . '/edit.php', $data, true);
        $this->load->view('layout', array('content' => $content));
    }

    public function update() {

        $serialize_data = array();
        $serialize_data = !empty($_POST['news']['data']) ? $_POST['news']['data'] : '';
        $data = array(
            'title' => !empty($_POST['news']['title']) ? $_POST['news']['title'] : '',
            'start_date' => !empty($_POST['news']['start_date']) ? $_POST['news']['start_date'] : '',
            'end_date' => !empty($_POST['news']['end_date']) ? $_POST['news']['end_date'] : '',
            'description' => !empty($_POST['news']['description']) ? $_POST['news']['description'] : '',
            'data' => serialize($serialize_data),
        );

        $news_id = $this->content->update_content_by_id($_POST['news']['id'], $data);
        $image_data = $this->uploadImageFile($news_id, $this->type);

        if ($this->uploadSuccess) {
            $this->image->add_images($image_data);
        }

        redirect(site_url('admin/' . $this->type . '/edit/' . $news_id));
    }

    public function addnew() {
        $data = array();
        $data['news_category'] = $this->news_category->get_all();
        $content = $this->load->view($this->type . '/new.php', $data, true);

        $this->load->view('layout', array('content' => $content));
    }

    public function submit() {
        $serialize_data = array();
        $serialize_data = !empty($_POST['news']['data']) ? $_POST['news']['data'] : '';
        $current_channel = ($this->session->userdata('current_channel')) ? $this->session->userdata('current_channel') : '';

        $data = array(
            'title' => !empty($_POST['news']['title']) ? $_POST['news']['title'] : '',
            'start_date' => !empty($_POST['news']['start_date']) ? $_POST['news']['start_date'] : '',
            'end_date' => !empty($_POST['news']['end_date']) ? $_POST['news']['end_date'] : '',
            'description' => !empty($_POST['news']['description']) ? $_POST['news']['description'] : '',
            'channel_id' => !empty($current_channel['id']) ? $current_channel['id'] : '',
            'data' => serialize($serialize_data),
        );

        $news_id = $this->content->add_content($data, $this->type);
        $image_data = $this->uploadImageFile($news_id, $this->type);

        if ($this->uploadSuccess) {
            $this->image->add_images($image_data, TRUE, $news_id);
        }

        redirect(site_url('admin/' . $this->type . '/view/' . $news_id));
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
