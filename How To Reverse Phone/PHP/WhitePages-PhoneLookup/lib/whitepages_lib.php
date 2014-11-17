<?php
/**
 * Library for abstraction of methods to use Whitepages Pro API
 * @require     PHP5
 *
 * @author      Kushal Shah
 * @date        2014-06-01
 */
include 'keys.php';

class WhitepagesLib extends Exception
{
    //API Key
    private $whitepages_api_key;

    //API URL
    private $whitepages_api_url;

    //API Version
    private $whitepages_api_version;

    //Query string
    private $url;

    //Response from server
    public $response = false;


    public function __construct()
    {
        $this->whitepages_api_key = WP_API_KEY;
        $this->whitepages_api_version = '2.0';
        $this->whitepages_api_url = 'http://proapi.whitepages.com';
    }


    //API Method to find a person
    public function reverse_phone($options = array())
    {
        $this->build_url('phone', $options);
        if ($this->response) {
            return $this->response;
        }
    }

    //Build query string that will be requested by serialize parameters
    private function build_url($method, $param)
    {
        if(!isset($method) || !isset($param)) return false;
        //Check if we have a query string sta yet
        if (is_array($param)) {
            //Build query string
            $this->url = $this->whitepages_api_url . '/' . $this->whitepages_api_version  .'/'. $method .'.json?';
            foreach ($param as $key => $value) {
                $this->url .= $key .'='. urlencode($value) .'&';
            }
            //Append API key & response type
             $this->url = $this->url . 'api_key='. $this->whitepages_api_key;
            //Fetch request
            $this->get_response($this->url);
        }
    }

    //Fetch URL Request using cURL
    private function get_response($url)
    {
        $curl = curl_init($url);
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
        $curl_response = curl_exec($curl);
        try {
            if ($curl_response === false) {
                $info = curl_getinfo($curl);
                curl_close($curl);
                throw new Exception;
            }
            curl_close($curl);
            $this->response = json_decode($curl_response, true);

        } catch (Exception $exception) {
            echo "Error occured during curl exec";
        }
    }
}

