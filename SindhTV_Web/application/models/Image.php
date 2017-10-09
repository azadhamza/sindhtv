<?php

Class Image extends CI_Model {

    function get_total_images() {
        return $this->db->count_all('image');
    }

    function add_images($data, $replaced = FALSE, $id = NULL) {
        foreach ($data as $image) {
            if ($replaced) {
                $deactive = array('is_active' => 0);
                $this->db->where('content_id', $id);
                $this->db->where('is_thumb', 0);
                $this->db->update('image', $deactive);
            }
            $this->db->insert('image', $image);
        }
    }

    function add_thumb($data, $replaced = FALSE, $id = NULL) {
        foreach ($data as $image) {
            if ($replaced) {
                $deactive = array('is_active' => 0);
                $this->db->where('content_id', $id);
                $this->db->where('is_thumb', 1);
                $this->db->update('image', $deactive);
            }
            $this->db->insert('image', $image);
        }
    }

    function get_images_by_content_id($content_id) {
        $this->db->where('is_active', 1);
        $this->db->where('is_thumb', 0);

        $query = $this->db->get_where('image', array('content_id' => $content_id));
        $result = $query->result_array();
        $query->free_result();
        return $result;
    }

    function get_thumb_images_by_content_id($content_id) {
        $this->db->where('is_active', 1);
        $this->db->where('is_thumb', 1);
        $query = $this->db->get_where('image', array('content_id' => $content_id));
        $result = $query->result_array();
        $query->free_result();
        return $result;
    }

    function get_images_by_page_id($page_id) {
        $this->db->where('is_active', 1);
        $this->db->where('is_thumb', 0);
        $query = $this->db->get_where('image', array('page_id' => $page_id));
        $result = $query->result_array();
        $query->free_result();
        return $result;
    }

    function delete_image($id) {
        return $this->db->delete('image', array('image_id' => $id));
    }

    function deactivate_image($id) {
        $data = array(
            'is_active' => 0
        );

        $this->db->where('image_id', $id);
        $this->db->update('image', $data);
    }

    function delete_content_images($content_id) {
        $this->db->where('content_id', $content_id);
        $this->db->delete('image');
    }

    function add_single_images($content_id, $image_data) {
        $this->db->where('content_id', $content_id);
        $this->db->update('image', array('is_active' => 0));

        $this->db->insert('image', $image_data);
    }

}

?>