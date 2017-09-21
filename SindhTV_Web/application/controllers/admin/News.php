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

        if (!$this->session->userdata('logged_in')) {
            redirect(base_url());
        }
    }

    public function index() {
        $data = array();
        $this->load->library("pagination");
        $total_rows = $this->content->get_total_content_by_type($this->type);
        
        $pagination_config = get_pagination_config($this->type . '/index', $total_rows, $this->config->item('pagination_limit'), 4);

        $this->pagination->initialize($pagination_config);

        $page = ($this->uri->segment(4)) ? $this->uri->segment(4) : 0;

        $data["links"] = $this->pagination->create_links();

        $news = $this->content->get_content_by_type($this->type, $page);
        $data['news'] = $news;
        $content = $this->load->view($this->type . '/tabular.php', $data, true);
        $this->load->view('layout', array('content' => $content));
    }

    public function view($id) {
        $news = $this->content->get_content_by_id($this->type, $id);
        $data['news'] = $news[0];
        $images = $this->image->get_images_by_content_id($id);

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
        $serialize_data = $_POST['news']['data'];
        $data = array(
            'title' => $_POST['news']['title'],
            'start_date' => $_POST['news']['start_date'],
            'end_date' => $_POST['news']['end_date'],
            'description' => $_POST['news']['description'],
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
        $content = $this->load->view($this->type . '/new.php', $data = NULL, true);
        $this->load->view('layout', array('content' => $content));
    }

    public function submit() {
        $serialize_data = array();
        $serialize_data = $_POST['news']['data'];

        $data = array(
            'title' => $_POST['news']['title'],
            'start_date' => $_POST['news']['start_date'],
            'end_date' => $_POST['news']['end_date'],
            'description' => $_POST['news']['description'],
            'data' => serialize($serialize_data),
        );

        $news_id = $this->content->add_content($data, $this->type);
        $image_data = $this->uploadImageFile($news_id, $this->type);

        if ($this->uploadSuccess) {
            $this->image->add_images($image_data);
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

}
