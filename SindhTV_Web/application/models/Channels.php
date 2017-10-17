<?php

Class Channels extends CI_Model {

    public function get_all_channels() {
        $sql = "select * from channels";
        $query = $this->db->query($sql);
        $result = $query->result_array();
        $query->free_result();
        return $result;
    }

    public function get_all_channel_by_id($id) {
        $sql = "select * from channels where id = ".$id;
        $query = $this->db->query($sql);
        $result = $query->result_array();
        $query->free_result();
        return $result[0];
    }

}

?>