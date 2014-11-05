<?php
include 'whitepages_lib.php';
include 'person.php';

if (isset($_POST['submit'])) {
    if (!empty($_POST['first_name']) && !empty($_POST['last_name']) && !empty($_POST['where'])) {
        $param = array('first_name' => trim($_POST['first_name']), 'last_name' => trim($_POST['last_name']), 'address' => trim($_POST['where']));
        $whitepages_obj = new Libraries\WhitepagesLib();
        $whitepages_obj->findPerson($param);
        if (!empty($whitepages_obj->response['error'])) {
            $error = $whitepages_obj->response['error']['message'];
        } elseif (!empty($whitepages_obj->response['results'])) {
            $person_obj = new Libraries\Person($whitepages_obj->response);
            $result_data = $person_obj->formattedResult();
        } else {
            $error = 'No records found';
        }
    } else {
        if (empty($_POST['where']))
            $error = 'Please enter address';
        if (empty($_POST['last_name']))
            $error = 'Please enter last name';
        if (empty($_POST['first_name']))
            $error = 'Please enter first name';
    }
}

