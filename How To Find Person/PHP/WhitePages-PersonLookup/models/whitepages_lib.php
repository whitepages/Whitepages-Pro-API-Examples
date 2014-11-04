<?php

namespace Models;

class WhitepagesLib
{
    /**
     * API Key
     */
    private $whitepages_api_key;

    /**
     * API URL
     */
    private $whitepages_api_url;

    /**
     * API Version
     */
    private $whitepages_api_version;

    /**
     * Query string
     */
    private $url;

    /**
     * Response from server
     */
    public $response;

    public function __construct()
    {
        $this->whitepages_api_key = '';
        $this->whitepages_api_version = '2.0';
        $this->whitepages_api_url = 'http://proapi.whitepages.com';
    }


    /**
     * API Method to find a person
     */
    public function find_person( $options = array() ) {

        $this->_build('person',$options);
        if($this->response)
            return $this->response;

        return FALSE;
    }

    /**
     * Build query string that will be requested by serialize parameters
     */
    private function _build( $method, $param ) {

        if(!isset($method) || !isset($param)) return FALSE;

        //Check if we have a query string sta yet
        if( is_array($param) ){
            //Build query string
            $this->url = $this->whitepages_api_url . '/' . $this->whitepages_api_version  .'/'. $method .'.json?';
            foreach ($param as $key => $value) {
                $this->url .= $key .'='. urlencode($value) .'&';
            }
            //Append API key & response type
            $this->url = $this->url . 'api_key='. $this->whitepages_api_key;
            //Fetch request
            $this->_get($this->url);
        }

    }

    /**
     * Fetch URL Request using cURL
     */
    private function _get( $url ) {

        $curl = curl_init($url);
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
        $curl_response = curl_exec($curl);
        if ($curl_response === false) {
            $info = curl_getinfo($curl);
            curl_close($curl);
            die('error occured during curl exec. Additioanl info: ' . var_export($info));
        }

        curl_close($curl);
        $this->response = json_decode($curl_response, true);
        return TRUE;
    }
}

