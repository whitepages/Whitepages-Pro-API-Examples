<?php if (isset($result->error) OR isset($error)) {
    include 'error.php';
} else {
    include 'result_data.php';
}

