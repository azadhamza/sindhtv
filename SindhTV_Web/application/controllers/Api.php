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
        $this->load->model('news_category', '', TRUE);
        $this->load->model('video_category', '', TRUE);
    }

    public function index() {
        
    }

    public function config_get() {
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
            "application_logo" => base_url() . "assets/images/application_logo.jpg",
            "application_bg" => base_url() . "assets/images/app_bg.jpg",
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
        $this->response($data, 200);
    }

    public function video_categories_get($id) {
        $categories = $this->video_category->get_all_by_channel_id($id);
        foreach ($categories as $value) {
            $data['items'] [] = array(
                "menu_icon" => (!empty($value['icon'])) ? base_url() . $value['icon'] : '',
                "menu_id" => $value['id'],
                "menu_name" => $value['category'],
            );
        }
        $data["menubg"] = "#000000";
        $data ["type"] = 1;
        $this->response($data, 200);
    }

    public function menu_config_get() {

        $data = array(
            "about_url" => "http://sindhtvnews.net/app_pages/about.html",
            "contact_url" => "http://sindhtvnews.net/app_pages/contact.html",
            "epaper_url" => "http://dailyjeejal.com/epaper/",
            "menubg" => "#000000",
            "program_url" => "http://sindhtvnews.net/app_pages/sindhtv_program.html",
            "type" => 1,
        );
        $data['items'] = array(
            array(
                "is_listmenu" => 0,
                "menu_icon" => base_url() . "assets/images/menu/article_menu.png",
                "menu_id" => 7,
                "menu_name" => "News",
            ),
            array(
                "is_listmenu" => 0,
                "menu_icon" => base_url() . "assets/images/menu/live_menu.png",
                "menu_id" => 1,
                "menu_name" => "LIVE MOBILE TV",
            ),
            array(
                "is_listmenu" => 0,
                "menu_icon" => base_url() . "assets/images/menu/headline_menu.png",
                "menu_id" => 3,
                "menu_name" => "Headlines",
            ),
            array(
                "is_listmenu" => 0,
                "menu_icon" => base_url() . "assets/images/menu/videos_menu.png",
                "menu_id" => 10,
                "menu_name" => "Videos",
            ),
            array(
                "is_listmenu" => 1,
                "menu_icon" => base_url() . "assets/images/menu/about.png",
                "menu_id" => 12,
                "menu_name" => "About",
            ),
            array(
                "is_listmenu" => 1,
                "menu_icon" => base_url() . "assets/images/menu/settings.png",
                "menu_id" => 13,
                "menu_name" => "Setting",
            ),
            array(
                "is_listmenu" => 1,
                "menu_icon" => base_url() . "assets/images/menu/appshare_menu.png",
                "menu_id" => 8,
                "menu_name" => "Share",
            ),
            array(
                "is_listmenu" => 1,
                "menu_icon" => base_url() . "assets/images/menu/userupload_menu.png",
                "menu_id" => 9,
                "menu_name" => "User Upload",
            ),
            array(
                "is_listmenu" => 1,
                "menu_icon" => base_url() . "assets/images/menu/contact_icon.png",
                "menu_id" => 15,
                "menu_name" => "Contact Us",
            ),
            array(
                "is_listmenu" => 1,
                "menu_icon" => base_url() . "assets/images/menu/program_icon.png",
                "menu_id" => 16,
                "menu_name" => "Programs",
            ),
        );
        $this->response($data, 200);
    }

    public function news_get($channel_id) {
        $data = array();
        $news_arr[] = array();

        $news_categories = $this->news_category->get_all_api();
        foreach ($news_categories as $category) {
            $nc['news_category'][$category['id']] = $category['category'];
        }
        $news = $this->content->get_all_news($channel_id);
        if (!empty($news)) {
            foreach ($news as $value) {
                $news_arr[$nc['news_category'][$value['category']]][] = array(
                    'content_id' => $value['content_id'],
                    'title' => $value['title'],
                    'description' => $value['description'],
                    'image' => $value['image'],
                    'created_date' => $value['modified_time'],
                );
            }
        }
        $count = 0;
        foreach ($news_arr as $key => $final) {

            $data['items'][$count]['date'] = $key;
            foreach ($final as $value) {
                $data['items'][$count]['videos'][] = array(
                    "adsviews" => 0,
                    "duration" => 0,
                    "thumb" => $value['image'],
                    "time-ago" => $this->time_elapsed_string($value['created_date']),
                    "title" => $value['title'],
                    "videoid" => 634,
                    "views" => 0,
                    "webview_url" => base_url() . "view/news/" . $value['content_id']
                );
                $count++;
            }
        }
        $this->response($data, 200);
    }

    public function time_elapsed_string($datetime, $full = false) {
        $now = new DateTime;
        $ago = new DateTime($datetime);
        $diff = $now->diff($ago);

        $diff->w = floor($diff->d / 7);
        $diff->d -= $diff->w * 7;

        $string = array(
            'y' => 'year',
            'm' => 'month',
            'w' => 'week',
            'd' => 'day',
            'h' => 'hour',
            'i' => 'minute',
            's' => 'second',
        );
        foreach ($string as $k => &$v) {
            if ($diff->$k) {
                $v = $diff->$k . ' ' . $v . ($diff->$k > 1 ? 's' : '');
            } else {
                unset($string[$k]);
            }
        }

        if (!$full)
            $string = array_slice($string, 0, 1);
        return $string ? implode(', ', $string) . ' ago' : 'just now';
    }

}
