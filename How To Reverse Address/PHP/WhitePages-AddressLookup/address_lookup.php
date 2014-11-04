<?php
include 'models/whitepages_lib.php';
include 'models/address.php';

if (isset($_POST['submit'])) {
    if (!empty($_POST['street_line_1'])) {
        if (!empty($_POST['city'])) {
            $param = array('street_line_1' => trim($_POST['street_line_1']), 'city' => trim($_POST['city']));
            $whitepages_obj = new Models\WhitepagesLib();
            $whitepages_obj->find_address($param);

            if (!empty($whitepages_obj->response['error'])) {
                $error = $whitepages_obj->response['error']['message'];
            } elseif (!empty($whitepages_obj->response['results'])) {
                $address_obj = new Models\Address($whitepages_obj->response);
                $address_obj->formattedResult();
                $result_data = $address_obj->resultData;
            } else {
                $error = 'No records found';
            }
        } else {
            $error = 'Please enter city and state or zip.';
        }
    } else {
        $error = 'Please enter your address details.';
    }
}

