<?php
include 'whitepages_lib.php';
include 'person.php';

if (isset($_POST['submit'])) {
    $param = array(
        'first_name' => trim($_POST['first_name']),
        'last_name' => trim($_POST['last_name']),
        'address' => trim($_POST['where'])
    );
    $whitepages_obj = new Libraries\WhitepagesLib();
    $response = $whitepages_obj->findPerson($param);
    if ($response) {
        if (!empty($response['error'])) {
            $error = $response['error']['message'];
        } else {
            $person_obj = new Libraries\Person($whitepages_obj->response);
            $result_data = $person_obj->formattedResult();
        }
    } else {
        $error = 'No records found';
    }
}

