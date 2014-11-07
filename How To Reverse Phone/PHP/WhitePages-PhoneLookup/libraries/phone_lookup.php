<?php
include 'whitepages_lib.php';
include 'phone.php';

if (isset($_POST['submit'])) {
    if (!empty($_POST['phone'])) {
        $param = array(
            'phone' => trim($_POST['phone'])
        );
        $whitepages_obj = new Libraries\WhitepagesLib();
        $response = $whitepages_obj->reversePhone($param);
        if (!empty($response['error'])) {
            $error = $response['error']['message'];
        } elseif (!empty($response['results'])) {
            $person_obj = new Libraries\Phone($response);
            $result_data = $person_obj->formattedResult();
        } else {
            $error = 'No records found';
        }
    } else {
        $error = 'Please enter phone number';
    }
}

