<?php

Class Stvsettings extends CI_Model {

    public function add_setting($key, $value, $channel_id) {
        $data = array(
            'value' => $value,
            'channel_id' => $channel_id
        );
        $this->db->where('key', $key);
        $this->db->update('settings', $data);
        return $key;
    }

    public function get_data($key, $channel_id) {
        $this->db->where('key', $key);
        $this->db->where('channel_id', $channel_id);
        $query = $this->db->get('settings', array('key' => $key, 'channel_id' => $channel_id));
        $result = $query->result_array();
        $query->free_result();
        if (!empty($result))
            return$result[0];
        else
            return '';
    }

}

?>