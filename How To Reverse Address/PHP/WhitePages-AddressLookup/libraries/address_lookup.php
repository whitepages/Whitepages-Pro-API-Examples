<?php
include 'whitepages_lib.php';
include 'address.php';

if (isset($_POST['submit'])) {
    if (!empty($_POST['street_line_1'])) {
        if (!empty($_POST['city'])) {
            $param = array(
                'street_line_1' => trim($_POST['street_line_1']),
                'city' => trim($_POST['city'])
            );
            $whitepages_obj = new Libraries\WhitepagesLib();
            $response = $whitepages_obj->findAddress($param);
            if ($response) {
                if (!empty($response['error'])) {
                    $error = $response['error']['message'];
                } else {
                    $person_obj = new Libraries\Address($response);
                    $result_data = $person_obj->formattedResult();
                }
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

