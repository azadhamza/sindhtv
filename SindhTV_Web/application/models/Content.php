<?php

Class Content extends CI_Model {

    function get_total_contents() {
        return $this->db->count_all('content');
    }

    function get_latest_five_by_type($type) {
        $sql = "select * from content
            WHERE content_type_id =
            (
                    SELECT content_type_id FROM content_type
                    WHERE content = '$type'
                    order by content_id desc limit 5
            )";

        $query = $this->db->query($sql);
        $result = $query->result_array();
        $query->free_result();
        return $result;
    }

    function get_total_content_by_type($type, $channel_id) {

        $sql = "SELECT count(*) as count FROM content
                WHERE content_type_id =
                (
                        SELECT content_type_id FROM content_type
                        WHERE content = '$type'
                ) AND is_active=1 AND channel_id= " . $channel_id;
        $query = $this->db->query($sql);
        $result = $query->result_array();
        $query->free_result();
        return $result[0]['count'];
    }

    function get_content_by_type_api($type) {

        $sql = "select c.*,ct.content as content_type_name from content c
                inner join content_type ct on ct.content_type_id=c.content_type_id 
                where ct.content = '$type'
                 #AND c.is_active = 1";


        $query = $this->db->query($sql);
        $result = $query->result_array();
        $query->free_result();
        return $result;
    }

    function get_content_by_type($type, $page = 0, $channel_id) {
        // $sql = "select * from content
        //     WHERE content_type_id =
        //     (
        //             SELECT content_type_id FROM content_type
        //             WHERE content = '$type'
        //     )";

        $sql = "select c.*,ct.content as content_type_name from content c
                inner join content_type ct on ct.content_type_id=c.content_type_id 
                where ct.content = '$type'
                 AND c.is_active = 1 AND channel_id= " . $channel_id;


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

    public function get_content_data($id) {
        $sql = "select * from content where content_id=$id";
        $query = $this->db->query($sql);
        $result = $query->result_array();
        $query->free_result();
        return $result;
    }

    public function get_content_by_id($type, $id) {
        $sql = "SELECT * FROM content
                WHERE content_type_id =
                (
                        SELECT content_type_id FROM content_type
                        WHERE content = '$type'
                ) AND content_id = $id limit 1";
        $query = $this->db->query($sql);
        $result = $query->result_array();
        $query->free_result();
        return $result;
    }

    public function update_content_by_id($id, $data) {
        $this->db->where('content_id', $id);
        $this->db->update('content', $data);
        return $id;
    }

    function get_contents($page) {
        $start = $page;
        $limit = $this->config->item('pagination_limit');

        $sql = "select * from content limit $start,$limit";
        $query = $this->db->query($sql);
        $result = $query->result_array();
        $query->free_result();
        return $result;
    }

    public function add_content($data, $type) {
        $this->db->select('content_type_id');
        $this->db->from('content_type');
        $this->db->where('content', $type);
        $query = $this->db->get();
        $result = $query->result_array();
        $query->free_result();
        $content_id = $result[0]['content_type_id'];
        $data['content_type_id'] = $content_id;

        $this->db->insert('content', $data);
        return $this->db->insert_id();
    }

    public function delete_content($id, $status) {
        $this->db->where('content_id', $id);
        $this->db->update('content', array('is_active' => $status));
    }

    public function change_status($id, $status) {
        $this->db->where('content_id', $id);
        $this->db->update('content', array('is_approved' => $status));
    }
    

}

?>