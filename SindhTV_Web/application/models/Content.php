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

    public function get_video_by_category($category_id, $channel_id) {
        $sql = "SELECT content.content_id,title,description,detail_description,`data`,modified_time,category,video_category.id, 
                    (SELECT CONCAT(`path`,`name`) FROM  image WHERE is_thumb = 0  AND content_id  =  content.content_id limit 0,1) as video,
                    (SELECT CONCAT(`path`,`name`) FROM  image WHERE is_thumb = 1  AND content_id  =  content.content_id limit 0,1) as thumb            
                    FROM content
                    LEFT JOIN video_category
                    ON category_id=id
                  
                    WHERE content_type_id =
                    (
                            SELECT content_type_id FROM content_type
                            WHERE content = 'videos'
                    )  AND content.channel_id = $channel_id AND category_id = $category_id

                    ORDER BY title ";
        $query = $this->db->query($sql);
        $result = $query->result_array();
        $query->free_result();
        return $result;
    }

    public function get_headlines($channel_id) {
        $sql = "SELECT *,(SELECT CONCAT(`path`,`name`) FROM  image WHERE is_thumb = 0  AND content_id  =  content.content_id limit 0,1) as video,
                (SELECT CONCAT(`path`,`name`) FROM  image WHERE is_thumb = 1  AND content_id  =  content.content_id limit 0,1) as thumb
                 FROM content 
                WHERE content_type_id =
                 (SELECT content_type_id FROM content_type WHERE content = 'headlines' )

                AND channel_id = $channel_id
                ORDER BY title ";
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
//                var_dump($data); exit;
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

    public function get_all_titles($type, $channel_id) {
        $sql = "SELECT title FROM content WHERE channel_id = $channel_id AND content_type_id =
                (
                        SELECT content_type_id FROM content_type
                        WHERE content = '$type'
                )";
        $query = $this->db->query($sql);
        $result = $query->result_array();
        $query->free_result();
        return $result;
    }

    public function get_all_news($channel_id) {
        $sql = "SELECT * FROM content WHERE channel_id = $channel_id AND modified_time  >= DATE_SUB(NOW(), INTERVAL 1 MONTH)";
        $query = $this->db->query($sql);
        $result = $query->result_array();
        $query->free_result();
        if (!empty($result)) {
            foreach ($result as $value) {
                $this->db->where('is_active', 1);
                $query = $this->db->get_where('image', array('content_id' => $value['content_id']));
                $image = $query->result_array();
                $query->free_result();

                $ser_data = unserialize($value['data']);
                $news[] = array(
                    'content_id' => $value['content_id'],
                    'title' => $value['title'],
                    'modified_time' => $value['modified_time'],
                    'category' => !empty($ser_data['category']) ? $ser_data['category'] : '',
                    'description' => $value['description'],
                    'data' => unserialize($value['data']),
                    'image' => !empty($image) ? $image[0]['path'] . $image[0]['name'] : ''
                );
            }
            uasort($news, array($this, 'cmp'));
            return $news;
        }
        return $result;
    }

    private static function cmp($a, $b) {
        return $a['category'] > $b['category'] ? 1 : -1;
    }

}

?>