<?php

Class User_upload extends CI_Model {

    public function save_data($data) {
        if ($this->db->insert('user_upload', $data)) {
            return TRUE;
        } else {
            return FALSE;
        }
    }

    public function get_total_user_uploads($channel_id) {
        $sql = "SELECT count(*) as count FROM user_upload
                WHERE  is_active=1 AND channel_id= " . $channel_id;
        $query = $this->db->query($sql);
        $result = $query->result_array();
        $query->free_result();
        return $result[0]['count'];
    }

    public function get_user_uploads($page = 0, $channel_id) {
        $sql = "select * from user_upload 
                where  is_active = 1 AND channel_id= " . $channel_id;


        if ($page >= 0) {
            $start = $page;
            $limit = $this->config->item('pagination_limit');
            $sql .=" limit $start,$limit";
        }

        $query = $this->db->query($sql);
        $result = $query->result_array();
        $query->free_result();
        return $result;
    }

    public function change_status($id, $status) {
        $this->db->where('id', $id);
        $this->db->update('user_upload', array('is_approved' => $status));
    }

    public function delete_content($id, $status) {
        $this->db->where('id', $id);
        $this->db->update('user_upload', array('is_active' => $status));
    }

    public function get_user_upload_by_id($id) {
        $this->db->where('id', $id);
        $query = $this->db->get('user_upload');
        $result = $query->result_array();
        $query->free_result();
        return $result[0];
    }

    public function update_categort($id, $data) {
        $this->db->where('id', $id);
        $this->db->update('user_upload', $data);
        return;
    }

    public function get_all_videos($channel_id) {
        $sql = 'SELECT * FROM user_upload WHERE channel_id   =  ' . $channel_id . '  and   is_approved    =   1  ORDER BY category';
        $query = $this->db->query($sql);
        $result = $query->result_array();
        $query->free_result();
        return $result;
    }

}

?>