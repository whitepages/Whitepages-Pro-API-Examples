<?php

$error = "";
$location_address = "";
$phone_id_key = "";
$phone_id_url = "";
$phone_line_type = "";
$belongs_to_key = [];
$location_urls = [];
$names = [];
$belongs_to_url = "";
$phone_phone_number = "";
$phone_country_calling_code = "";
$phone_carrier = "";
$phone_do_not_call = "";
$phone_spam_score = "";
$best_location_key = "";
$best_location_url = [];
$contact_type = "";
$delivery_point = "";
$is_receiving_mail = "";
$usage = "";
$data_type = "";
$req_phone_number = "";
$contact_types = [];
$results_phone = [];

if (isset($_POST['submit'])) {
    if (!empty($_POST['phone'])) {
        $req_phone_number = trim($_POST['phone']);
        $api_key = "";
        $data_type = true;
        $service_url = 'http://proapi.whitepages.com/2.0/phone.json?phone=' . urlencode($req_phone_number) . '&api_key=' . $api_key;
        //cURL is a library that lets you make HTTP requests in PHP.
        //curl_init — Initialize a cURL session.
        $curl = curl_init($service_url);
        //Set URL we want to load
        //CURLOPT_RETURNTRANSFER: TRUE to return the transfer as a string of the return value of curl_exec().
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
        // grab URL and pass it to the browser
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
//                echo "<pre>";
//                print_r($data); 

        if (isset($data['results'])) {

            foreach ($data['results'] as $results_val) {
                $results_phone[] = $results_val;
            }
            $dictionaryData = $data['dictionary'];
            $count_obj = count($dictionaryData);

            if (count($results_phone) > 0) {
                foreach ($results_phone as $resultKey => $resultVal) {



                    foreach ($dictionaryData as $dictionaryKey => $dictionaryVal) {


                        if ($resultVal == $dictionaryKey) {


                            foreach ($dictionaryVal as $sub_dict_keys => $sub_dict_vales) {

                                if ($sub_dict_keys == "line_type") {
                                    $phone_line_type = $sub_dict_vales;
                                }

                                if ($sub_dict_keys == "belongs_to") {

                                    if (count($sub_dict_vales) != 0) {
                                        foreach ($sub_dict_vales as $sub_belongs_keys) {

                                            foreach ($sub_belongs_keys as $sub_belongs_key1 => $sub_belongs_val1) {

                                                if ($sub_belongs_key1 == 'id') {

                                                    $belongs_to_key[] = $sub_belongs_val1['key'];  //person key
                                                }
                                            }
                                        }
                                    }
                                }



                                if ($sub_dict_keys == "phone_number") {
                                    $phone_phone_number = $sub_dict_vales;
                                }

                                if ($sub_dict_keys == "country_calling_code") {
                                    $phone_country_calling_code = $sub_dict_vales;
                                }

                                if ($sub_dict_keys == "carrier") {
                                    $phone_carrier = $sub_dict_vales;
                                }

                                if ($sub_dict_keys == "do_not_call") {
                                    $phone_do_not_call = $sub_dict_vales != false ? "Registered" : "Not Registered";
                                }

                                if ($sub_dict_keys == 'reputation') {
                                    $phone_spam_score = $sub_dict_vales['spam_score'];
                                }

                                if ($sub_dict_keys == "best_location") {
                                    if (count($sub_dict_vales) != 0) {
                                        foreach ($sub_dict_vales as $sub_best_location_keys) {
                                            //$best_location_key = $sub_best_location_keys['key'];
                                            $location_urls[] = $sub_best_location_keys['key'];
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }


            if (count($belongs_to_key) > 0) {
                foreach ($belongs_to_key as $bKey => $bVal) {
                    foreach ($dictionaryData as $dicKey => $dicVal) {
                        if ($dicKey == $bVal) {

                            if (count($dicVal) > 0) {
                                foreach ($dicVal as $belongs_users_key => $belongs_users_val) {

                                    if ($belongs_users_key == "id") {
                                        foreach ($belongs_users_val as $id_key => $id_val) {
                                            if ($id_key == "type") {
                                                $contact_types[] = $id_val;
                                            }
                                        }
                                    }
                                    if ($belongs_users_key == "name") {

                                        $names[] = $belongs_users_val;
                                    }
                                    if ($belongs_users_key == "names") {

                                        if (count($belongs_users_val) > 0) {
                                            foreach ($belongs_users_val as $names_key => $names_val) {
                                                $names[] = $names_val['first_name'] . " " . $names_val['last_name'];
                                            }
                                        }
                                    }
                                    if ($belongs_users_key == "age_range") {
                                        //todo   
                                    }
                                    if ($belongs_users_key == "locations") {
                                        if (count($belongs_users_val) > 0) {
                                            foreach ($belongs_users_val as $locations_key => $locations_val) {

                                                if (count($locations_val) > 0) {
                                                    foreach ($locations_val as $location_key => $location_val) {

                                                        if ($location_key == "id") {
                                                            $location_urls[] = $location_val['key'];
                                                        }
                                                    }
                                                }
                                            }
                                        } else {
                                            // if locations == ""   
                                        }
                                    }
                                    if ($belongs_users_key == "phones") {
                                        //todo
                                    }
                                    if ($belongs_users_key == "best_name") {
                                        $names = [];
                                        $names[] = $belongs_users_val;
                                    }

                                    if ($belongs_users_key == "best_location") {

                                        if (count($belongs_users_val) > 0) {
                                            foreach ($belongs_users_val as $best_location_key => $best_location_val) {
                                                if ($best_location_key == "id") {
                                                    $location_urls = [];
                                                    $location_urls[] = $best_location_val['key'];
                                                }
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
        $error = 'please enter phone number';
    }
}
?>         
