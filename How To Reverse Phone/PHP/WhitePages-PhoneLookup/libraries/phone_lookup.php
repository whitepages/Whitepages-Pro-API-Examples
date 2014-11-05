<?php
include 'whitepages_lib.php';
include 'phone.php';

if (isset($_POST['submit'])) {
    if (!empty($_POST['phone'])) {
        $param = array('phone' => trim($_POST['phone']));
        $whitepages_obj = new Libraries\WhitepagesLib();
        $whitepages_obj->reversePhone($param);
        if (!empty($whitepages_obj->response['error'])) {
            $error = $whitepages_obj->response['error']['message'];
        } elseif (!empty($whitepages_obj->response['results'])) {
            $person_obj = new Libraries\Phone($whitepages_obj->response);
            $result_data = $person_obj->formattedResult();
        } else {
            $error = 'No records found';
        }
    } else {
        $error = 'Please enter phone number';
    }
}

