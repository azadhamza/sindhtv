<?php

Class Video_category extends CI_Model {

    public function get_all() {
        $current_channel = ($this->session->userdata('current_channel')) ? $this->session->userdata('current_channel') : '';
        $sql = "select * from video_category where channel_id=" . $current_channel['id'];
        $query = $this->db->query($sql);
        $result = $query->result_array();
        $query->free_result();
        return $result;
    }

    public function get_all_by_channel_id($channel_id) {
        $sql = "select * from video_category where channel_id=" . $channel_id;
        $query = $this->db->query($sql);
        $result = $query->result_array();
        $query->free_result();
        return $result;
    }

    public function get_category_name($category_id) {
        $sql = "select category from video_category where id=" . $category_id;
        $query = $this->db->query($sql);
        $result = $query->result_array();
        $query->free_result();
        return $result[0]['category'];
    }

}

?>