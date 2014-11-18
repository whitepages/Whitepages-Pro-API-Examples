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
            $location_array = array();
            while (list(, $results_val) = each($this->json_response['results'])) {
                if (!empty($results_val)) {
                    // get phone data and people ids from belongs to
                    $phone = new Phone($this->json_response['dictionary'][$results_val]);
                    $this->phone = $phone->data();
                    $belongs_to = $phone->belongs_to;
                    $person_array = array();
                    $temp_location_array = array();
                    // get people data and store it in person_array
                    // store best location id of belongs to people in temp_location_array
                    if (!empty($belongs_to)) {
                        while (list(, $belongs_val) = each($belongs_to)) {
                            $person = new Person($this->json_response['dictionary'][$belongs_val]);
                            array_push($person_array, $person->data());
                            array_push($temp_location_array, $person->best_location());
                        }
                        $temp_location_array = array_filter($temp_location_array);
                        // get location data by location_keys array.
                        if (!empty($temp_location_array)) {
                            $location_keys = array_unique($temp_location_array);
                            while (list(, $location_key) = each($location_keys)) {
                                $location = new Location($this->json_response['dictionary'][$location_key]);
                                array_push($location_array, $location->data());
                            }
                        } else {
                            // get location data from phone best location id. if belongs to location id is blank.
                            if ($phone->best_location) {
                                $location = new Location($this->json_response['dictionary'][$phone->best_location]);
                                array_push($location_array, $location->data());
                            }
                        }

                    } else {
                        if ($phone->best_location) {
                            $location = new Location($this->json_response['dictionary'][$phone->best_location]);
                            array_push($location_array, $location->data());
                        }
                    }
                    $this->people = $person_array;
                    $this->location = $location_array;
                }
            }
        }
    }

}

