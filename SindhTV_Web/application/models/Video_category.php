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

}

?>