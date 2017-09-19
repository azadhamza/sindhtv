<?php
Class User extends CI_Model
{

    function login($username, $password, $is_admin)
    {
        
        $this -> db -> select('user_id, username, password');
        $this -> db -> from('users');
        $this -> db -> where('username', $username);
        $this -> db -> where('is_admin', $is_admin);
        $this -> db -> where('password', $password);
        $this -> db -> limit(1);

        $query = $this -> db -> get();
       
        if($query -> num_rows() == 1)
        {
            return $query->result();
        }
        else
        {
            return false;
        }
    }

    function checkUser($username)
    {
        $this -> db -> select('user_id, username, password');
        $this -> db -> from('users');
        $this -> db -> where('username', $username);
        //$this -> db -> where('is_admin', $is_admin);
        //$this -> db -> where('password', $password);
        $this -> db -> limit(1);

        $query = $this -> db -> get();

        if($query -> num_rows() == 1)
        {
            return $query->result();
        }
        else
        {
            return false;
        }
    }

    function checkUserById($user_id)
    {
        $this -> db -> select('user_id, username, password');
        $this -> db -> from('users');
        $this -> db -> where('user_id', $user_id);
        //$this -> db -> where('is_admin', $is_admin);
        //$this -> db -> where('password', $password);
        $this -> db -> limit(1);

        $query = $this -> db -> get();

        if($query -> num_rows() == 1)
        {
            return $query->result();
        }
        else
        {
            return false;
        }
    }

    function get_total_users()
    {
        return $this->db->count_all('users');
    }

    function get_user_detail($user_id)
    {
        $sql = "select * from users where user_id=$user_id" ;
        $query = $this->db->query($sql);
        $result = $query->result_array();
        $query->free_result();
        return $result[0];
    }

    function get_admin()
    {
        $sql = "select * from users where email='admin@danone.com'" ;
        $query = $this->db->query($sql);
        $result = $query->result_array();
        $query->free_result();
        return $result[0];
    }

    function get_users($page)
    {
        $start =  $page;
        $limit = $this->config->item('pagination_limit');
        $sql = "select * from users where is_admin=0 order by user_id desc limit $start,$limit" ;
        $query = $this->db->query($sql);
        $result = $query->result_array();
        $query->free_result();
        return $result;
    }

    function get_latest_five_parents()
    {
        $sql = "select * from users where is_admin=0 order by user_id desc limit 5";
        $query = $this->db->query($sql);
        $result = $query->result_array();
        $query->free_result();
        return $result;
    }

    function deactivate_user($user_id)
        {
        $sql = "update users set is_active=0 where user_id=$user_id";
        $query = $this->db->query($sql);

    }

    function activate_user($user_id)
    {
        $sql = "update users set is_active=1 where user_id=$user_id";
        $query = $this->db->query($sql);

    }

    function edit_user($user_id,$data)
    {
        $this->db->where('user_id', $user_id);
        $this->db->update('users',$data);
        return ($this->db->affected_rows() != 1) ? false : true;
    }

    function add_user($data)
    {
        $this->db->insert('users',$data);
        return $this->db->insert_id();
    }
}
