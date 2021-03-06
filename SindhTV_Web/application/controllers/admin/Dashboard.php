<?php

if (!defined('BASEPATH'))
    exit('No direct script access allowed');

class Dashboard extends CI_Controller {

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
    function __construct() {
        parent::__construct();
        $this->load->model('channels', '', TRUE);
        if (!$this->session->userdata('logged_in')) {
            redirect(base_url());
        }
    }

    public function index() {
        $data = array();
        $data['channels'] = $this->channels->get_all_channels();
        $data = $content = $this->load->view('dashboard/index.php', $data, true);
        $this->load->view('layout', array('content' => $content));
    }

    public function select($id) {
        $data = array();
        $data['channel'] = $this->channels->get_all_channel_by_id($id);
        $this->session->set_userdata('current_channel', $data['channel']);
        redirect(base_url() . "index.php/admin/dashboard");
    }

}
