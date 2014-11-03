<div class="search_sec">
    <p>Find by Address</p>
    <form method="post" action="reverse_address.php">
        <input type="text" name="street_line_1" value="<?php if (!empty($_POST['street_line_1'])) {  echo $_POST['street_line_1']; } ?>" id="street_line_1" class="inputbox_address" placeholder="Street Address or name">
        <input type="text" name="city" value="<?php if (!empty($_POST['city'])) {  echo $_POST['city']; } ?>" id="city" class="inputbox_address" placeholder="City and State or Zip" >
        <input type="Submit" name="submit" value="Find" class="find_btn" >
        <input type="button" name="clear" value="Clear" class="find_btn"  onclick="clearData();">
    </form>
</div>
<?php include 'results.php'; 