<?php
include 'whitepages_lib.php';
include 'address.php';

if (isset($_POST['submit'])) {
    if (!empty($_POST['street_line_1'])) {
        if (!empty($_POST['city'])) {
            $param = array('street_line_1' => trim($_POST['street_line_1']), 'city' => trim($_POST['city']));
            $whitepages_obj = new Libraries\WhitepagesLib();
            $whitepages_obj->findAddress($param);
            if (!empty($whitepages_obj->response['error'])) {
                $error = $whitepages_obj->response['error']['message'];
            } elseif (!empty($whitepages_obj->response['results'])) {
                $address_obj = new Libraries\Address($whitepages_obj->response);
                $result_data = $address_obj->formattedResult();
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

