<?php

function userdata( $key, $val = null ){
  $ci = &get_instance();
  if ( $val !== null ){
    $ci->session->set_userdata( $key, $val );
  } else {
    return $ci->session->userdata( $key );
  }
}

function object2array($object)
{
    return json_decode(json_encode($object), TRUE);
}

function debug($value,$die=false)
{
	echo '<pre>';
	if(is_array($value) || is_object($value))
			print_r($value);
	else
			echo $value;
	echo '</pre>';
	if($die==true)
			die;
}

function get_lat_long($address)
{
  $Address = urlencode($address);//"30 Sheikh Zayed Rd - Dubai, United Arab Emirates"
  $request_url = "http://maps.googleapis.com/maps/api/geocode/xml?address=".$Address."&sensor=true";
  $xml = simplexml_load_file($request_url) or die("url not loading");
  $status = $xml->status;
  if ($status=="OK") {
      $arr = object2array($xml);
      return $arr['result']['geometry']['location'];

  }
  else
    return false;
}

function asset_url($uri)
{
	$CI =& get_instance();
	return $CI->config->base_url('assets/'.$uri);
}

//to generate an image tag, set tag to true. you can also put a string in tag to generate the alt tag
function asset_img($uri)
{

		return asset_url('img/'.$uri);


}

function asset_js($uri)
{

		return asset_url('js/'.$uri);

}

//you can fill the tag field in to spit out a link tag, setting tag to a string will fill in the media attribute
function asset_css($uri)
{

	return asset_url('css/'.$uri);
}

//to generate an image tag, set tag to true. you can also put a string in tag to generate the alt tag
function admin_asset_img($uri)
{

		return asset_url('admin/img/'.$uri);


}

function admin_asset_js($uri)
{

		return asset_url('admin/js/'.$uri);

}

//you can fill the tag field in to spit out a link tag, setting tag to a string will fill in the media attribute
function admin_asset_css($uri)
{

	return asset_url('admin/css/'.$uri);
}

function dateDiff($time1, $time2, $precision = 6) {
    // If not numeric then convert texts to unix timestamps
    if (!is_int($time1)) {
      $time1 = strtotime($time1);
    }
    if (!is_int($time2)) {
      $time2 = strtotime($time2);
    }

    // If time1 is bigger than time2
    // Then swap time1 and time2
    if ($time1 > $time2) {
      $ttime = $time1;
      $time1 = $time2;
      $time2 = $ttime;
    }

    // Set up intervals and diffs arrays
    $intervals = array('year','month','day','hour','minute','second');
    $diffs = array();

    // Loop thru all intervals
    foreach ($intervals as $interval) {
      // Set default diff to 0
      $diffs[$interval] = 0;
      // Create temp time from time1 and interval
      $ttime = strtotime("+1 " . $interval, $time1);
      // Loop until temp time is smaller than time2
      while ($time2 >= $ttime) {
	$time1 = $ttime;
	$diffs[$interval]++;
	// Create new temp time from time1 and interval
	$ttime = strtotime("+1 " . $interval, $time1);
      }
    }

    $count = 0;
    $times = array();
    // Loop thru all diffs
    foreach ($diffs as $interval => $value) {
      // Break if we have needed precission
      if ($count >= $precision) {
	break;
      }
      // Add value and interval
      // if value is bigger than 0
      if ($value > 0) {
	// Add s if value is not 1
	if ($value != 1) {
	  $interval .= "s";
	}
	// Add value and interval to times array
	$times[] = $value . " " . $interval;
	$count++;
      }
    }

    array_pop($times);
    $time_string = implode(", ", $times);
    $time_string = str_replace(array('years','year'),'y',$time_string);
    $time_string = str_replace(array('months','month'),'m',$time_string);
    $time_string = str_replace(array('days','day'),'d',$time_string);
    $time_string = str_replace(array('hours','hour'),'h',$time_string);
    $time_string = str_replace(array('minutes','minute'),'min',$time_string);
    $time_string = str_replace(array('days','day'),'d',$time_string);
    return $time_string;
    // Return string with times
    //return implode(", ", $times);
  }

function xml_to_array($deXml,$main_heading = '') {
    //$deXml = simplexml_load_string($xml);
    $deJson = json_encode($deXml);
    $xml_array = json_decode($deJson,TRUE);
    if (! empty($main_heading)) {
        $returned = $xml_array[$main_heading];
        return $returned;
    } else {
        return $xml_array;
    }

	}

  function get_pagination_config($url, $total, $pagination_limit, $uri_segment)
  {
      $config = array();
      $config["base_url"] = base_url() . "index.php/admin/$url";
      $config["total_rows"] = $total;
      $config["per_page"] = $pagination_limit;
      $config["uri_segment"] = $uri_segment;
      $choice = $config["total_rows"] / $config["per_page"];
      $config["num_links"] = floor($choice);


      //config for bootstrap pagination class integration
      $config['full_tag_open'] = '<ul class="pagination">';
      $config['full_tag_close'] = '</ul>';
      $config['first_link'] = false;
      $config['last_link'] = false;
      $config['first_tag_open'] = '<li>';
      $config['first_tag_close'] = '</li>';
      $config['prev_link'] = '&laquo';
      $config['prev_tag_open'] = '<li class="prev">';
      $config['prev_tag_close'] = '</li>';
      $config['next_link'] = '&raquo';
      $config['next_tag_open'] = '<li>';
      $config['next_tag_close'] = '</li>';
      $config['last_tag_open'] = '<li>';
      $config['last_tag_close'] = '</li>';
      $config['cur_tag_open'] = '<li class="active"><a href="#">';
      $config['cur_tag_close'] = '</a></li>';
      $config['num_tag_open'] = '<li>';
      $config['num_tag_close'] = '</li>';

      return $config;
  }

  function doCurl($url, $options = array())
  {
      $headers = isset($options['headers']) && is_array($options['headers']) ? $options['headers'] : null;
      // Initialize cURL
      $ch = curl_init();
      curl_setopt($ch, CURLOPT_URL, $url);
      curl_setopt($ch, CURLOPT_HEADER, 0);
      curl_setopt($ch, CURLOPT_POST, 0);
      if(isset($options['post']))
      {
        unset($options['post']);
        curl_setopt($ch, CURLOPT_POST, TRUE);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $options);  
      }  
      //curl_setopt($ch, CURLOPT_POSTFIELDS, $postData);
      curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
      curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0);
      curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);

      if (!empty($headers)) {
      //debug($headers);
          curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
      }

      $response_json = curl_exec($ch);
      //debug(curl_error($ch));
      //debug(curl_getinfo($ch));
      curl_close($ch);

      return $response_json;
  }

  