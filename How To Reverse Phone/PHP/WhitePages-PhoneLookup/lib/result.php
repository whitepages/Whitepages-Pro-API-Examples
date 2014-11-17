<?php
/**
 * Library for abstraction of methods to use Whitepages Pro API
 * @require     PHP5
 *
 * @author      Kushal Shah
 * @date        2014-06-02
 */

include 'phone.php';
include 'person.php';
include 'location.php';

class Result
{
    public $json_response;
    public $error;
    public $phone;
    public $people;
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
            while (list(, $results_val) = each($this->json_response['results'])) {
                if (!empty($results_val)) {
                    $phone = new Phone($this->json_response['dictionary'][$results_val]);
                    $this->phone = $phone->data();
                    $belongs_to = $phone->belongs_to;
                    $person_array = array();
                    $location_array = array();
                    if (!empty($belongs_to)) {
                        while (list(, $belongs_val) = each($belongs_to)) {
                            $person = new Person($this->json_response['dictionary'][$belongs_val]);
                            array_push($person_array, $person->data());
                            $best_location = $person->best_location();
                            if (!empty($best_location)) {
                                $location = new Location($this->json_response['dictionary'][$best_location]);
                                array_push($location_array, $location->data());
                            }
                        }
                    }
                    $this->people = $person_array;
                    $this->location = $location_array;
                }
            }
        }
    }

}

