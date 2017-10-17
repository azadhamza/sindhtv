<?php

if (!defined('BASEPATH'))
    exit('No direct script access allowed');

class Live_stream extends MY_Controller {

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
        $this->load->model('stvsettings', '', TRUE);

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
        $data['live_stream_link']  = $this->stvsettings->get_data('live_stream_link', $current_channel['id']);
        $data['live_stream_thumb']  = $this->stvsettings->get_data('live_stream_thumb', $current_channel['id']);
        
        $content = $this->load->view('live_stream/form.php', $data, true);
        $this->load->view('layout', array('content' => $content));
    }

    public function submit() {
        $data = array();
        $current_channel = ($this->session->userdata('current_channel')) ? $this->session->userdata('current_channel') : '';

        $key = $this->stvsettings->add_setting('live_stream_link', $_POST['settings']['live_stream_link'], $current_channel['id']);
        $thumb_data = $this->uploadThumbImageFile($key, 'settings');
        if ($this->uploadSuccess) {
            $this->stvsettings->add_setting('live_stream_thumb', $thumb_data[0]['path'] . $thumb_data[0]['name'], $current_channel['id']);
        }
        redirect(base_url('index.php/admin/live_stream'));
    }

}
