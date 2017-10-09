<?php

if (!defined('BASEPATH'))
    exit('No direct script access allowed');

class Headlines extends MY_Controller {

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
    public $type = 'headlines';

    function __construct() {
        parent::__construct();
        $this->load->model('content', '', TRUE);
        $this->load->model('image', '', TRUE);

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

        $headlines = $this->content->get_content_by_type($this->type, $page, $current_channel['id']);

        foreach ($headlines as $value) {
            $data['headlines'][$value['content_id']] = $value;
            $data['headlines'][$value['content_id']]['image'] = $this->image->get_images_by_content_id($value['content_id']);
        }


        $content = $this->load->view($this->type . '/tabular.php', $data, true);
        $this->load->view('layout', array('content' => $content));
    }

    public function view($id) {
        $headlines = $this->content->get_content_by_id($this->type, $id);
        $data['headlines'] = $headlines[0];
        $images = $this->image->get_images_by_content_id($id);
        $thumb = $this->image->get_thumb_images_by_content_id($id);


        foreach ($images as $image) {
            $data['headlines']['images'][] = $image['path'] . $image['name'];
        }
        foreach ($thumb as $thumb_image) {
            $data['headlines']['thumb'][] = $thumb_image['path'] . $thumb_image['name'];
        }

        $content = $this->load->view($this->type . '/view.php', $data, true);

        $this->load->view('layout', array('content' => $content));
    }

    public function edit($id) {
        $current_channel = ($this->session->userdata('current_channel')) ? $this->session->userdata('current_channel') : '';
        $data['titles'] = $this->content->get_all_titles($this->type, $current_channel['id']);
        $headlines = $this->content->get_content_by_id($this->type, $id);
        $data['headlines'] = $headlines[0];
        $images = $this->image->get_images_by_content_id($id);
        $thumb = $this->image->get_thumb_images_by_content_id($id);
        foreach ($images as $image) {
            $data['headlines']['images'][] = array(
                'path' => $image['path'] . $image['name'],
                'id' => $image['image_id']
            );
        }

        foreach ($thumb as $thumb_image) {
            $data['headlines']['thumb'][] = array(
                'path' => $thumb_image['path'] . $thumb_image['name'],
                'id' => $thumb_image['image_id']
            );
        }
        $content = $this->load->view($this->type . '/edit.php', $data, true);
        $this->load->view('layout', array('content' => $content));
    }

    public function update() {

        $serialize_data = array();
        $serialize_data = !empty($_POST['headlines']['data']) ? $_POST['headlines']['data'] : '';

        $data = array(
            'title' => !empty($_POST['headlines']['title']) ? $_POST['headlines']['title'] : '',
            'start_date' => !empty($_POST['headlines']['start_date']) ? $_POST['headlines']['start_date'] : '',
            'end_date' => !empty($_POST['headlines']['end_date']) ? $_POST['headlines']['end_date'] : '',
            'description' => !empty($_POST['headlines']['description']) ? $_POST['headlines']['description'] : '',
            'detail_description' => !empty($_POST['headlines']['detail_description']) ? $_POST['headlines']['detail_description'] : '',
            'category_id' => !empty($_POST['headlines']['category_id']) ? $_POST['headlines']['category_id'] : '',
            'data' => serialize($serialize_data),
        );

        $headlines_id = $this->content->update_content_by_id($_POST['headlines']['id'], $data);
        $image_data = $this->uploadImageFile($headlines_id, $this->type);



        if ($this->uploadSuccess) {
            $this->image->add_images($image_data, TRUE, $headlines_id);
        }

        $thumb_data = $this->uploadThumbImageFile($headlines_id, $this->type);
        if ($this->uploadSuccess) {
            $this->image->add_thumb($thumb_data, TRUE, $headlines_id);
        }

        redirect(site_url('admin/' . $this->type . '/edit/' . $headlines_id));
    }

    public function addnew() {
        $current_channel = ($this->session->userdata('current_channel')) ? $this->session->userdata('current_channel') : '';
        $data['titles'] = $this->content->get_all_titles($this->type, $current_channel['id']);
        $content = $this->load->view($this->type . '/new.php', $data, true);
        $this->load->view('layout', array('content' => $content));
    }

    public function submit() {
        $serialize_data = array();
        $serialize_data = !empty($_POST['headlines']['data']) ? $_POST['headlines']['data'] : '';
        $current_channel = ($this->session->userdata('current_channel')) ? $this->session->userdata('current_channel') : '';
        $data = array(
            'title' => !empty($_POST['headlines']['title']) ? $_POST['headlines']['title'] : '',
            'start_date' => !empty($_POST['headlines']['start_date']) ? $_POST['headlines']['start_date'] : '',
            'end_date' => !empty($_POST['headlines']['end_date']) ? $_POST['headlines']['end_date'] : '',
            'description' => !empty($_POST['headlines']['description']) ? $_POST['headlines']['description'] : '',
            'channel_id' => !empty($current_channel['id']) ? $current_channel['id'] : '',
            'detail_description' => !empty($_POST['headlines']['detail_description']) ? $_POST['headlines']['detail_description'] : '',
            'category_id' => !empty($_POST['headlines']['category_id']) ? $_POST['headlines']['category_id'] : '',
            'data' => serialize($serialize_data),
        );

        $headlines_id = $this->content->add_content($data, $this->type);
        $image_data = $this->uploadImageFile($headlines_id, $this->type);

        if ($this->uploadSuccess) {
            $this->image->add_images($image_data, TRUE, $headlines_id);
        }
        $thumb_data = $this->uploadThumbImageFile($headlines_id, $this->type);
        if ($this->uploadSuccess) {
            $this->image->add_thumb($thumb_data, TRUE, $headlines_id);
        }

        redirect(site_url('admin/' . $this->type . '/view/' . $headlines_id));
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
