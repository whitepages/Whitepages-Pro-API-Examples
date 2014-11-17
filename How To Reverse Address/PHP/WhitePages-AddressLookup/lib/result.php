<?php
/**
 * Library for abstraction of methods to use Whitepages Pro API
 * @require     PHP5
 *
 * @author      Kushal Shah
 * @date        2014-06-02
 */

include 'location.php';

class Result
{
    public $json_response;
    public $error;
    public $location;


    public function __construct($json_response)
    {
        $this->json_response = $json_response;
        $this->data_parse();
    }

    public function data_parse()
    {
        if (!empty($this->json_response['error'])) {
            $this->error = $this->json_response['error']['message'];
        } else {
            $location_array = array();
            while (list(, $results_val) = each($this->json_response['results'])) {
                if (!empty($results_val)) {
                    $location = new Location($this->json_response['dictionary'][$results_val]);
                    $legal_entities = $location->legal_entities_at();
                    $legal_entities_array = array();
                    if (!empty($legal_entities)) {
                        while (list(, $results_val) = each($legal_entities)) {
                            array_push($legal_entities_array, $location->legal_entity($this->json_response['dictionary'][$results_val]));
                        }
                    }
                    $location->legal_entities_at = $legal_entities_array;
                }

                array_push($location_array, $location->data());
            }
            $this->location = $location_array;
        }
    }
}

