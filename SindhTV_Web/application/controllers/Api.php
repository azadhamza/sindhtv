<?php

if (!defined('BASEPATH'))
    exit('No direct script access allowed');
require(APPPATH . '/libraries/REST_Controller.php');

class Api extends REST_Controller {

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
        $this->load->model('content', '', TRUE);
        $this->load->model('image', '', TRUE);
        $this->load->model('channels', '', TRUE);

    }

    public function index() {
        
    }

    public function config() {
        $data = array();
        $channels = $this->channels->get_all_channels();
        $data['type'] = 1;
        foreach ($channels as $value) {
            $data['items'][] = array(
                'channel_id' => $value['id'],
                'channel_thumb' => base_url() . $value['image'],
                'channel_name' => $value['title']
            );
        }

        $data['application'] = array(
            "application_id" => "2",
            "application_logo" => base_url() . "/assets/images/application_logo.jpg",
            "application_bg" => base_url() . "/assets/images/app_bg.jpg",
            "application_name" => "Sindh TV Network",
            "menu_bgcolr" => "#cc0000",
            "menu_scolor" => "#ffffff",
            "menu_ucolor" => "#1c4587",
            "menu_acolor" => "#1c4587",
            "list_bgcolor" => "#cc4a86e8",
            "menu_tcolor" => "#ffffff",
            "list_tcolor" => "#ffffff",
            "playstore_ios" => "http=>//poovee.net/",
            "playstore_android" => "http=>//poovee.net/",
            "banner_code" => "/104753804/Mobile_Banner",
            "interstitial_code" => "/104753804/mobile_banner_interstitial",
            "banner_code_ios" => "/104753804/Mobile_Banner",
            "interstitial_code_ios" => "/104753804/mobile_banner_interstitial"
        );
        echo json_encode($data);
    }

    public function menu_config() {
        $data = array(
            "about_url" => base_url() . "/view/about",
            "contact_url" => "http://www.thesindh.tv/entertainment/contact/appcontact.html",
            "epaper_url" => "http://dailyjeejal.com/epaper/",
            "menubg" => "#000000",
            "program_url" => "http://www.thesindh.tv/program.html",
            "type" => 1,
        );
        $data['items'] = array(
            array(
                "is_listmenu" => 0,
                "menu_icon" => base_url() . "/assets/images/menu/article_menu.png",
                "menu_id" => 7,
                "menu_name" => "News",
            ),
            array(
                "is_listmenu" => 0,
                "menu_icon" => base_url() . "/assets/images/menu/live_menu.png",
                "menu_id" => 1,
                "menu_name" => "LIVE MOBILE TV",
            ),
            array(
                "is_listmenu" => 0,
                "menu_icon" => base_url() . "/assets/images/menu/headline_menu.png",
                "menu_id" => 3,
                "menu_name" => "Headlines",
            ),
            array(
                "is_listmenu" => 0,
                "menu_icon" => base_url() . "/assets/images/menu/videos_menu.png",
                "menu_id" => 10,
                "menu_name" => "Videos",
            ),
            array(
                "is_listmenu" => 1,
                "menu_icon" => base_url() . "/assets/images/menu/about.png",
                "menu_id" => 12,
                "menu_name" => "About",
            ),
            array(
                "is_listmenu" => 1,
                "menu_icon" => base_url() . "/assets/images/menu/settings.png",
                "menu_id" => 13,
                "menu_name" => "Setting",
            ),
            array(
                "is_listmenu" => 1,
                "menu_icon" => base_url() . "/assets/images/menu/appshare_menu.png",
                "menu_id" => 8,
                "menu_name" => "Share",
            ),
            array(
                "is_listmenu" => 1,
                "menu_icon" => base_url() . "/assets/images/menu/userupload_menu.png",
                "menu_id" => 9,
                "menu_name" => "User Upload",
            ),
            array(
                "is_listmenu" => 1,
                "menu_icon" => base_url() . "/assets/images/menu/contact_icon.png",
                "menu_id" => 15,
                "menu_name" => "Contact Us",
            ),
            array(
                "is_listmenu" => 1,
                "menu_icon" => base_url() . "/assets/images/menu/program_icon.png",
                "menu_id" => 16,
                "menu_name" => "Programs",
            ),
        );
        $this->response($data, 200);
    }

}
