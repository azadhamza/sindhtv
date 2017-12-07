<?php

if (!defined('BASEPATH'))
    exit('No direct script access allowed');

class User_uploads extends MY_Controller {

    function __construct() {
        parent::__construct();

        $this->load->model('user_upload', '', TRUE);

        if (!$this->session->userdata('logged_in')) {
            redirect(base_url());
        }
        if (!$this->session->userdata('current_channel')) {
            redirect(base_url('index.php/admin/dashboard'));
        }
    }

    function index() {
        $data = array();
        $this->load->library("pagination");
        $current_channel = ($this->session->userdata('current_channel')) ? $this->session->userdata('current_channel') : '';

        $total_rows = $this->user_upload->get_total_user_uploads($current_channel['id']);
        $pagination_config = get_pagination_config('user_uploads/index', $total_rows, $this->config->item('pagination_limit'), 4);
        $this->pagination->initialize($pagination_config);
        $page = ($this->uri->segment(4)) ? $this->uri->segment(4) : 0;
        $data["links"] = $this->pagination->create_links();
        $user_uploads = $this->user_upload->get_user_uploads($page, $current_channel['id']);
        $data['user_uploads'] = $user_uploads;

        $content = $this->load->view('user_uploads/tabular.php', $data, true);
        $this->load->view('layout', array('content' => $content));
    }

    public function status($id, $status = 0) {
        $this->user_upload->change_status($id, $status);
        redirect(site_url('admin/user_uploads'));
    }

    public function delete($id, $status, $view = NULL) {
        $flag = $this->user_upload->delete_content($id, $status);
        redirect(site_url('admin/user_uploads/index'));
    }

    public function view($id) {
        $data = $data_save = array();

        if (!empty($_POST)) {
            $data_save['category'] = $_POST['category'];
            $this->user_upload->update_categort($_POST['id'],$data_save);
        }

        $data['user_upload'] = $this->user_upload->get_user_upload_by_id($id);


        $content = $this->load->view('user_uploads/view.php', $data, true);

        $this->load->view('layout', array('content' => $content));
    }

}
