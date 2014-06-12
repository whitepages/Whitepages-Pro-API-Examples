<?php

$error = "";
$first_name = "";
$last_name = "";
$where = "";
$countPeople = "";
$arrayProple = "";
$data_type = "";
$location_urls = [];
$person_age_range = [];
$names = [];
$legalEntitieLocation = "";
$legalEntitiePersonKeys = [];
$results_person = [];


if (isset($_POST['submit'])) {
    if (!empty($_POST['first_name'])) {
        $peopleArry = array();
        $first_name = trim($_POST['first_name']);
        $last_name = trim($_POST['last_name']);
        $where = trim($_POST['where']);
        $api_key = "";
        $data_type = true;
        $service_url = 'http://proapi.whitepages.com/2.0/person.json?first_name=' . str_replace(" ", "-", $first_name) . '&last_name=' . $last_name . '&address=' . urlencode($where) . '&api_key=' . $api_key;

        $curl = curl_init($service_url);
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
        $curl_response = curl_exec($curl);

        if ($curl_response === false) {
            $info = curl_getinfo($curl);
            curl_close($curl);
            die('error occured during curl exec. Additioanl info: ' . var_export($info));
        }
        // close cURL resource, and free up system resources
        curl_close($curl);
        // json_decode — Decodes a JSON string.
        $data = json_decode($curl_response, true);
        if (count($data) != 0) {

            if (isset($data['results'])) {

                foreach ($data['results'] as $results_val) {
                    $results_person[] = $results_val;
                }
                $dictionaryData = $data['dictionary'];
                $count_obj = count($dictionaryData);

                if (count($results_person) > 0) {

                    foreach ($results_person as $resultKey => $resultVal) {

                        foreach ($dictionaryData as $dictionaryKey => $dictionaryVal) {

                            if ($resultVal == $dictionaryKey) {

                                foreach ($dictionaryVal as $sub_dict_keys => $sub_dict_vales) {

                                    if ($sub_dict_keys == "name") {
                                        $names[$resultKey] = $sub_dict_vales;
                                    }

                                    if ($sub_dict_keys == "names") {
                                        if (count($sub_dict_vales) > 0) {
                                            foreach ($sub_dict_vales as $names_key => $names_val) {
                                                $names[$resultKey] = $names_val['first_name'] . " " . $names_val['last_name'];
                                            }
                                        }
                                    }

                                    if ($sub_dict_keys == "age_range") {
                                        $person_age_range[$resultKey] = $sub_dict_vales['start'];
                                    }

                                    if ($sub_dict_keys == "locations") {
                                        if (count($sub_dict_vales) > 0) {
                                            foreach ($sub_dict_vales as $locations_key => $locations_val) {

                                                if (count($locations_val) > 0) {
                                                    foreach ($locations_val as $location_key => $location_val) {

                                                        if ($location_key == "id") {
                                                            $location_urls[$resultKey] = $location_val['url'];
                                                        }

                                                        if ($location_key == "contact_type") {
                                                            $pesson_type[$resultKey] = $location_val;
                                                        }
                                                    }
                                                }
                                            }
                                        } else {
                                            // if locations == ""   
                                        }
                                    }


                                    if ($sub_dict_keys == "best_location") {

                                        if (count($sub_dict_vales) > 0) {
                                            foreach ($sub_dict_vales as $best_location_key => $best_location_val) {
                                                if ($best_location_key == "id") {
                                                    $location_urls[$resultKey] = [];
                                                    $location_urls[$resultKey] = $best_location_val['key'];
                                                    //  $legalEntitieLocation = $best_location_val['key'];
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                if (count($location_urls) > 0) {

                    foreach ($location_urls as $key => $val) {

                        foreach ($dictionaryData as $dictionaryKey => $dictionaryVal) {

                            if ($val == $dictionaryKey) {

                                foreach ($dictionaryVal as $sub_dict_keys => $sub_dict_vales) {

                                    if ($sub_dict_keys == "city") {
                                        $location_city[$key] = $sub_dict_vales;
                                    }

                                    if ($sub_dict_keys == "postal_code") {
                                        $location_postal_code[$key] = $sub_dict_vales;
                                    }

                                    if ($sub_dict_keys == "state_code") {
                                        $location_state_code[$key] = $sub_dict_vales;
                                    }

                                    if ($sub_dict_keys == "address") {
                                        $location_address[$key] = $sub_dict_vales;
                                    }

                                    if ($sub_dict_keys == "standard_address_line1") {
                                        $standard_address_line1[$key] = $sub_dict_vales;
                                    }

                                    if ($sub_dict_keys == "standard_address_line2") {
                                        $standard_address_line2[$key] = $sub_dict_vales;
                                    }

                                    if ($sub_dict_keys == "standard_address_location") {
                                        $standard_address_location[$key] = $sub_dict_vales;
                                    }

                                    if ($sub_dict_keys == "usage") {
                                        $usage[$key] = $sub_dict_vales;
                                    }

                                    if ($sub_dict_keys == "delivery_point") {
                                        $delivery_point[$key] = $sub_dict_vales;
                                    }

                                    if ($sub_dict_keys == "is_receiving_mail") {
                                        $is_receiving_mail[$key] = $sub_dict_vales != false ? "yes" : "no";
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                $error = $data['error']['message'];
            }
        } else {
            $error = 'no records found.';
        }
    } else {
        $error = 'please enter first name.';
    }
}
?>         
