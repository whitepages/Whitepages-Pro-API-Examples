<?php
/**
 * Library for abstraction of methods to use Whitepages Pro API
 * @require     PHP5
 *
 * @author      Kushal Shah
 * @date        2014-06-02
 */

include 'person.php';

class Result
{
    public $json_response;
    public $error;
    public $person;


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
            $person_array = array();
            while (list(, $results_val) = each($this->json_response['results'])) {
                if (!empty($results_val)) {
                    $person = new Person($this->json_response['dictionary'][$results_val]);
                    $best_location = $person->best_location();
                    if (!empty($best_location)) {
                        $person->location($this->json_response['dictionary'][$best_location]);
                    }
                    array_push($person_array, $person->data());
                }
            }
            $this->person = $person_array;
        }
    }

}

