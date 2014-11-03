<?php

namespace Models;

class ApiResponse
{
    public $api_key = '';
    public $base_url = 'http://proapi.whitepages.com/2.0/location.json?';
    public $street_name;
    public $city_name;

    public function __construct($street_name, $city_name)
    {
        $this->street_name = $street_name;
        $this->city_name = $city_name;
    }

    public function getRequestUrl()
    {
        return  $this->base_url . 'street_line_1=' . urlencode($this->street_name) . '&city=' . urlencode($this->city_name) . '&api_key=' .  $this->api_key;
    }

    public function getJsonResonse()
    {
        $curl = curl_init($this->getRequestUrl());
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
        $curl_response = curl_exec($curl);
        if ($curl_response === false) {
            $info = curl_getinfo($curl);
            curl_close($curl);
            die('error occured during curl exec. Additioanl info: ' . var_export($info));
        }

        curl_close($curl);
        return json_decode($curl_response, true);
    }
}
