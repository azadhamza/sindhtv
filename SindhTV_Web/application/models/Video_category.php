<?php

Class Video_category extends CI_Model {

    public function get_all() {
        $sql = "select * from video_category";
        $query = $this->db->query($sql);
        $result = $query->result_array();
        $query->free_result();
        return $result;
    }
}

?>