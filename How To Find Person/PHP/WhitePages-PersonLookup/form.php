<div class="search_sec">
    <p>Find Person</p>
    <form method="post" action="find_person.php">
        <input type="text" id="person_first_name" name="first_name" placeholder="First Name" value="<?php if (!empty($_POST['first_name'])) {  echo $_POST['first_name']; } ?>" class="inputbox">
        <input type="text" id="person_last_name" name="last_name" placeholder="Last Name"  value="<?php if (!empty($_POST['last_name'])) {  echo $_POST['last_name']; } ?>" class="inputbox">
        <input type="text" id="person_where" name="where" placeholder="City, State, ZIP or Address"  value="<?php if (!empty($_POST['where'])) {  echo $_POST['where']; } ?>"  class="inputbox_address">
        <input type="Submit" name="submit" value="Find" class="find_btn" >
        <input type="button" name="clear" value="Clear" class="find_btn"  onclick="clearData();">
    </form>
</div>
<?php include 'results.php';
