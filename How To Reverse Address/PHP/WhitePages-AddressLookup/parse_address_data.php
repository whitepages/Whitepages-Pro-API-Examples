<?php

$street_line_1 = "";
$city = "";
$standard_address_line1 = "";
$standard_address_line2 = "";
$standard_address_location = "";
$usage = "";
$delivery_point = "";
$is_receiving_mail = "";
$countPeople = "";
$arrayProple = "";
$data_type = "";
$legal_person_key = [];
$related_names = [];
$related_age_range_start = [];

if (isset($_POST['submit'])) {
    if (!empty($_POST['street_line_1'])) {
        $peopleArry = array();
        $street_line_1 = trim($_POST['street_line_1']);
        $city = trim($_POST['city']);
        $api_key = "";
        $data_type = true;
        $service_url = 'http://proapi.whitepages.com/2.0/location.json?street_line_1=' . urlencode($street_line_1) . '&city=' . urlencode($city) . '&api_key=' . $api_key;
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
        if (isset($data['results'])) {
            foreach ($data['results'] as $results_val) {
                $results_location = $results_val;
            }

            $dictionaryData = $data['dictionary'];
            $count_obj = count($dictionaryData);
            foreach ($dictionaryData as $dictionaryKey => $dictionaryVal) {

                if ($results_location == $dictionaryKey) {

                    foreach ($dictionaryVal as $sub_dict_keys => $sub_dict_vales) {

//                        if ($sub_dict_keys == "id") {
//                            $phone_id_key = $sub_dict_vales['key'];
//                            $phone_id_url = $sub_dict_vales['url'];
//                        }
                        if ($sub_dict_keys == "type") {
                            $location_type = $sub_dict_vales;
                        }

                        if ($sub_dict_keys == "legal_entities_at") {

                            if (count($sub_dict_vales) != 0) {
                                foreach ($sub_dict_vales as $sub_belongs_keys) {

                                    foreach ($sub_belongs_keys as $sub_belongs_key1 => $sub_belongs_val1) {

                                        if ($sub_belongs_key1 == 'id') {

                                            $legal_person_key[] = $sub_belongs_val1['key'];
                                        }
                                    }
                                }
                            }
                        } 

                        if ($sub_dict_keys == "city") {
                            $location_city = $sub_dict_vales;
                        }

                        if ($sub_dict_keys == "standard_address_line1") {
                            $standard_address_line1 = $sub_dict_vales;
                        }
                        if ($sub_dict_keys == "standard_address_line2") {
                            $standard_address_line2 = $sub_dict_vales;
                        }
                        if ($sub_dict_keys == "standard_address_location") {
                            $standard_address_location = $sub_dict_vales;
                        }

                        if ($sub_dict_keys == "address") {
                            $address = $sub_dict_vales;
                        }
                        if ($sub_dict_keys == "usage") {
                            $usage = $sub_dict_vales;
                        }

                        if ($sub_dict_keys == "is_receiving_mail") {
                            $is_receiving_mail = $sub_dict_vales != false ? "Yes" : "No";
                        }

                        if ($sub_dict_keys == "delivery_point") {
                            $delivery_point = $sub_dict_vales;
                        }
                    }
                }
            }
        } else {
            $error = $data['error']['message'];
        }

        if (count($legal_person_key) > 0) {
            foreach ($legal_person_key as $bKey => $bVal) {


                foreach ($dictionaryData as $dicKey => $dicVal) {

                    if ($dicKey == $bVal) {



                        if (count($dicVal) > 0) {
                            foreach ($dicVal as $belongs_users_key => $belongs_users_val) {

//                                if ($belongs_users_key == "id") {
//                                    foreach ($belongs_users_val as $id_key => $id_val) {
//                                        if ($id_key == "type") {
//                                            $contact_types[] = $id_val;
//                                        }
//                                    }
//                                }
                                if ($belongs_users_key == "name") {

                                    $related_names[] = $belongs_users_val;
                                }


                                if ($belongs_users_key == "names") {

                                    if (count($belongs_users_val) > 0) {
                                        foreach ($belongs_users_val as $names_key => $names_val) {
                                            $related_names[] = $names_val['first_name'] . " " . $names_val['last_name'];
                                        }
                                    }
                                }


                                if ($belongs_users_key == "age_range") {
                                    $related_age_range_start[] = $belongs_users_val['start'];
                                }
                                if ($belongs_users_key == "locations") {
                                    if (count($belongs_users_val) > 0) {
                                        foreach ($belongs_users_val as $locations_key => $locations_val) {

                                            if (count($locations_val) > 0) {
                                                foreach ($locations_val as $location_key => $location_val) {

                                                    if ($location_key == "id") {
                                                        $location_urls[] = $location_val['url'];
                                                    }
                                                     if ($location_key == "contact_type") {
                                                     $contact_types[] = $location_val;
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
                            }
                        }
                    }
                }
            }
        }
    } else {
        $error = 'please enter your address details.';
    }
}
?>         
