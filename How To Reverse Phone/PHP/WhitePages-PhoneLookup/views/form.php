<div class="search_sec">
    <p>Find by Phone</p>
    <form method="post" action="reverse_phone.php">
        <input type="text" name="phone" placeholder="Phone number" value="<?php if (!empty($_POST['phone'])) {  echo $_POST['phone']; } ?>" id="phone" class="inputbox" >
        <input type="Submit" name="submit" value="Find" class="find_btn" >
        <input type="button" name="clear" value="Clear" class="find_btn"  onclick="clearData();">
    </form>
</div>
<?php include 'results.php';
